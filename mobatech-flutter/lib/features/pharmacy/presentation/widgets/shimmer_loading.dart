import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.TEXT_GREY.withValues(alpha: 0.3),
      highlightColor: AppColors.BACKGROUND_LIGHT_GREY,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.BACKGROUND_WHITE,
          borderRadius: BorderRadius.circular(borderRadius), // AppSpacing
        ),
      ),
    );
  }
}
