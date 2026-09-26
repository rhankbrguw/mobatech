import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/mock_promos_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import 'promo_card.dart';

class ForYouPromosView extends StatelessWidget {
  final AsyncValue<List<SpecialOffer>> asyncPromos;
  const ForYouPromosView({super.key, required this.asyncPromos});

  @override
  Widget build(BuildContext context) {
    return asyncPromos.when(
      data: (promos) {
        if (promos.isEmpty) {
          return const Center(
            child: Text('Belum ada promo saat ini.', style: TextStyle(color: AppColors.TEXT_GREY)),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          itemCount: promos.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) => PromoCard(offer: promos[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.PRIMARY)),
      error: (e, st) => const Center(
        child: Text('Gagal memuat promo spesial.', style: TextStyle(color: AppColors.TEXT_GREY)),
      ),
    );
  }
}
