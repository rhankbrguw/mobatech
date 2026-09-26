import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class AssistantCardContent extends StatelessWidget {
  const AssistantCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          ),
          child: const Text(
            'AI Chatbot',
            style: TextStyle(
              color: AppColors.TEXT_WHITE,
              fontSize: AppTypography.xs,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm12),
        const Text(
          'Asisten Hermina',
          style: TextStyle(
            color: AppColors.TEXT_WHITE,
            fontSize: AppTypography.xxl,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Siap membantu Anda menemukan informasi jadwal dokter & layanan fasilitas RS Hermina.',
          style: TextStyle(
            color: AppColors.TEXT_WHITE.withValues(alpha: 0.9),
            fontSize: AppTypography.sm,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ElevatedButton.icon(
          onPressed: () => context.push('/chatbot'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.BACKGROUND_WHITE,
            foregroundColor: AppColors.PRIMARY,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md20,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.md20),
            ),
          ),
          icon: const Icon(Icons.chat_bubble_outline, size: 16),
          label: const Text(
            'Tanya Sekarang',
            style: TextStyle(
              fontSize: AppTypography.sm13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
