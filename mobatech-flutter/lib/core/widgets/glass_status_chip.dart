import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class GlassStatusChip extends StatelessWidget {
  final String status;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const GlassStatusChip({
    super.key,
    required this.status,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.sm12, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    Color baseColor = AppColors.getStatusColor(status);
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        label = 'Menunggu';
        break;
      case 'requested':
        label = 'Meminta Ditebus';
        break;
      case 'approved':
        label = 'Disetujui';
        break;
      case 'processing':
        label = 'Diproses';
        break;
      case 'ready':
        label = 'Siap Diambil';
        break;
      case 'completed':
        label = 'Selesai';
        break;
      case 'cancelled':
        label = 'Dibatalkan';
        break;
      case 'active':
        label = 'Aktif';
        break;
      case 'redeemed':
      case 'ditebus':
        label = 'Selesai';
        break;
      case 'available':
        label = 'Tersedia';
        break;
      case 'unavailable':
        label = 'Tidak Tersedia';
        break;
      case 'dispatched':
        label = 'Menuju Lokasi';
        break;
      case 'arrived':
        label = 'Tiba';
        break;
      default:
        label = status.toUpperCase();
    }

    return Container(
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: baseColor.withValues(alpha: 0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: padding,
            child: Text(
              label,
              style: TextStyle(
                color: baseColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
