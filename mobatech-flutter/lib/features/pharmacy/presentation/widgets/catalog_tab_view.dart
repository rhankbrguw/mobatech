import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pharmacy_provider.dart';
import 'catalog_tab_view_components.dart';
import 'medicines_list.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class CatalogTabView extends ConsumerStatefulWidget {
  const CatalogTabView({super.key});

  @override
  ConsumerState<CatalogTabView> createState() => _CatalogTabViewState();
}

class _CatalogTabViewState extends ConsumerState<CatalogTabView> {
  int? _selectedCategoryId;
  String? _searchQuery;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final filter = (categoryId: _selectedCategoryId, search: _searchQuery);
      ref.read(medicinesProvider(filter).notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query.isEmpty ? null : query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final filter = (categoryId: _selectedCategoryId, search: _searchQuery);
    final medicinesAsync = ref.watch(medicinesProvider(filter));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(categoriesProvider);
        ref.invalidate(medicinesProvider);
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SearchAndCategories(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (id) =>
                setState(() => _selectedCategoryId = id),
            categoriesAsync: categoriesAsync,
          ),
          MedicinesList(
            medicinesAsync: medicinesAsync,
            filter: filter,
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.lg)),
        ],
      ),
    );
  }
}
