import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/auth_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import 'social_login_button.dart';

class RegisterSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const RegisterSubmitButton({
    super.key,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: AuthStrings.registerButton,
          onPressed: onPressed,
          isLoading: isLoading,
          isFullWidth: true,
          size: AppButtonSize.large,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.dividerGrey, thickness: 1.5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                CoreStrings.orContinueWith,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textLightGrey
                      : AppColors.textGrey,
                  fontSize: 14,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.dividerGrey, thickness: 1.5),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SocialLoginButton(
          text: CoreStrings.continueWithGoogle,
          onPressed: () {
            CustomSnackbar.showInfo(
              context,
              AuthStrings.extFirebaseauthgooglesignincomingsoon,
            );
          },
        ),
      ],
    );
  }
}

class PasswordValidationRules extends StatelessWidget {
  final String password;

  const PasswordValidationRules({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _validationItem(
          context,
          AuthStrings.passMinChars,
          password.length >= 8,
        ),
        _validationItem(
          context,
          AuthStrings.passUppercase,
          RegExp(r'[A-Z]').hasMatch(password),
        ),
        _validationItem(
          context,
          AuthStrings.passLowercase,
          RegExp(r'[a-z]').hasMatch(password),
        ),
        _validationItem(
          context,
          AuthStrings.passDigit,
          RegExp(r'[0-9]').hasMatch(password),
        ),
      ],
    );
  }

  Widget _validationItem(BuildContext context, String text, bool isValid) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.check_circle_outline,
          color: isValid ? AppColors.successGreen : AppColors.iconLightGrey,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isValid
                ? AppColors.getTextPrimary(
                    Theme.of(context).brightness == Brightness.dark,
                  )
                : AppColors.getTextSecondary(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
          ),
        ),
      ],
    );
  }
}
