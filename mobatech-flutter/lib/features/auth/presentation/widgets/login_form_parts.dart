part of 'login_form.dart';

class _EmailInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _EmailInputSection({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel(text: AuthStrings.emailLabel),
        const SizedBox(height: AppSpacing.sm),
        AuthTextField(
          hint: AuthStrings.emailHint,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _PasswordInputSection extends StatelessWidget {
  final TextEditingController controller;
  final bool obscurePassword;
  final VoidCallback onChanged;
  final VoidCallback onTogglePassword;

  const _PasswordInputSection({
    required this.controller,
    required this.obscurePassword,
    required this.onChanged,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthLabel(text: AuthStrings.passwordLabel),
        const SizedBox(height: AppSpacing.sm),
        AuthTextField(
          hint: AuthStrings.passwordHint,
          isPassword: true,
          obscureText: obscurePassword,
          controller: controller,
          validator: Validators.validatePassword,
          onChanged: (_) => onChanged(),
          onTogglePassword: onTogglePassword,
        ),
      ],
    );
  }
}

class _LoginFormOptions extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;

  const _LoginFormOptions({
    required this.rememberMe,
    required this.onRememberMeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              // AppSpacing
              width: 24,
              height: 24,
              child: Checkbox(
                value: rememberMe,
                activeColor: AppColors.PRIMARY,
                checkColor: AppColors.TEXT_WHITE,
                side: const BorderSide(
                  color: AppColors.BORDER_GREY,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                onChanged: onRememberMeChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              CoreStrings.rememberMe,
              style: TextStyle(
                color: AppColors.TEXT_GREY,
                fontSize: AppTypography.md,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            AuthStrings.forgotPassword,
            style: TextStyle(
              color: AppColors.PRIMARY,
              fontSize: AppTypography.md,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
