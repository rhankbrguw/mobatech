part of 'settings_widgets.dart';

class SwitchItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const SwitchItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppTypography.lg,
                    fontWeight: FontWeight.w600,
                    color: AppColors.TEXT_DARK,
                  ),
                ),
                const SizedBox(height: 2.0), // AppSpacing
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppTypography.sm,
                    color: AppColors.TEXT_GREY,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.PRIMARY,
          ),
        ],
      ),
    );
  }
}

class ActionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? trailingText;

  const ActionItem({
    super.key,
    required this.title,
    required this.icon,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.TRANSPARENT,
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(children: _buildRowChildren()),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showError(
      context,
      'Fitur "$title" belum tersedia di versi ini.',
    );
  }

  List<Widget> _buildRowChildren() {
    return [
      Icon(icon, color: AppColors.PRIMARY, size: 24),
      const SizedBox(width: AppSpacing.md),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: AppTypography.lg,
            fontWeight: FontWeight.w600,
            color: AppColors.TEXT_DARK,
          ),
        ),
      ),
      if (trailingText != null) ...[
        Text(
          trailingText ?? '',
          style: const TextStyle(
            fontSize: AppTypography.md,
            color: AppColors.TEXT_GREY,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
      const Icon(Icons.chevron_right, color: AppColors.ICON_GREY),
    ];
  }
}
