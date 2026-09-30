import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:mobatech_app/core/theme/app_typography.dart';
import '../../data/models/polyclinic.dart';
import 'polyclinic_card_widgets.dart';

class PolyclinicCard extends ConsumerWidget {
  final Polyclinic poly;

  const PolyclinicCard({super.key, required this.poly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: _buildDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.9),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md20,
                vertical: AppSpacing.sm,
              ),
              title: Text(
                poly.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.lg,
                  color: AppColors.TEXT_DARK,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  poly.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.TEXT_GREY,
                    fontSize: AppTypography.sm13,
                  ),
                ),
              ),
              children: [
                PolyclinicExpandedContent(poly: poly, ref: ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppSpacing.md20),
      boxShadow: [
        BoxShadow(
          color: AppColors.SHADOW_COLOR.withValues(alpha: 0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
