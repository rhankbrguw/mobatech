import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/home_strings.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/utils/custom_snackbar.dart';
import 'package:mobatech_app/core/providers/mock_ui_providers.dart';

class OfferClaimButton extends StatelessWidget {
  final SpecialOffer offer;
  const OfferClaimButton({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          CustomSnackbar.showSuccess(
            context,
            PharmacyStrings.extVoucherpromoberhasildiklaim,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: offer.themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          HomeStrings.extKlaimpromo,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }
}
