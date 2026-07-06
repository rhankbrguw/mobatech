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
        children: [_buildIndicator(), const SizedBox(width: 16), _buildDetails()],
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
                ? AppColors.errorRed
                : (isCompleted
                      ? AppColors.primary
                      : AppColors.backgroundWhite),
            shape: BoxShape.circle,
            border: Border.all(
              color: isError
                  ? AppColors.errorRed
                  : (isCompleted ? AppColors.primary : AppColors.dividerGrey),
              width: 1.5,
            ),
          ),
          child: isError
              ? const Icon(Icons.close, size: 14, color: AppColors.textWhite)
              : (isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.textWhite,
                      )
                    : null),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 1.5,
              color: isCompleted ? AppColors.primary : AppColors.dividerGrey,
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
              fontSize: 16,
              color: isError
                  ? AppColors.errorRed
                  : (isCompleted ? AppColors.textDark : AppColors.textGrey),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isCompleted
                  ? AppColors.primary
                  : AppColors.textLightGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: isCompleted ? AppColors.textGrey : AppColors.textLightGrey,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
