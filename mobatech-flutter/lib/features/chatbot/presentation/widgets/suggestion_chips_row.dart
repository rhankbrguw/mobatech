import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/appointment_strings.dart';
import 'suggestion_chip.dart';

class SuggestionChipsRow extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const SuggestionChipsRow({super.key, required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onSuggestionTap(CoreStrings.chatSuggestionSymptoms),
            child: const SuggestionChip(
              icon: Icons.medical_services_outlined,
              label: CoreStrings.chatSuggestionSymptoms,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onSuggestionTap(
              AppointmentStrings.chatSuggestionDoctorSchedule,
            ),
            child: const SuggestionChip(
              icon: Icons.calendar_month_outlined,
              label: AppointmentStrings.chatSuggestionDoctorSchedule,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onSuggestionTap(CoreStrings.chatSuggestionFacilities),
            child: const SuggestionChip(
              icon: Icons.local_hospital_outlined,
              label: CoreStrings.chatSuggestionFacilities,
            ),
          ),
        ],
      ),
    );
  }
}
