import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/mock_ui_providers.dart';

import '../widgets/offer_detail_app_bar.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_claim_button.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class OfferDetailScreen extends StatelessWidget {
  final SpecialOffer offer;

  const OfferDetailScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      appBar: const OfferDetailAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            OfferCard(offer: offer),
            const SizedBox(height: 32),
            const Text(
              'Syarat & Ketentuan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Promo ini hanya berlaku untuk pengguna terdaftar di aplikasi Mobatech.\n2. Tidak dapat digabungkan dengan promo lainnya.\n3. Harap tunjukkan halaman ini saat Anda berada di resepsionis Rumah Sakit Hermina.\n4. Syarat dan ketentuan dapat berubah sewaktu-waktu.',
              style: TextStyle(
                fontSize: 16,
                height: 1.8,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 40),
            OfferClaimButton(offer: offer),
          ],
        ),
      ),
    );
  }
}
