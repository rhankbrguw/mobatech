import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyAppointments extends StatelessWidget {
  const EmptyAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: AppColors.TEXT_LIGHT_GREY),
          SizedBox(height: AppSpacing.md),
          Text(
            'Belum ada janji temu.',
            style: TextStyle(
              fontSize: AppTypography.lg,
              color: AppColors.TEXT_GREY,
            ),
          ),
        ],
      ),
    );
  }
}
