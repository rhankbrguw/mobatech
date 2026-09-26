import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'dart:ui';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../core/theme/app_colors.dart';
import 'location_card_map_preview.dart';

class LocationCard extends StatelessWidget {
  final double? userLat;
  final double? userLng;
  final bool isLocating;
  final String? locationError;
  final MapController formMapController;
  final VoidCallback onDetectLocation;

  const LocationCard({
    super.key,
    required this.userLat,
    required this.userLng,
    required this.isLocating,
    required this.locationError,
    required this.formMapController,
    required this.onDetectLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: AppColors.BACKGROUND_WHITE.withAlpha(217),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    // AppSpacing
                    top: Radius.circular(AppSpacing.borderRadiusLg),
                  ),
                  child: SizedBox(
                    // AppSpacing
                    height: 180,
                    child: LocationCardMapPreview(
                      isLocating: isLocating,
                      locationError: locationError,
                      userLat: userLat,
                      userLng: userLng,
                      mapController: formMapController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14), // AppSpacing
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10), // AppSpacing
                        decoration: BoxDecoration(
                          color: userLat != null
                              ? AppColors.SUCCESS_GREEN.withAlpha(25)
                              : AppColors.ERROR_RED.withAlpha(25),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadiusMd,
                          ),
                        ),
                        child: Icon(
                          userLat != null
                              ? Icons.location_on
                              : Icons.location_searching,
                          color: userLat != null
                              ? AppColors.SUCCESS_GREEN
                              : AppColors.ERROR_RED,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLocating
                                  ? CoreStrings.detectingLocation
                                  : locationError != null
                                  ? CoreStrings.detectFailed
                                  : CoreStrings.locationDetected,
                              style: TextStyle(
                                fontSize: AppTypography.md,
                                fontWeight: FontWeight.w600,
                                color: locationError != null
                                    ? AppColors.ERROR_RED
                                    : AppColors.TEXT_DARK,
                              ),
                            ),
                            const SizedBox(height: 2.0), // AppSpacing
                            Text(
                              isLocating
                                  ? CoreStrings.usingGps
                                  : locationError ??
                                        '${userLat?.toStringAsFixed(6)}, ${userLng?.toStringAsFixed(6)}',
                              style: TextStyle(
                                fontSize: AppTypography.sm,
                                color: locationError != null
                                    ? AppColors.ERROR_RED
                                    : AppColors.TEXT_GREY,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (locationError != null || isLocating)
                        IconButton(
                          onPressed: isLocating ? null : onDetectLocation,
                          icon: Icon(
                            Icons.refresh,
                            color: isLocating
                                ? AppColors.TEXT_LIGHT_GREY
                                : AppColors.PRIMARY,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
