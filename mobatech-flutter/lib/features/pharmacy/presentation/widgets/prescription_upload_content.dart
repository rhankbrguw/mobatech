import 'package:flutter/material.dart';
import '../../../../core/constants/strings/pharmacy_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class PrescriptionUploadContent extends StatelessWidget {
  final bool isUploading;
  const PrescriptionUploadContent({super.key, required this.isUploading});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIcon(),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildTextContent()),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: AppColors.PRIMARY,
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.PRIMARY.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: isUploading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.PRIMARY,
                ),
              )
            : const Icon(
                Icons.cloud_upload_outlined,
                color: AppColors.PRIMARY,
                size: 24,
              ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUploading
              ? PharmacyStrings.uploading
              : PharmacyStrings.uploadNewEPrescription,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppTypography.md,
            color: AppColors.TEXT_DARK,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          PharmacyStrings.uploadPrescriptionSubtitle,
          style: TextStyle(
            fontSize: AppTypography.xs,
            color: AppColors.TEXT_GREY,
          ),
        ),
      ],
    );
  }
}
