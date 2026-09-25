import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/appointment_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/custom_snackbar.dart';
import '../../providers/appointment_provider.dart';

class CancelAppointmentDialog {
  static Future<void> show(BuildContext context, WidgetRef ref, int id) async {
    final reasonController = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppointmentStrings.extBatalkanjanjitemu),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppointmentStrings.extApakahandayakininginmembatalkanjanjitemuini,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Alasan Pembatalan',
                hintText: 'Misal: Perubahan jadwal pribadi',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(CoreStrings.extTidak),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ERROR_RED,
              foregroundColor: AppColors.BACKGROUND_WHITE,
            ),
            child: const Text(CoreStrings.extYabatalkan),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        final repo = ref.read(appointmentRepositoryProvider);
        final reasonText = reasonController.text.trim();
        await repo.cancelAppointment(
          id,
          reason: reasonText.length >= 5 ? reasonText : null,
        );
        ref.invalidate(userAppointmentsProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          CustomSnackbar.showSuccess(
            context,
            AppointmentStrings.extJanjitemuberhasildibatalkan,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          CustomSnackbar.showError(context, ErrorHandler.getMessage(e));
        }
      }
    }
  }
}
