import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/pharmacy_order.dart';
import '../widgets/order_tracking_header.dart';
import '../widgets/order_tracking_timeline.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class OrderTrackingScreen extends StatelessWidget {
  final PharmacyOrder? order;

  const OrderTrackingScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final orderTitle = order?.orderNumber ?? 'ORD-PH-UNKNOWN';
    final status = order?.status ?? 'Pending';
    final statusLower = status.toLowerCase();

    bool isProcessing =
        statusLower == 'processing' ||
        statusLower == 'ready' ||
        statusLower == 'completed';
    bool isReady = statusLower == 'ready' || statusLower == 'completed';
    bool isCompleted = statusLower == 'completed';
    bool isCancelled = statusLower == 'cancelled';

    return Scaffold(
      backgroundColor: AppColors.backgroundLightGrey,
      appBar: AppBar(
        title: Text(
          PharmacyStrings.extDetaillacakpesanan,
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
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            OrderTrackingHeader(
              order: order,
              orderTitle: orderTitle,
              status: status,
            ),
            const SizedBox(height: 24),
            OrderTrackingTimeline(
              isProcessing: isProcessing,
              isReady: isReady,
              isCompleted: isCompleted,
              isCancelled: isCancelled,
              createdAt: order?.createdAt ?? DateTime.now(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali ke Beranda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
