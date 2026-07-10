import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../../../core/network/dio_client.dart';

class SpecialOffer {
  final String title;
  final String subtitle;
  final Color themeColor;

  SpecialOffer(this.title, this.subtitle, this.themeColor);
}

class SpecialOffersNotifier extends AutoDisposeAsyncNotifier<List<SpecialOffer>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isFetchingNextPage = false;

  bool get hasMore => _hasMore;
  bool get isFetchingNextPage => _isFetchingNextPage;

  @override
  FutureOr<List<SpecialOffer>> build() async {
    _page = 1;
    _hasMore = true;
    _isFetchingNextPage = false;
    final dio = ref.watch(dioProvider);
    final response = await dio.get('/promos', queryParameters: {'page': 1, 'limit': 10});
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
    return data.map((e) {
      String colorStr = e['themeColor'] as String? ?? '';
      Color c = AppColors.primary;
      if (colorStr.isNotEmpty) {
        try {
          c = Color(int.parse(colorStr.replaceAll('#', '0xFF')));
        } catch (_) {}
      }
      return SpecialOffer(e['title'] ?? '', e['subtitle'] ?? '', c);
    }).toList();
  }

  Future<void> fetchNextPage() async {
    if (_isFetchingNextPage || !_hasMore) return;
    _isFetchingNextPage = true;
    state = AsyncData(state.value ?? []);
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/promos', queryParameters: {'page': _page + 1, 'limit': 10});
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
      final nextOffers = data.map((e) {
        String colorStr = e['themeColor'] as String? ?? '';
        Color c = AppColors.primary;
        if (colorStr.isNotEmpty) {
          try {
            c = Color(int.parse(colorStr.replaceAll('#', '0xFF')));
          } catch (_) {}
        }
        return SpecialOffer(e['title'] ?? '', e['subtitle'] ?? '', c);
      }).toList();
      state = AsyncData([...current, ...nextOffers]);
    } catch (e) {
      state = AsyncData(state.value ?? []);
    } finally {
      _isFetchingNextPage = false;
    }
  }
}

final specialOffersProvider = AsyncNotifierProvider.autoDispose<SpecialOffersNotifier, List<SpecialOffer>>(SpecialOffersNotifier.new);
