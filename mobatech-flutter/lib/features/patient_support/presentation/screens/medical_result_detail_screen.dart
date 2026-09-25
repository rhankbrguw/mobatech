import 'package:mobatech_app/core/constants/strings/profile_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/medical_result.dart';
import 'medical_result_detail_widgets.dart';
import 'medical_result_document_widget.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class MedicalResultDetailScreen extends StatelessWidget {
  final MedicalResult result;

  const MedicalResultDetailScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_SCREEN,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MedicalResultHeader(result: result),
            const SizedBox(height: AppSpacing.lg),
            if (result.resultDetails case final details? when details.isNotEmpty)
              MedicalResultDetailsBox(details: details),
            if (result.documentUrl case final docUrl? when docUrl.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              MedicalResultDocument(documentUrl: docUrl),
            ],
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        ProfileStrings.extDetailrekammedis,
        style: TextStyle(
          color: AppColors.TEXT_WHITE,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.PRIMARY,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.TEXT_WHITE),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/header_logo.png', width: 220),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
