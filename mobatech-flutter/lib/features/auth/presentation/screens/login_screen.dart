import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/auth_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/login_form.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Stack(
                children: [
                  // Top Green Header (Scrolls together with the page)
                  Container(
                    height: constraints.maxHeight * 0.35,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.PRIMARY, AppColors.PRIMARY_DARK],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -20,
                          right: -20,
                          child: Opacity(
                            opacity: 0.2,
                            child: Image.asset(
                              'assets/header_logo.png',
                              width: 220,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 150,
                          right: AppSpacing.xxl,
                          child: Opacity(
                            opacity: 0.8,
                            child: Image.asset('assets/plus.png', width: 32),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                              // AppSpacing
                              bottom: constraints.maxHeight * 0.06,
                            ),
                            child: Image.asset(
                              'assets/doctor.png',
                              height: constraints.maxHeight * 0.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom White Form (Overlaps the green header)
                  Container(
                    margin: EdgeInsets.only(
                      top: constraints.maxHeight * 0.30,
                    ), // AppSpacing
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight * 0.70,
                    ),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.BACKGROUND_WHITE,
                      borderRadius: BorderRadius.only(
                        // AppSpacing
                        topLeft: Radius.circular(AppSizes.borderRadiusCard),
                        topRight: Radius.circular(AppSizes.borderRadiusCard),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.TEXT_DARK,
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xl,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AuthStrings.loginGreeting,
                          style: TextStyle(
                            fontSize: AppTypography.xxl22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.TEXT_DARK,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          AuthStrings.loginSubtitle,
                          style: TextStyle(
                            fontSize: AppTypography.md,
                            color: AppColors.TEXT_GREY,
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        LoginForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
