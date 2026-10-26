import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/repositories/for_you_repository.dart';
import '../../domain/models/for_you_article.dart';

final forYouRepositoryProvider = Provider<ForYouRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ForYouRepository(dio);
});

final forYouArticlesProvider =
    AsyncNotifierProvider<ForYouArticlesNotifier, List<ForYouArticle>>(
      ForYouArticlesNotifier.new,
    );

class ForYouArticlesNotifier extends AsyncNotifier<List<ForYouArticle>> {
  ForYouRepository get _repository => ref.read(forYouRepositoryProvider);

  @override
  FutureOr<List<ForYouArticle>> build() async {
    return _repository.getRecommendations();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getRecommendations());
  }

  void toggleLike(String articleId) {
    state = state.whenData((articles) {
      return articles.map((article) {
        if (article.id == articleId) {
          final isLiked = !article.isLiked;
          final count = isLiked
              ? article.likesCount + 1
              : (article.likesCount > 0 ? article.likesCount - 1 : 0);
          return article.copyWith(isLiked: isLiked, likesCount: count);
        }
        return article;
      }).toList();
    });
  }

  void toggleBookmark(String articleId) {
    state = state.whenData((articles) {
      return articles.map((article) {
        if (article.id == articleId) {
          return article.copyWith(isBookmarked: !article.isBookmarked);
        }
        return article;
      }).toList();
    });
  }
}
