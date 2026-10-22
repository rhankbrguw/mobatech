part of 'edit_profile_widgets.dart';

class EditProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        CoreStrings.extUbahprofil,
        style: TextStyle(
          color: AppColors.TEXT_WHITE,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.PRIMARY,
      centerTitle: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.BACKGROUND_WHITE),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(CoreStrings.headerLogoAsset, width: 220),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class EditProfileSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const EditProfileSubmitButton({
    super.key,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: CoreStrings.extSimpanperubahan,
      onPressed: onPressed,
      isLoading: isLoading,
      isFullWidth: true,
      size: AppButtonSize.large,
    );
  }
}

class EditProfileSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const EditProfileSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(color: AppColors.BORDER_GREY),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.PRIMARY),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppTypography.sm13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.TEXT_DARK,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}
