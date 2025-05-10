import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/article_model.dart';
import '../../notifier/get_articles_notifier.dart';
import '../widget/custom_error_widget.dart';
import 'article_detail_view.dart';

class ArticleSearchView extends StatelessWidget {
  ArticleSearchView({super.key});

  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        toolbarHeight: 72,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, _) {
              return TextField(
                controller: _editingController,
                focusNode: FocusNode()..requestFocus(),
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search, color: Color(0xffCAC4D0), size: 24),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffCAC4D0)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffCAC4D0)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onChanged: (String value) async {
                  await ref.read(getArticlesProvider.notifier).searchData(value);
                },
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer(
          builder: (_, WidgetRef ref, _) {
            final AsyncValue<List<ArticleModel>> asyncData = ref.watch(getArticlesProvider.select((ArticlesState val) => val.filterdData));
            return asyncData.when(
              data: (List<ArticleModel> data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String? title = data[index].title;
                    final String? body = data[index].body;
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
                          child: Text(
                            data[index].title ?? '',
                            style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              error: (Object error, StackTrace st) {
                log('error occured in article search $error and $st');
                return Center(
                  child: CustomErrorWidget(
                    customAsset: Image.asset(
                      'assets/images/empty_search.jpg',
                      width: MediaQuery.of(context).size.width - 40,
                      fit: BoxFit.cover,
                    ),
                    showTryAgainButton: false,
                    onButtonPressed: () {},
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.6)),
            );
          },
        ),
      ),
    );
  }
}
