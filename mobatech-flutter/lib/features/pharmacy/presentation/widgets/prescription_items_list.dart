import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/prescription.dart';

class PrescriptionItemsList extends StatelessWidget {
  final Prescription prescription;
  const PrescriptionItemsList({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    if (prescription.items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Daftar Obat Resep',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.dividerGrey.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              for (var i = 0; i < prescription.items.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.medication,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prescription.items[i].displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${prescription.items[i].dosageInstruction} • ${prescription.items[i].duration}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundScreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${prescription.items[i].quantity}x',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                if (i < prescription.items.length - 1)
                  const Divider(height: 16, color: AppColors.dividerGrey),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
