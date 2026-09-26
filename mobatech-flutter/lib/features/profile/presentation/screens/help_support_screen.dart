import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/help_support_widgets.dart';
import '../widgets/faq_section.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_SCREEN,
      appBar: AppBar(
        title: const Text(
          ProfileStrings.extBantuandukungan,
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
            // AppSpacing
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
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              physics: const BouncingScrollPhysics(),
              children: const [
                ContactCard(),
                SizedBox(height: AppSpacing.xl),
                Text(
                  'Pertanyaan Umum (FAQ)',
                  style: TextStyle(
                    fontSize: AppTypography.xl,
                    fontWeight: FontWeight.bold,
                    color: AppColors.TEXT_DARK,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                FaqSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
