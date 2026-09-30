import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'assistant_card_content.dart';

class AssistantCard extends StatelessWidget {
  const AssistantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.PRIMARY,
            AppColors.PRIMARY_LIGHT.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.PRIMARY.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                Icons.smart_toy,
                size: 150,
                color: AppColors.BACKGROUND_WHITE,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: AssistantCardContent()),
                SizedBox(width: AppSpacing.md),
                _AssistantCardIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssistantCardIcon extends StatelessWidget {
  const _AssistantCardIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.smart_toy_outlined,
          size: 48,
          color: AppColors.BACKGROUND_WHITE,
        ),
      ),
    );
  }
}
