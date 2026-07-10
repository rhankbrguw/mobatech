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

  const OrderTrackingTimeline({
    super.key,
    required this.isProcessing,
    required this.isReady,
    required this.isCompleted,
    this.isCancelled = false,
    this.createdAt,
  });

  String _formatTime(DateTime? date, int addMinutes) {
    if (date == null) return 'Menunggu';
    final target = date.toLocal().add(Duration(minutes: addMinutes));
    final timeStr = '${target.hour.toString().padLeft(2, '0')}:${target.minute.toString().padLeft(2, '0')}';
    return '${Formatters.getDayOfWeekID(target)}, ${Formatters.formatDateID(target)} • $timeStr';
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
              time: _formatTime(createdAt, 0),
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
            time: _formatTime(createdAt, 0),
            isCompleted: true,
            isLast: false,
          ),
          _TimelineItem(
            title: 'Sedang Diproses',
            description: 'Apoteker sedang menyiapkan pesanan Anda.',
            time: isProcessing ? _formatTime(createdAt, 15) : 'Menunggu',
            isCompleted: isProcessing,
            isLast: false,
          ),
          _TimelineItem(
            title: 'Pesanan Siap',
            description: 'Pesanan Anda siap untuk diambil / dikirim.',
            time: isReady ? _formatTime(createdAt, 30) : 'Menunggu',
            isCompleted: isReady,
            isLast: false,
          ),
          _TimelineItem(
            title: 'Selesai',
            description: 'Pesanan telah selesai.',
            time: isCompleted ? _formatTime(createdAt, 45) : 'Menunggu',
            isCompleted: isCompleted,
            isLast: true,
          ),
        ],
      ),
    );
  }
}
