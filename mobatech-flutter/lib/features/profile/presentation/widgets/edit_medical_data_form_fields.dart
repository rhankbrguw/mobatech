import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'edit_medical_fields.dart';
import 'edit_medical_data_modal_parts.dart'; // we will import the public widgets from here

class EditMedicalDataFormFields extends StatelessWidget {
  final String selectedBloodType;
  final ValueChanged<String?> onBloodTypeChanged;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController allergiesController;
  final bool isSaving;
  final VoidCallback onSave;

  const EditMedicalDataFormFields({
    super.key,
    required this.selectedBloodType,
    required this.onBloodTypeChanged,
    required this.heightController,
    required this.weightController,
    required this.allergiesController,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textGrey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          ProfileStrings.extPerbaruidatafisik,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 24),
        BloodTypeDropdown(
          value: selectedBloodType,
          onChanged: onBloodTypeChanged,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MedicalTextField(
                label: 'Tinggi (cm)',
                controller: heightController,
                icon: Icons.height,
                type: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicalTextField(
                label: 'Berat (kg)',
                controller: weightController,
                icon: Icons.monitor_weight_outlined,
                type: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        MedicalTextField(
          label: 'Alergi (Opsional)',
          controller: allergiesController,
          icon: Icons.warning_amber_rounded,
          type: TextInputType.text,
        ),
        const SizedBox(height: 32),
        SaveMedicalDataButton(isSaving: isSaving, onPressed: onSave),
      ],
    );
  }
}
