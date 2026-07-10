import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_status_chip.dart';
import '../../../appointment/data/models/appointment.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class AgendaScheduleInfo extends StatelessWidget {
  final Appointment appointment;
  const AgendaScheduleInfo({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.agendaBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.schedule?.date != null
                ? '${Formatters.formatDateWithDayID((appointment.schedule?.date ?? DateTime.now()))} • ${(appointment.schedule?.startTime ?? '')}'
                : 'Jadwal belum ditentukan',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Status Pendaftaran',
                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
              const SizedBox(width: 10),
              GlassStatusChip(
                status: appointment.status,
                fontSize: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: AppSpacing.xs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
