part of 'appointment_header_widgets.dart';

class AppointmentSearchBar extends ConsumerWidget {
  final TextEditingController searchController;

  const AppointmentSearchBar({super.key, required this.searchController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(child: _buildSearchInput(ref)),
          const SizedBox(width: AppSpacing.sm12),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildSearchInput(WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) =>
                ref.read(searchQueryProvider.notifier).state = value,
            style: const TextStyle(color: AppColors.BACKGROUND_WHITE),
            decoration: const InputDecoration(
              hintText: AppointmentStrings.searchDoctorHint,
              hintStyle: TextStyle(
                color: AppColors.TEXT_WHITE70,
                fontSize: AppTypography.sm13,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.BACKGROUND_WHITE,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14), // AppSpacing
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppointmentSortBottomSheet.show(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
            ),
            child: const Icon(
              Icons.tune,
              color: AppColors.BACKGROUND_WHITE,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
