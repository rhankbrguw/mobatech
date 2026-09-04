import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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

class ArticlesNotifier extends AsyncNotifier<List<Article>> {
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
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Article(
        'Pentingnya Minum Air Putih',
        'Kesehatan',
        '3 min',
        'Air putih sangat penting bagi tubuh...',
      ),
      Article(
        'Menjaga Pola Tidur Sehat',
        'Gaya Hidup',
        '5 min',
        'Tidur yang cukup meningkatkan imun...',
      ),
    ];
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingNextPage || !_hasMore) return;
    _isFetchingNextPage = true;
    state = AsyncData(state.value ?? []);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _page++;
      _hasMore = _page < 3;
      final current = state.value ?? [];
      state = AsyncData([
        ...current,
        Article(
          'Artikel Tambahan $_page',
          'Edukasi',
          '4 min',
          'Konten artikel tambahan...',
        ),
      ]);
    } catch (e) {
      state = AsyncData(state.value ?? []);
    } finally {
      _isFetchingNextPage = false;
    }
  }
}

final forYouArticlesProvider =
    AsyncNotifierProvider<ArticlesNotifier, List<Article>>(
      ArticlesNotifier.new,
    );

class PharmacyOrderMock {
  final String title;
  final String status;
  final String date;

  PharmacyOrderMock(this.title, this.status, this.date);
}

final pharmacyHistoryProvider = FutureProvider<List<PharmacyOrderMock>>((
  ref,
) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    PharmacyOrderMock('Pesanan Obat #12345', 'Pending', '12-08-2023'),
    PharmacyOrderMock('Pesanan Obat #12346', 'Completed', '10-08-2023'),
  ];
});
