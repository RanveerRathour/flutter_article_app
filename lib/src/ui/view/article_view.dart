import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/article_model.dart';
import '../../notifier/get_articles_notifier.dart';
import '../widget/custom_error_widget.dart';
import 'article_detail_view.dart';
import 'article_search_view.dart';
import '../../constants/preference_key_manager.dart';
import '../../service/preference_manager_service.dart';

class ArticleView extends ConsumerStatefulWidget {
  const ArticleView({super.key});

  @override
  ConsumerState<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends ConsumerState<ArticleView> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(getArticlesProvider.notifier).getArticles();
      await ref.read(getArticlesProvider.notifier).getFav();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Articles', style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.w500)),
        bottom: TabBar(controller: _tabController, tabs: const <Widget>[Tab(text: 'All Articles'), Tab(text: 'Favorite')]),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute<dynamic>(builder: (BuildContext context) => ArticleSearchView()));
            },
            icon: const Icon(Icons.search, size: 24),
          ),
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Consumer(
              builder: (_, WidgetRef ref, __) {
                final AsyncValue<List<ArticleModel>> asyncData = ref.watch(
                  getArticlesProvider.select((ArticlesState val) => val.browseData),
                );

                final List<String> favIds = ref.watch(getArticlesProvider.select((ArticlesState val) => val.favoriteIds));

                return asyncData.when(
                  data: (List<ArticleModel> data) {
                    if (data.isEmpty) {
                      return const Center(child: Text('No Articles found!', style: TextStyle(fontFamily: 'Roboto', fontSize: 16)));
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(getArticlesProvider.notifier).getArticles();
                      },
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ArticleModel article = data[index];
                          final String? title = article.title;
                          final String? body = article.body;
                          final bool isFavorite = article.id != null && favIds.contains(article.id.toString());

                          if (title == null || body == null) return const SizedBox.shrink();

                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute<dynamic>(builder: (BuildContext context) => ArticleDetailView(title: title, body: body)),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            title,
                                            style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w500),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isFavorite ? Icons.favorite : Icons.favorite_outline,
                                            color: isFavorite ? Colors.red : null,
                                            size: 24,
                                          ),
                                          onPressed: () async {
                                            await ref.read(getArticlesProvider.notifier).toggleFavorite(article);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      body,
                                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 12, fontWeight: FontWeight.w400),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (Object error, StackTrace st) {
                    log('error occurred $error and $st');
                    return Center(
                      child: CustomErrorWidget(
                        onButtonPressed: () async {
                          await ref.read(getArticlesProvider.notifier).getArticles();
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.6)),
                );
              },
            ),
            Consumer(
              builder: (_, WidgetRef ref, __) {
                final AsyncValue<List<ArticleModel>> asyncData = ref.watch(
                  getArticlesProvider.select((ArticlesState val) => val.favoriteAritcle),
                );

                final List<String> favIds = PreferencesManager.preferences.getStringList(PreferenceKeyConstants.favIds) ?? <String>[];

                return asyncData.when(
                  data: (List<ArticleModel> data) {
                    if (data.isEmpty) {
                      return const Center(child: Text('No favorite articles yet', style: TextStyle(fontFamily: 'Roboto', fontSize: 16)));
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(getArticlesProvider.notifier).getFav();
                      },
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ArticleModel article = data[index];
                          final String? title = article.title;
                          final String? body = article.body;
                          final bool isFavorite = article.id != null && favIds.contains(article.id.toString());

                          if (title == null || body == null) return const SizedBox.shrink();

                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute<dynamic>(builder: (BuildContext context) => ArticleDetailView(title: title, body: body)),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            title,
                                            style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w500),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isFavorite ? Icons.favorite : Icons.favorite_outline,
                                            color: isFavorite ? Colors.red : null,
                                            size: 24,
                                          ),
                                          onPressed: () async {
                                            await ref.read(getArticlesProvider.notifier).toggleFavorite(article);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      body,
                                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 12, fontWeight: FontWeight.w400),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (Object error, StackTrace st) {
                    log('error occurred $error and $st');
                    return Center(
                      child: CustomErrorWidget(
                        onButtonPressed: () async {
                          await ref.read(getArticlesProvider.notifier).getFav();
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.6)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
