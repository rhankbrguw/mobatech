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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppointmentStrings.extBatalkanjanjitemu),
        content: const Text(
          AppointmentStrings.extApakahandayakininginmembatalkanjanjitemuini,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(CoreStrings.extTidak),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: AppColors.backgroundWhite,
            ),
            child: const Text(CoreStrings.extYabatalkan),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        final repo = ref.read(appointmentRepositoryProvider);
        await repo.cancelAppointment(id);
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
