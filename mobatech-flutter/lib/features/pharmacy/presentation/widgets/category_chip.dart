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
        onSelected: (selected) {
          if (selected) {
            onSelected();
          }
        },
        selectedColor: AppColors.PRIMARY,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.TEXT_WHITE : AppColors.TEXT_DARK,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: AppColors.BACKGROUND_WHITE,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md20),
          side: BorderSide(
            color: isSelected ? AppColors.PRIMARY : AppColors.BORDER_GREY,
          ),
        ),
      ),
    );
  }
}
