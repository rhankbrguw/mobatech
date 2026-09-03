import 'package:mobatech_app/core/theme/app_typography.dart';
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

    final bool isProcessing =
        statusLower == 'processing' ||
        statusLower == 'ready' ||
        statusLower == 'completed';
    final bool isReady = statusLower == 'ready' || statusLower == 'completed';
    final bool isCompleted = statusLower == 'completed';
    final bool isCancelled = statusLower == 'cancelled';

    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_LIGHT_GREY,
      appBar: AppBar(
        title: const Text(
          PharmacyStrings.extDetaillacakpesanan,
          style: TextStyle(
            color: AppColors.TEXT_WHITE,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.PRIMARY,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.TEXT_WHITE),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppSpacing.borderRadiusXl),
          ),
        ),
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            // AppSpacing
            bottom: Radius.circular(AppSpacing.borderRadiusXl),
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
            const SizedBox(height: AppSpacing.lg),
            OrderTrackingTimeline(
              isProcessing: isProcessing,
              isReady: isReady,
              isCompleted: isCompleted,
              isCancelled: isCancelled,
              createdAt: order?.createdAt ?? DateTime.now(),
              updatedAt: order?.updatedAt,
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              // AppSpacing
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSpacing.borderRadiusMd,
                    ),
                  ),
                ),
                child: const Text(
                  PharmacyStrings.backToHome,
                  style: TextStyle(
                    fontSize: AppTypography.lg,
                    fontWeight: FontWeight.bold,
                    color: AppColors.TEXT_WHITE,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md20),
          ],
        ),
      ),
    );
  }
}
