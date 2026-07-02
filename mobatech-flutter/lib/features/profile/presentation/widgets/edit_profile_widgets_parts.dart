part of 'edit_profile_widgets.dart';

class EditProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        AppStrings.extUbahprofil,
        style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold),
      ),
      backgroundColor: AppColors.primary,
      centerTitle: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.backgroundWhite),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/header_logo.png', width: 220),
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

  const EditProfileSubmitButton({super.key, required this.isLoading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: AppStrings.extSimpanperubahan,
      onPressed: onPressed,
      isLoading: isLoading,
      isFullWidth: true,
      size: AppButtonSize.large,
    );
  }
}
