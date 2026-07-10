import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

import 'edit_medical_data_form_fields.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

void showEditMedicalDataModal(
  BuildContext context,
  WidgetRef ref,
  dynamic user,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.transparent,
    isScrollControlled: true,
    builder: (context) => _EditMedicalDataModalContent(user: user, ref: ref),
  );
}

class _EditMedicalDataModalContent extends StatefulWidget {
  final dynamic user;
  final WidgetRef ref;

  const _EditMedicalDataModalContent({required this.user, required this.ref});

  @override
  State<_EditMedicalDataModalContent> createState() =>
      _EditMedicalDataModalContentState();
}

class _EditMedicalDataModalContentState
    extends State<_EditMedicalDataModalContent> {
  late String _selectedBloodType;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _allergiesController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final validTypes = [
      'A',
      'B',
      'AB',
      'O',
      'A+',
      'B+',
      'AB+',
      'O+',
      'A-',
      'B-',
      'AB-',
      'O-',
    ];
    _selectedBloodType = validTypes.contains(widget.user.bloodType)
        ? (widget.user.bloodType as String)
        : 'O';
    _heightController = TextEditingController(
      text: widget.user.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.user.weight?.toString() ?? '',
    );
    _allergiesController = TextEditingController(
      text: widget.user.allergies ?? '',
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    try {
      await widget.ref
          .read(authStateProvider.notifier)
          .updateProfile(
            widget.user.fullName,
            widget.user.phone,
            null,
            bloodType: _selectedBloodType,
            height: int.tryParse(_heightController.text.trim()),
            weight: int.tryParse(_weightController.text.trim()),
            allergies: _allergiesController.text.trim(),
          );
      widget.ref.invalidate(userProfileProvider);
      if (mounted) _onSuccess();
    } catch (e) {
      if (mounted) _onError(e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _onSuccess() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showSuccess(
      context,
      ProfileStrings.extDatafisikberhasildiperbarui,
    );
  }

  void _onError(dynamic error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showError(context, ErrorHandler.getMessage(error));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Material(
        color: AppColors.backgroundScreen,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: EditMedicalDataFormFields(
            selectedBloodType: _selectedBloodType,
            onBloodTypeChanged: (val) {
              if (val != null) setState(() => _selectedBloodType = val);
            },
            heightController: _heightController,
            weightController: _weightController,
            allergiesController: _allergiesController,
            isSaving: _isSaving,
            onSave: _handleSave,
          ),
        ),
      ),
    );
  }
}
