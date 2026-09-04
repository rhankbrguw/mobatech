import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

Marker buildPatientMarker(LatLng position) {
  return Marker(
    point: position,
    width: 80,
    height: 80,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.ERROR_RED,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            boxShadow: [
              BoxShadow(
                color: AppColors.TEXT_DARK.withAlpha(40),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Text(
            CoreStrings.you,
            style: TextStyle(
              color: AppColors.BACKGROUND_WHITE,
              fontSize: AppTypography.xs,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Icon(Icons.location_on, color: AppColors.ERROR_RED, size: 36),
      ],
    ),
  );
}

Marker buildAmbulanceMarker(LatLng position) {
  return Marker(
    point: position,
    width: 80,
    height: 80,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.AMBULANCE_BLUE,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            boxShadow: [
              BoxShadow(
                color: AppColors.TEXT_DARK.withAlpha(40),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Text(
            CoreStrings.ambulance,
            style: TextStyle(
              color: AppColors.BACKGROUND_WHITE,
              fontSize: AppTypography.xs,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6.0), // AppSpacing
          decoration: BoxDecoration(
            color: AppColors.AMBULANCE_BLUE,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.AMBULANCE_BLUE.withAlpha(100),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.local_shipping,
            color: AppColors.BACKGROUND_WHITE,
            size: 22,
          ),
        ),
      ],
    ),
  );
}
