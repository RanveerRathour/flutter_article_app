part of 'get_articles_notifier.dart';

class ArticlesState {
  final AsyncValue<List<ArticleModel>> browseData;
  final AsyncValue<List<ArticleModel>> filterdData;
  final AsyncValue<List<ArticleModel>> favoriteAritcle;
  final List<String> favoriteIds;

  ArticlesState({
    this.browseData = const AsyncLoading<List<ArticleModel>>(),
    this.filterdData = const AsyncData<List<ArticleModel>>(<ArticleModel>[]),
    this.favoriteAritcle = const AsyncLoading<List<ArticleModel>>(),
    this.favoriteIds = const <String>[],
  });

  ArticlesState copyWith({
    AsyncValue<List<ArticleModel>>? browseData,
    AsyncValue<List<ArticleModel>>? filterdData,
    AsyncValue<List<ArticleModel>>? favoriteAritcle,
    List<String>? favoriteIds,
  }) {
    return ArticlesState(
      browseData: browseData ?? this.browseData,
      filterdData: filterdData ?? this.filterdData,
      favoriteAritcle: favoriteAritcle ?? this.favoriteAritcle,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}
