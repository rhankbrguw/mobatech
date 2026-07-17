import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MedicalResultDocument extends StatelessWidget {
  final String documentUrl;

  const MedicalResultDocument({super.key, required this.documentUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lampiran Dokumen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.textDark.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: documentUrl.isNotEmpty
                ? Image.network(
                    documentUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: AppColors.backgroundWhite,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: AppColors.backgroundWhite,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: AppColors.textGrey),
                        ),
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
