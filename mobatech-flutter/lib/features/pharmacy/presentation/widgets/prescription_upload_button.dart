import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../providers/pharmacy_provider.dart';
import 'prescription_upload_content.dart';

class PrescriptionUploadButton extends ConsumerStatefulWidget {
  const PrescriptionUploadButton({super.key});

  @override
  ConsumerState<PrescriptionUploadButton> createState() =>
      _PrescriptionUploadButtonState();
}

class _PrescriptionUploadButtonState
    extends ConsumerState<PrescriptionUploadButton> {
  bool _isUploading = false;

  Future<void> _uploadPrescription() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => _isUploading = true);
    try {
      final success = await ref
          .read(prescriptionsProvider.notifier)
          .uploadPrescription(pickedFile.path);
      _showUploadFeedback(success);
    } catch (_) {
      _showUploadFeedback(false);
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showUploadFeedback(bool success) {
    if (!mounted) return;
    if (success) {
      CustomSnackbar.showSuccess(
        context,
        PharmacyStrings.extEresepberhasildiunggah,
      );
    } else {
      CustomSnackbar.showError(
        context,
        ErrorStrings.extGagalmengunggahEresep,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Material(
        color: AppColors.BACKGROUND_WHITE,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        child: InkWell(
          onTap: _isUploading ? null : _uploadPrescription,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              border: Border.all(
                color: AppColors.PRIMARY.withValues(alpha: 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.SHADOW_COLOR,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: PrescriptionUploadContent(isUploading: _isUploading),
          ),
        ),
      ),
    );
  }
}
