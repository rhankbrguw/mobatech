import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';

export 'mock_promos_provider.dart';
class Article {
  final String title;
  final String category;
  final String readTime;
  final String content;

  Article(this.title, this.category, this.readTime, this.content);

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      json['title'] ?? '',
      json['category'] ?? '',
      json['readTime'] ?? '',
      json['content'] ?? 'Konten artikel belum tersedia.',
    );
  }
}

class ArticlesNotifier extends AutoDisposeAsyncNotifier<List<Article>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isFetchingNextPage = false;

  bool get hasMore => _hasMore;
  bool get isFetchingNextPage => _isFetchingNextPage;

  @override
  FutureOr<List<Article>> build() async {
    _page = 1;
    _hasMore = true;
    _isFetchingNextPage = false;
    final dio = ref.watch(dioProvider);
    final response = await dio.get('/for-you/recommendations', queryParameters: {'page': 1, 'limit': 10});
    final dynamic responseData = response.data;
    final List data = responseData is Map && responseData.containsKey('data')
        ? responseData['data']
        : responseData as List;
    final meta = responseData is Map && responseData.containsKey('meta')
        ? responseData['meta'] as Map<String, dynamic>?
        : response.extra['meta'] as Map<String, dynamic>?;
    final currentPage = meta?['current_page'] as int? ?? 1;
    final totalPages = meta?['total_pages'] as int? ?? 1;
    _hasMore = currentPage < totalPages;
    return data.map((e) => Article.fromJson(e)).toList();
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingNextPage || !_hasMore) return;
    _isFetchingNextPage = true;
    state = AsyncData(state.value ?? []);
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/for-you/recommendations', queryParameters: {'page': _page + 1, 'limit': 10});
      final dynamic responseData = response.data;
      final List data = responseData is Map && responseData.containsKey('data')
          ? responseData['data']
          : responseData as List;
      final meta = responseData is Map && responseData.containsKey('meta')
          ? responseData['meta'] as Map<String, dynamic>?
          : response.extra['meta'] as Map<String, dynamic>?;
      final currentPage = meta?['current_page'] as int? ?? 1;
      final totalPages = meta?['total_pages'] as int? ?? 1;
      _page++;
      _hasMore = currentPage < totalPages;
      final current = state.value ?? [];
      state = AsyncData([...current, ...data.map((e) => Article.fromJson(e))]);
    } catch (e) {
      state = AsyncData(state.value ?? []);
    } finally {
      _isFetchingNextPage = false;
    }
  }
}

final forYouArticlesProvider = AsyncNotifierProvider.autoDispose<ArticlesNotifier, List<Article>>(ArticlesNotifier.new);

class PharmacyOrderMock {
  final String title;
  final String status;
  final String date;

  PharmacyOrderMock(this.title, this.status, this.date);
}

final pharmacyHistoryProvider = FutureProvider<List<PharmacyOrderMock>>((
  ref,
) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get(
    '/pharmacy/orders',
    queryParameters: {'page': 1, 'limit': 10},
  );
  final dynamic responseData = response.data;
  final List data = responseData is Map && responseData.containsKey('data')
      ? responseData['data']
      : responseData as List;
  return data.map((e) {
    // e.g., e['order_number'], e['status'], e['CreatedAt']
    final dt = DateTime.parse(
      e['CreatedAt'] ?? DateTime.now().toIso8601String(),
    );
    final dateStr = "${dt.day}-${dt.month}-${dt.year}";
    return PharmacyOrderMock(
      'Pesanan Obat #${e['order_number']}',
      e['status'] ?? 'Pending',
      dateStr,
    );
  }).toList();
});

