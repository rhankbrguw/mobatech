import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/formatters.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

part 'order_tracking_item.dart';

class OrderTrackingTimeline extends StatelessWidget {
  final bool isProcessing;
  final bool isReady;
  final bool isCompleted;
  final bool isCancelled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderTrackingTimeline({
    super.key,
    required this.isProcessing,
    required this.isReady,
    required this.isCompleted,
    this.isCancelled = false,
    this.createdAt,
    this.updatedAt,
  });

  String _formatTime(DateTime? date) {
    if (date == null) return 'Menunggu';
    return Formatters.formatDateTimeWithDayID(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    if (isCancelled) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _TimelineItem(
              title: 'Pesanan Dibatalkan',
              description: 'Pesanan ini telah dibatalkan.',
              time: _formatTime(updatedAt ?? createdAt),
              isCompleted: true,
              isLast: true,
              isError: true,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _TimelineItem(
            title: 'Pesanan Masuk',
            description: 'Sistem telah menerima pesanan Anda.',
            time: _formatTime(createdAt),
            isCompleted: true,
            isLast: false,
          ),
          _TimelineItem(
            title: 'Sedang Diproses',
            description: 'Apoteker sedang menyiapkan pesanan Anda.',
            time: isProcessing ? _formatTime(isReady ? createdAt : (updatedAt ?? createdAt)) : 'Menunggu',
            isCompleted: isProcessing,
            isLast: false,
          ),
          _TimelineItem(
            title: 'Pesanan Siap',
            description: 'Pesanan Anda siap untuk diambil / dikirim.',
            time: isReady ? _formatTime(isCompleted ? createdAt : (updatedAt ?? createdAt)) : 'Menunggu',
            isCompleted: isReady,
            isLast: false,
          ),
          _TimelineItem(
            title: 'Selesai',
            description: 'Pesanan telah selesai.',
            time: isCompleted ? _formatTime(updatedAt ?? createdAt) : 'Menunggu',
            isCompleted: isCompleted,
            isLast: true,
          ),
        ],
      ),
    );
  }
}
