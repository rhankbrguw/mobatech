import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_status_chip.dart';

class BookingQRCard extends StatelessWidget {
  final dynamic appointment;

  const BookingQRCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
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
              fontSize: 16,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          if (appointment.status.toLowerCase() == 'pending' ||
              appointment.status.toLowerCase() == 'approved') ...[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.backgroundScreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderGrey, width: 2),
              ),
              child: const Icon(
                Icons.qr_code_2,
                size: 100,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tunjukkan QR Code ini di mesin antrean',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            const SizedBox(height: 16),
          ] else if (appointment.status.toLowerCase() == 'completed') ...[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Konsultasi telah selesai dilakukan',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            const SizedBox(height: 16),
          ] else ...[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.errorRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cancel,
                size: 60,
                color: AppColors.errorRed,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Janji temu ini telah dibatalkan',
              style: TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
            const SizedBox(height: 16),
          ],
          GlassStatusChip(status: appointment.status, fontSize: 13),
        ],
      ),
    );
  }
}
