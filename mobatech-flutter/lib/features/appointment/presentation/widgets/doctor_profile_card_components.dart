import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/doctor.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class DoctorImageWidget extends StatelessWidget {
  final Doctor doctor;

  const DoctorImageWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      child: doctor.imageUrl.isNotEmpty
          ? Image.network(
              doctor.imageUrl
                  .replaceAll('/svg', '/png')
                  .replaceAll('.svg', '.png'),
              width: 80,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => _fallbackImage(),
            )
          : _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      'assets/doctor.png',
      width: 80,
      height: 100,
      fit: BoxFit.cover,
    );
  }
}

class DoctorInfoWidget extends StatelessWidget {
  final Doctor doctor;

  const DoctorInfoWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doctor.name,
          style: const TextStyle(
            fontSize: AppTypography.xl,
            fontWeight: FontWeight.bold,
            color: AppColors.TEXT_DARK,
          ),
        ),
        const SizedBox(height: 6.0), // AppSpacing
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildBadge(doctor.polyclinicName ?? 'Belum ada poli'),
            _buildBadge(doctor.specialization),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_LIGHT,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: AppTypography.sm,
          color: AppColors.PRIMARY,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DoctorAboutWidget extends StatelessWidget {
  final Doctor doctor;

  const DoctorAboutWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Divider(height: 1, color: AppColors.BACKGROUND_SCREEN),
        ),
        const Text(
          'Tentang Dokter',
          style: TextStyle(
            fontSize: AppTypography.lg,
            fontWeight: FontWeight.bold,
            color: AppColors.TEXT_DARK,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          doctor.description,
          style: const TextStyle(
            fontSize: AppTypography.md,
            color: AppColors.TEXT_GREY,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
