import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/strings/core_strings.dart';
import '../../../../core/constants/strings/profile_strings.dart';
import '../../../../core/constants/strings/appointment_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/medical_record_card.dart';
import '../widgets/medical_summary_card.dart';

part 'medical_records_screen_parts.dart';
part 'medical_records_appointments_list.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.BACKGROUND_SCREEN,
      appBar: _MedicalRecordsAppBar(),
      body: _MedicalRecordsBody(),
    );
  }
}
