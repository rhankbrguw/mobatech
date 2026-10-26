import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class BookingBottomBar extends StatelessWidget {
  final bool isBooking;
  final VoidCallback onBook;

  const BookingBottomBar({
    super.key,
    required this.isBooking,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.BACKGROUND_WHITE,
            boxShadow: [
              BoxShadow(
                color: AppColors.SHADOW_COLOR.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              // AppSpacing
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: isBooking ? null : onBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27), // AppSpacing
                  ),
                  elevation: 0,
                ),
                child: isBooking
                    ? const CircularProgressIndicator(
                        color: AppColors.BACKGROUND_WHITE,
                      )
                    : const Text(
                        'Buat Janji Temu',
                        style: TextStyle(
                          fontSize: AppTypography.lg,
                          fontWeight: FontWeight.bold,
                          color: AppColors.BACKGROUND_WHITE,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
