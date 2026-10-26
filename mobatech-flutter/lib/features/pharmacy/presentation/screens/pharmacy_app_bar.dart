part of 'pharmacy_main_screen.dart';

class _PharmacyAppBar extends StatelessWidget {
  final int cartItemCount;
  final TabController tabController;

  const _PharmacyAppBar({
    required this.cartItemCount,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppColors.PRIMARY,
      iconTheme: const IconThemeData(color: AppColors.TEXT_WHITE),
      centerTitle: true,
      title: const Text(
        PharmacyStrings.pharmacyTitle,
        style: TextStyle(
          color: AppColors.TEXT_WHITE,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        _buildCartAction(context),
        const SizedBox(width: AppSpacing.sm),
      ],
      flexibleSpace: _buildFlexibleSpace(),
      bottom: _buildTabBar(),
    );
  }

  Widget _buildCartAction(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.TEXT_WHITE,
          ),
          onPressed: () => context.push('/pharmacy/cart'),
        ),
        if (cartItemCount > 0)
          Positioned(
            right: AppSpacing.sm,
            top: AppSpacing.sm,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: const BoxDecoration(
                color: AppColors.ERROR_RED,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$cartItemCount',
                style: const TextStyle(
                  color: AppColors.TEXT_WHITE,
                  fontSize: AppTypography.xs,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFlexibleSpace() {
    return FlexibleSpaceBar(
      background: Stack(
        children: [
          Positioned(
            right: -20,
            top: 0,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset('assets/header_logo.png', width: 150),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.BACKGROUND_WHITE,
          borderRadius: BorderRadius.only(
            // AppSpacing
            topLeft: Radius.circular(AppSpacing.borderRadiusXl),
            topRight: Radius.circular(AppSpacing.borderRadiusXl),
          ),
        ),
        child: TabBar(
          controller: tabController,
          labelColor: AppColors.PRIMARY,
          unselectedLabelColor: AppColors.TEXT_GREY,
          indicatorColor: AppColors.PRIMARY,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: CoreStrings.catalogTab),
            Tab(text: CoreStrings.ePrescriptionTab),
            Tab(text: PharmacyStrings.ordersTab),
          ],
        ),
      ),
    );
  }
}
