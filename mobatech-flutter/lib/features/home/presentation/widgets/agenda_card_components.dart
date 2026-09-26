import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../appointment/data/models/appointment.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class AgendaDoctorInfo extends StatelessWidget {
  final Appointment appointment;
  const AgendaDoctorInfo({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDoctorName(),
                const SizedBox(height: AppSpacing.sm),
                _buildDoctorSpecialization(),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AgendaDoctorImage(appointment: appointment),
        ],
      ),
    );
  }

  Widget _buildDoctorName() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm12,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.AGENDA_HEADER,
        borderRadius: BorderRadius.circular(AppSpacing.md20),
      ),
      child: Text(
        appointment.doctor?.name ?? 'Nama Dokter',
        style: const TextStyle(
          color: AppColors.TEXT_WHITE,
          fontSize: AppTypography.xs,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDoctorSpecialization() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.BORDER_GREY),
        borderRadius: BorderRadius.circular(AppSpacing.md20),
      ),
      child: Text(
        appointment.doctor?.specialization ?? 'Spesialis',
        style: const TextStyle(
          color: AppColors.TEXT_DARK,
          fontSize: AppTypography.xs11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class AgendaDoctorImage extends StatelessWidget {
  final Appointment appointment;
  const AgendaDoctorImage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      child:
          appointment.doctor?.imageUrl != null &&
              !(appointment.doctor?.imageUrl ?? '').contains('.svg')
          ? Image.network(
              (appointment.doctor?.imageUrl ?? ''),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) => _fallbackImage(),
            )
          : _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      'assets/doctor.png',
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
  }
}
