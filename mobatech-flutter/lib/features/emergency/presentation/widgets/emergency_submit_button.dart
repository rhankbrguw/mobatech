import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:mobatech_app/core/theme/app_typography.dart';

class EmergencySubmitButton extends StatelessWidget {
  final bool isLoading;
  final bool hasLocation;
  final VoidCallback onSubmit;

  const EmergencySubmitButton({
    super.key,
    required this.isLoading,
    required this.hasLocation,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // AppSpacing
        boxShadow: [
          BoxShadow(
            color: AppColors.ERROR_RED.withAlpha(100),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (isLoading || !hasLocation) ? null : onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ERROR_RED,
          disabledBackgroundColor: AppColors.BUTTON_DISABLED,
          foregroundColor: AppColors.BACKGROUND_WHITE,
          padding: const EdgeInsets.symmetric(vertical: 18), // AppSpacing
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // AppSpacing
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                // AppSpacing
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.BACKGROUND_WHITE,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emergency, size: 22),
                  SizedBox(width: 10), // AppSpacing
                  Text(
                    ProfileStrings.callAmbulance,
                    style: TextStyle(
                      fontSize: AppTypography.md15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
