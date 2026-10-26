part of 'catalog_widgets.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        onSelected: (selected) {
          if (selected) {
            onSelected();
          }
        },
        selectedColor: AppColors.PRIMARY,
        labelStyle: TextStyle(
          fontSize: AppTypography.sm13,
          color: isSelected ? AppColors.TEXT_WHITE : AppColors.TEXT_DARK,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
        backgroundColor: AppColors.BACKGROUND_WHITE,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          side: BorderSide(
            color: isSelected ? AppColors.PRIMARY : AppColors.BORDER_GREY,
          ),
        ),
      ),
    );
  }
}
