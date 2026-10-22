import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_status_chip.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class BookingQRCard extends StatelessWidget {
  final dynamic appointment;

  const BookingQRCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'ID Booking: #${appointment.id.toString().padLeft(6, '0')}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppTypography.lg,
              color: AppColors.TEXT_DARK,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (appointment.status.toLowerCase() == 'pending' ||
              appointment.status.toLowerCase() == 'approved') ...[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.BACKGROUND_SCREEN,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                border: Border.all(color: AppColors.BORDER_GREY, width: 2),
              ),
              child: const Icon(
                Icons.qr_code_2,
                size: 100,
                color: AppColors.PRIMARY,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Tunjukkan QR Code ini di mesin antrean',
              style: TextStyle(
                color: AppColors.TEXT_GREY,
                fontSize: AppTypography.sm,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ] else if (appointment.status.toLowerCase() == 'completed') ...[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.PRIMARY.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 60,
                color: AppColors.PRIMARY,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Konsultasi telah selesai dilakukan',
              style: TextStyle(
                color: AppColors.TEXT_GREY,
                fontSize: AppTypography.sm,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ] else ...[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.ERROR_RED.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cancel,
                size: 60,
                color: AppColors.ERROR_RED,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Janji temu ini telah dibatalkan',
              style: TextStyle(
                color: AppColors.TEXT_GREY,
                fontSize: AppTypography.sm,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          GlassStatusChip(
            status: appointment.status,
            fontSize: AppTypography.sm13,
          ),
        ],
      ),
    );
  }
}
