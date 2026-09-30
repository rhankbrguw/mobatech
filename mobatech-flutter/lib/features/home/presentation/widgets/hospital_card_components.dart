import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class HospitalHeaderRow extends StatelessWidget {
  final String name;
  final String distance;
  final String imageUrl;
  final VoidCallback onMapTap;

  const HospitalHeaderRow({
    super.key,
    required this.name,
    required this.distance,
    required this.imageUrl,
    required this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildThumbnail(),
        const SizedBox(width: AppSpacing.sm12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.md15,
                  color: AppColors.TEXT_DARK,
                ),
                maxLines: 2,
                softWrap: true,
              ),
              if (distance.isNotEmpty) ...[
                const SizedBox(height: 4),
                _buildDistanceChip(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.PRIMARY.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        border: Border.all(color: AppColors.BORDER_GREY),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.local_hospital_rounded,
        color: AppColors.PRIMARY,
        size: 22,
      ),
    );
  }

  Widget _buildDistanceChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.PRIMARY.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.near_me_outlined,
            size: 12,
            color: AppColors.PRIMARY,
          ),
          const SizedBox(width: 4),
          Text(
            distance,
            style: const TextStyle(
              fontSize: AppTypography.xs,
              fontWeight: FontWeight.w600,
              color: AppColors.PRIMARY,
            ),
          ),
        ],
      ),
    );
  }
}

class HospitalAddressSection extends StatelessWidget {
  final String address;
  const HospitalAddressSection({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.location_on_outlined,
            size: 16,
            color: AppColors.TEXT_GREY,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(
              fontSize: AppTypography.sm13,
              color: AppColors.TEXT_GREY,
              height: 1.3,
            ),
            maxLines: 3,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
