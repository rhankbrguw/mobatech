import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/shimmer_loading.dart';
import 'catalog_widgets.dart';

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

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query.isEmpty ? null : query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final medicinesAsync = ref.watch(medicinesProvider((categoryId: _selectedCategoryId, search: _searchQuery)));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(categoriesProvider);
        ref.invalidate(medicinesProvider);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Cari nama obat...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                categoriesAsync.when(
              data: (categories) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryChip(
                      label: AppStrings.allCategory,
                      isSelected: _selectedCategoryId == null,
                      onSelected: () =>
                          setState(() => _selectedCategoryId = null),
                    ),
                    ...categories.map(
                      (c) => CategoryChip(
                        label: c.name,
                        isSelected: _selectedCategoryId == c.id,
                        onSelected: () =>
                            setState(() => _selectedCategoryId = c.id),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => Row(
                children: List.generate(
                  4,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: ShimmerLoading(
                      width: 80,
                      height: 35,
                      borderRadius: 20,
                    ),
                  ),
                ),
              ),
              error: (err, stack) => const Text(AppStrings.errorLoadCategories),
            ),
              ],
            ),
          ),
        ),
        medicinesAsync.when(
          data: (medicines) => SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MedicineCard(
                    medicine: medicines[index],
                    onAddToCart: () {
                      ref
                          .read(cartProvider.notifier)
                          .addToCart(medicines[index].id, 1);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      CustomSnackbar.showSuccess(context, '${medicines[index].name}${AppStrings.addedToCartSuffix}',);
                    },
                  ),
                );
              }, childCount: medicines.length),
            ),
          ),
          loading: () => SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: ShimmerLoading(
                    width: double.infinity,
                    height: 100,
                    borderRadius: 16,
                  ),
                ),
                childCount: 4,
              ),
            ),
          ),
          error: (err, stack) => const SliverToBoxAdapter(
            child: Center(child: Text(AppStrings.errorLoadMedicines)),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    ),
    );
  }
}
