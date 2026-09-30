import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/booking_qr_card.dart';
import '../widgets/appointment_doctor_card.dart';
import '../widgets/schedule_details_card.dart';
import '../../data/models/appointment.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

import 'package:go_router/go_router.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/theme/app_typography.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_SCREEN,
      appBar: AppBar(
        title: const Text(
          'Detail Janji Temu',
          style: TextStyle(
            color: AppColors.TEXT_WHITE,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.PRIMARY,
        iconTheme: const IconThemeData(color: AppColors.TEXT_WHITE),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppSpacing.borderRadiusXl),
          ),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(AppSpacing.borderRadiusXl),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset(CoreStrings.headerLogoAsset, width: 220),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BookingQRCard(appointment: appointment),
            const SizedBox(height: AppSpacing.lg),
            AppointmentDoctorCard(appointment: appointment),
            const SizedBox(height: AppSpacing.lg),
            ScheduleDetailsCard(appointment: appointment),
            if (appointment.status == 'completed') ...[
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/medical-results'),
                  icon: const Icon(Icons.receipt_long, size: 18),
                  label: const Text(
                    'Lihat Hasil Rekam Medis (RME)',
                    style: TextStyle(
                      fontSize: AppTypography.sm13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY,
                    foregroundColor: AppColors.TEXT_WHITE,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
