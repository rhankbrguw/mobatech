import 'package:mobatech_app/core/theme/app_typography.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/polyclinic.dart';
import '../../providers/appointment_provider.dart';
import 'polyclinic_card_widgets.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class PolyclinicCard extends ConsumerWidget {
  final Polyclinic poly;

  const PolyclinicCard({super.key, required this.poly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.md20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.85),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: AppColors.TRANSPARENT),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  // AppSpacing
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
                  Container(
                    width: double.infinity,
                    color: AppColors.PRIMARY_LIGHT.withValues(alpha: 0.5),
                    padding: const EdgeInsets.all(AppSpacing.md20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jadwal Praktik:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.TEXT_DARK,
                            fontSize: AppTypography.md,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm12),
                        if (poly.schedules.isEmpty)
                          const Text(
                            'Jadwal belum tersedia',
                            style: TextStyle(
                              color: AppColors.TEXT_GREY,
                              fontSize: AppTypography.sm13,
                            ),
                          )
                        else
                          ...poly.schedules.map(
                            (s) => PolyclinicScheduleItem(schedule: s),
                          ),
                        const SizedBox(height: AppSpacing.md20),
                        SizedBox(
                          // AppSpacing
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(selectedPolyclinicIdProvider.notifier)
                                  .state = poly
                                  .id;
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.PRIMARY,
                              foregroundColor: AppColors.BACKGROUND_WHITE,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ), // AppSpacing
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  14,
                                ), // AppSpacing
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_search, size: 18),
                                SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Lihat Dokter di Poli Ini',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
