import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'edit_medical_data_modal.dart';

class MedicalSummaryCard extends StatelessWidget {
  final dynamic user;
  final WidgetRef ref;

  const MedicalSummaryCard({super.key, required this.user, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        border: Border.all(color: AppColors.PRIMARY.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.SHADOW_COLOR.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Divider(height: AppSpacing.md, color: AppColors.BORDER_GREY),
          _buildVitalsRow(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Icon(Icons.health_and_safety_outlined, size: 16, color: AppColors.PRIMARY),
            SizedBox(width: AppSpacing.xs),
            Text(
              'Data Fisik & Kesehatan',
              style: TextStyle(
                fontSize: AppTypography.sm13,
                fontWeight: FontWeight.bold,
                color: AppColors.TEXT_DARK,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => showEditMedicalDataModal(context, ref, user),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(Icons.edit_note, color: AppColors.PRIMARY, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildVitalsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatItem('Gol. Darah', user.bloodType ?? '-', isBlood: true)),
        Expanded(child: _buildStatItem('Tinggi', user.height != null ? '${user.height} cm' : '-')),
        Expanded(child: _buildStatItem('Berat', user.weight != null ? '${user.weight} kg' : '-')),
        Expanded(child: _buildStatItem('Alergi', (user.allergies != null && user.allergies.isNotEmpty) ? user.allergies : 'Nihil')),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, {bool isBlood = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.TEXT_GREY, fontSize: AppTypography.xs10),
        ),
        const SizedBox(height: 3),
        if (isBlood)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.ERROR_RED.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.ERROR_RED,
                fontWeight: FontWeight.bold,
                fontSize: AppTypography.sm13,
              ),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              color: AppColors.TEXT_DARK,
              fontWeight: FontWeight.bold,
              fontSize: AppTypography.sm13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
