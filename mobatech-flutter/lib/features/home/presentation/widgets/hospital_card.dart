import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/dio_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hospital_card_components.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import '../../../../core/constants/config.dart';

class HospitalCard extends StatelessWidget {
  final String name;
  final String address;
  final String distance;
  final String? imageUrl;
  final String? gmapsLink;

  const HospitalCard({
    super.key,
    required this.name,
    required this.address,
    required this.distance,
    this.imageUrl,
    this.gmapsLink,
  });

  void _launchMaps() async {
    final url = ((gmapsLink?.isNotEmpty ?? false))
        ? Uri.parse(gmapsLink ?? '')
        : Uri.parse(
            '${AppConfig.gmapsSearchUrl}${Uri.encodeComponent('$name $address')}',
          );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      decoration: _buildDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.85),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildImageContainer(),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: HospitalInfoColumn(
                    name: name,
                    address: address,
                    distance: distance,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  width: 1.5,
                  height: 40,
                  color: AppColors.DIVIDER_GREY.withValues(alpha: 0.5),
                ),
                const SizedBox(width: AppSpacing.md),
                HospitalActionButtons(onMapTap: _launchMaps),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      boxShadow: [
        BoxShadow(
          color: AppColors.SHADOW_COLOR.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildImageContainer() {
    final bool hasImage = (imageUrl?.isNotEmpty ?? false);
    final String fullImageUrl = hasImage
        ? ((imageUrl?.startsWith('http') ?? false)
              ? (imageUrl ?? '')
              : '$baseMediaUrl${imageUrl ?? ''}')
        : '';

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.BORDER_GREY,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        image: hasImage
            ? DecorationImage(
                image: NetworkImage(fullImageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !hasImage
          ? const Icon(Icons.local_hospital, color: AppColors.BACKGROUND_WHITE)
          : null,
    );
  }
}
