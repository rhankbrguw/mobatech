import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../providers/pharmacy_provider.dart';

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

      if (mounted) {
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
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          ErrorStrings.extGagalmengunggahEresep,
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: ElevatedButton.icon(
        onPressed: _isUploading ? null : _uploadPrescription,
        icon: _isUploading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.BACKGROUND_WHITE,
                ),
              )
            : const Icon(Icons.upload_file),
        label: Text(
          _isUploading
              ? PharmacyStrings.uploading
              : PharmacyStrings.uploadNewEPrescription,
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
    );
  }
}
