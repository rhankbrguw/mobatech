part of 'order_tracking_timeline.dart';

class _TimelineItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;
  final bool isLast;
  final bool isError;

  const _TimelineItem({
    required this.title,
    required this.description,
    required this.time,
    required this.isCompleted,
    required this.isLast,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildIndicator(),
          const SizedBox(width: AppSpacing.md),
          _buildDetails(),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: isError
                ? AppColors.ERROR_RED
                : (isCompleted
                      ? AppColors.PRIMARY
                      : AppColors.BACKGROUND_WHITE),
            shape: BoxShape.circle,
            border: Border.all(
              color: isError
                  ? AppColors.ERROR_RED
                  : (isCompleted ? AppColors.PRIMARY : AppColors.DIVIDER_GREY),
              width: 1.5,
            ),
          ),
          child: isError
              ? const Icon(Icons.close, size: 14, color: AppColors.TEXT_WHITE)
              : (isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.TEXT_WHITE,
                      )
                    : null),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 1.5,
              color: isCompleted ? AppColors.PRIMARY : AppColors.DIVIDER_GREY,
            ),
          ),
      ],
    );
  }

  Widget _buildDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppTypography.lg,
              color: isError
                  ? AppColors.ERROR_RED
                  : (isCompleted ? AppColors.TEXT_DARK : AppColors.TEXT_GREY),
            ),
          ),
          const SizedBox(height: 2.0), // AppSpacing
          Text(
            time,
            style: TextStyle(
              fontSize: AppTypography.sm,
              fontWeight: FontWeight.w500,
              color: isCompleted
                  ? AppColors.PRIMARY
                  : AppColors.TEXT_LIGHT_GREY,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: TextStyle(
              fontSize: AppTypography.md,
              color: isCompleted
                  ? AppColors.TEXT_GREY
                  : AppColors.TEXT_LIGHT_GREY,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
