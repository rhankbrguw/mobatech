import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import '../../../../core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/edit_profile_widgets.dart';
import '../widgets/edit_profile_form.dart';
import '../widgets/edit_profile_animated_body.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;
  final _formKey = GlobalKey<FormState>();

  String? _imagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  void _loadCurrentData() {
    ref.read(userProfileProvider).whenData((user) {
      if (user != null) {
        _fullNameController.text = user.fullName;
        _emailController.text = user.email;
        String p = user.phone;
        if (p.startsWith('+62')) {
          p = p.substring(3);
        } else if (p.startsWith('62')) {
          p = p.substring(2);
        } else if (p.startsWith('0')) {
          p = p.substring(1);
        }
        _phoneController.text = p;
        _dobController.text = user.dob ?? '';
        setState(() {
          _selectedGender = user.gender;
          _imagePath = user.imagePath;
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path);
    }
  }

  Future<void> _saveProfile() async {
    final user = ref.read(userProfileProvider).value;
    if (user == null || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    try {
      // Explanatory comment for null assertion (!): We proved _imagePath is not null in the condition before it.
      String? pathForUpload = (_imagePath != null && (_imagePath!.startsWith('http'))) ? null : _imagePath;
      await ref.read(authStateProvider.notifier).updateProfile(
            _fullNameController.text.trim(),
            '+62${_phoneController.text.trim()}',
            pathForUpload,
            bloodType: user.bloodType, height: user.height,
            weight: user.weight, allergies: user.allergies,
            dob: _dobController.text.trim(), gender: _selectedGender,
          );
      ref.invalidate(userProfileProvider);
      if (mounted) {
        CustomSnackbar.showSuccess(context, ProfileStrings.extProfilberhasildiperbarui);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) CustomSnackbar.showError(context, ErrorHandler.getMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: const EditProfileAppBar(),
      body: EditProfileAnimatedBody(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: EditProfileForm(
              formKey: _formKey,
              imagePath: _imagePath,
              onPickImage: _pickImage,
              fullNameController: _fullNameController,
              emailController: _emailController,
              phoneController: _phoneController,
              dobController: _dobController,
              selectedGender: _selectedGender,
              onGenderChanged: (gender) =>
                  setState(() => _selectedGender = gender),
              parentContext: context,
              onDateSelected: () => setState(() {}),
              isLoading: _isLoading,
              onSaveProfile: _saveProfile,
            ),
          ),
        ),
      ),
    );
  }
}
