import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/appointment_strings.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

void showQuickAccessMoreMenu(BuildContext context, List<Widget> items) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.md20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppointmentStrings.menuOthersTitle,
              style: TextStyle(
                fontSize: AppTypography.xl,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              childAspectRatio: MediaQuery.of(context).size.width / 4 / 115,
              children: items,
            ),
          ],
        ),
      );
    },
  );
}
