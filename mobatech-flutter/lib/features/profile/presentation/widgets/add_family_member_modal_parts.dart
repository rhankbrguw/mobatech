import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/utils/custom_snackbar.dart';
import 'package:mobatech_app/core/utils/error_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import 'add_family_member_form_fields.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class AddFamilyMemberModalContent extends StatefulWidget {
  final WidgetRef ref;
  const AddFamilyMemberModalContent({super.key, required this.ref});

  @override
  State<AddFamilyMemberModalContent> createState() =>
      _AddFamilyMemberModalContentState();
}

class _AddFamilyMemberModalContentState
    extends State<AddFamilyMemberModalContent> {
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  final _dobController = TextEditingController();
  String _selectedGender = 'Laki-laki';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty ||
        _relationController.text.trim().isEmpty ||
        _dobController.text.trim().isEmpty) {
      _showWarning(ProfileStrings.extHaraplengkapisemuadataterlebihdahulu);
      return;
    }
    setState(() => _isSaving = true);
    try {
      await widget.ref.read(authStateProvider.notifier).addFamilyMember({
        'full_name': _nameController.text.trim(),
        'relationship': _relationController.text.trim(),
        'date_of_birth': _dobController.text.trim(),
        'gender': _selectedGender,
      });
      widget.ref.invalidate(userProfileProvider);
      if (mounted) _onSuccess();
    } catch (e) {
      if (mounted) _onError(e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showWarning(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showWarning(context, msg);
  }

  void _onSuccess() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showSuccess(
      context,
      ProfileStrings.extAnggotakeluargaberhasilditambahkan,
    );
  }

  void _onError(dynamic error) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    CustomSnackbar.showError(context, ErrorHandler.getMessage(error));
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.backgroundWhite,
            onSurface: AppColors.textDark,
          ),
        ),
        child: child ?? const SizedBox(),
      ),
    );
    if (date != null && mounted) {
      setState(() {
        _dobController.text =
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      });
    }
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
          child: AddFamilyMemberFormFields(
            nameController: _nameController,
            relationController: _relationController,
            dobController: _dobController,
            selectedGender: _selectedGender,
            onGenderChanged: (gender) {
              setState(() => _selectedGender = gender);
            },
            onPickDate: _pickDate,
            isSaving: _isSaving,
            onSave: _handleSave,
          ),
        ),
      ),
    );
  }
}
