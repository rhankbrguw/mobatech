part of 'catalog_widgets.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onAddToCart;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(
          color: AppColors.BORDER_GREY,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 95,
                child: MedicineCardImage(medicine: medicine),
              ),
              Expanded(
                child: MedicineCardDetails(
                  medicine: medicine,
                  onAddToCart: onAddToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
