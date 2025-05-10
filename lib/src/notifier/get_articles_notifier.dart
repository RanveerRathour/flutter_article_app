import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../constants/preference_key_manager.dart';
import '../model/article_model.dart';
import '../service/preference_manager_service.dart';

part 'article_state.dart';

final StateNotifierProvider<ArticlesNotifier, ArticlesState> getArticlesProvider = StateNotifierProvider<ArticlesNotifier, ArticlesState>((
  _,
) {
  return ArticlesNotifier();
});

final ProviderFamily<bool, int?> favoriteStatusProvider = Provider.family<bool, int?>((Ref ref, int? articleId) {
  if (articleId == null) return false;

  final List<String> favIds = PreferencesManager.preferences.getStringList(PreferenceKeyConstants.favIds) ?? <String>[];
  return favIds.contains(articleId.toString());
});

class ArticlesNotifier extends StateNotifier<ArticlesState> {
  ArticlesNotifier() : super(ArticlesState()) {
    _loadFavoriteIds();
  }

  void _loadFavoriteIds() {
    final List<String> favIds = PreferencesManager.preferences.getStringList(PreferenceKeyConstants.favIds) ?? <String>[];
    state = state.copyWith(favoriteIds: favIds);
  }

  Future<void> getArticles() async {
    state = state.copyWith(browseData: const AsyncLoading<List<ArticleModel>>());
    try {
      final http.Response res = await http.get(
        Uri(scheme: 'https', host: 'jsonplaceholder.typicode.com', path: 'posts'),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(res.body) as List<dynamic>;
        final List<ArticleModel> list = decoded.map((dynamic e) => ArticleModel.fromJson(e as Map<String, dynamic>)).toList();
        state = state.copyWith(browseData: AsyncData<List<ArticleModel>>(list));

        await getFav();
      } else {
        throw Exception('[getArticles] Failed: ${res.statusCode} ${res.reasonPhrase}\n${res.body}');
      }
    } catch (e, st) {
      log('error in getArticles repo $e and $st');
      state = state.copyWith(browseData: AsyncError<List<ArticleModel>>(e, st));
    }
  }

  Future<void> searchData(String data) async {
    if (state.browseData is! AsyncData || data.isEmpty) {
      state = state.copyWith(filterdData: const AsyncData<List<ArticleModel>>(<ArticleModel>[]));
      return;
    }

    final List<ArticleModel> list = state.browseData.asData!.value;

    state = state.copyWith(
      filterdData: AsyncData<List<ArticleModel>>(
        list.where((ArticleModel e) => e.title != null && e.title!.toLowerCase().contains(data.toLowerCase())).toList(),
      ),
    );
  }

  Future<void> getFav() async {
    if (state.browseData is! AsyncData) {
      state = state.copyWith(favoriteAritcle: const AsyncData<List<ArticleModel>>(<ArticleModel>[]));
      return;
    }

    state = state.copyWith(favoriteAritcle: const AsyncLoading<List<ArticleModel>>());
    try {
      final List<String> favIds = state.favoriteIds;
      final List<ArticleModel> list = state.browseData.asData!.value;

      state = state.copyWith(
        favoriteAritcle: AsyncData<List<ArticleModel>>(
          list.where((ArticleModel e) => e.id != null && favIds.contains(e.id.toString())).toList(),
        ),
      );
    } catch (e, st) {
      log('error in getFav $e and $st');
      state = state.copyWith(favoriteAritcle: AsyncError<List<ArticleModel>>(e, st));
    }
  }

  bool isFavorite(int? articleId) {
    if (articleId == null) return false;
    return state.favoriteIds.contains(articleId.toString());
  }

  Future<void> toggleFavorite(ArticleModel article) async {
    if (article.id == null) return;

    final List<String> favIds = List<String>.from(state.favoriteIds);
    final String articleId = article.id.toString();

    if (favIds.contains(articleId)) {
      favIds.remove(articleId);
    } else {
      favIds.add(articleId);
    }

    state = state.copyWith(favoriteIds: favIds);

    await PreferencesManager.preferences.setStringList(PreferenceKeyConstants.favIds, favIds);

    await getFav();
  }
}
