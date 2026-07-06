import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/home_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';

class OfferDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OfferDetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        HomeStrings.extDetailpromo,
        style: TextStyle(
          color: AppColors.textWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.textWhite),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
