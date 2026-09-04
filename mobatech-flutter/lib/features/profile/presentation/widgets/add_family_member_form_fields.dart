import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'add_family_member_modal_widgets.dart';
import 'modal_text_field.dart';

class AddFamilyMemberFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController relationController;
  final TextEditingController dobController;
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onPickDate;
  final bool isSaving;
  final VoidCallback onSave;

  const AddFamilyMemberFormFields({
    super.key,
    required this.nameController,
    required this.relationController,
    required this.dobController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onPickDate,
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
              color: AppColors.TEXT_GREY.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.0), // AppSpacing
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          ProfileStrings.extTambahanggotakeluarga,
          style: TextStyle(
            fontSize: AppTypography.xl,
            fontWeight: FontWeight.bold,
            color: AppColors.TEXT_DARK,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ModalTextField(
          label: 'Nama Lengkap',
          controller: nameController,
          icon: Icons.person_outline,
          type: TextInputType.name,
        ),
        const SizedBox(height: AppSpacing.md),
        ModalTextField(
          label: 'Hubungan (Anak, Istri, Suami, dll)',
          controller: relationController,
          icon: Icons.family_restroom,
          type: TextInputType.text,
        ),
        const SizedBox(height: AppSpacing.md),
        ModalTextField(
          label: 'Tanggal Lahir (YYYY-MM-DD)',
          controller: dobController,
          icon: Icons.cake_outlined,
          type: TextInputType.datetime,
          readOnly: true,
          onTap: onPickDate,
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          CoreStrings.extJeniskelamin,
          style: TextStyle(
            color: AppColors.TEXT_GREY,
            fontSize: AppTypography.sm,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: GenderOptionButton(
                text: 'Laki-laki',
                icon: Icons.male,
                isSelected: selectedGender == 'Laki-laki',
                onTap: () => onGenderChanged('Laki-laki'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GenderOptionButton(
                text: 'Perempuan',
                icon: Icons.female,
                isSelected: selectedGender == 'Perempuan',
                onTap: () => onGenderChanged('Perempuan'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SaveFamilyMemberButton(isSaving: isSaving, onPressed: onSave),
      ],
    );
  }
}
