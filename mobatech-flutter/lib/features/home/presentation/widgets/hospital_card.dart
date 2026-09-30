import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/config.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hospital_card_components.dart';
import 'hospital_footer_action.dart';

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
    final hasLink = gmapsLink?.isNotEmpty ?? false;
    final fallbackUrl =
        '${AppConfig.gmapsSearchUrl}${Uri.encodeComponent('$name $address')}';
    final url = Uri.parse(hasLink ? (gmapsLink ?? '') : fallbackUrl);

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
          child: Material(
            color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.9),
            child: InkWell(
              onTap: _launchMaps,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HospitalHeaderRow(
                      name: name,
                      distance: distance,
                      imageUrl: _resolveImageUrl(),
                      onMapTap: _launchMaps,
                    ),
                    const SizedBox(height: AppSpacing.sm12),
                    HospitalAddressSection(address: address),
                    const SizedBox(height: AppSpacing.sm12),
                    HospitalFooterAction(onMapTap: _launchMaps),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
      border: Border.all(
        color: AppColors.BORDER_GREY.withValues(alpha: 0.8),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.SHADOW_COLOR.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  String _resolveImageUrl() {
    final hasImg = imageUrl?.isNotEmpty ?? false;
    if (!hasImg) return '';
    final isHttp = imageUrl?.startsWith('http') ?? false;
    return isHttp ? (imageUrl ?? '') : '$baseMediaUrl${imageUrl ?? ''}';
  }
}
