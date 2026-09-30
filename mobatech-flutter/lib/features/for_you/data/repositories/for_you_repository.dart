import 'package:dio/dio.dart';
import '../../domain/models/for_you_article.dart';

class ForYouRepository {
  final Dio _dio;

  ForYouRepository(this._dio);

  Future<List<ForYouArticle>> getRecommendations() async {
    try {
      final response = await _dio.get('/for-you/recommendations');
      final rawData = response.data;
      if (rawData is Map<String, dynamic> && rawData['data'] is List) {
        final list = rawData['data'] as List;
        return list
            .map((item) => ForYouArticle.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      if (rawData is List) {
        return rawData
            .map((item) => ForYouArticle.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException {
      rethrow;
    }
  }
}
