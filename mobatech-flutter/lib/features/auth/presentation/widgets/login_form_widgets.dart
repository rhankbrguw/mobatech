import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/auth_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import 'social_login_button.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class LoginSubmitButton extends StatelessWidget {
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  const LoginSubmitButton({
    super.key,
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: AuthStrings.loginButton,
      onPressed: isEnabled ? onPressed : null,
      isLoading: isLoading,
      isFullWidth: true,
      size: AppButtonSize.large,
    );
  }
}

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.dividerGrey, thickness: 1.5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
        const SizedBox(height: 16),
        SocialLoginButton(
          text: CoreStrings.continueWithGoogle,
          onPressed: () {
            CustomSnackbar.showInfo(
              context,
              AuthStrings.extFirebaseauthgooglesignincomingsoon,
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AuthStrings.noAccount,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textLightGrey
                    : AppColors.textGrey,
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/register'),
              child: const Text(
                AuthStrings.registerLink,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
