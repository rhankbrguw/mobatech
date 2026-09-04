import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/appointment_strings.dart';
import 'package:mobatech_app/core/constants/strings/pharmacy_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../widgets/appointments_tab.dart';
import '../widgets/pharmacy_tab.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.BACKGROUND_SCREEN,
        appBar: AppBar(
          title: const Text(
            CoreStrings.historyTitle,
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
          bottom: const TabBar(
            indicatorColor: AppColors.TEXT_WHITE,
            labelColor: AppColors.TEXT_WHITE,
            unselectedLabelColor: AppColors.TEXT_WHITE70,
            tabs: [
              Tab(text: AppointmentStrings.appointmentTab),
              Tab(text: PharmacyStrings.pharmacyTab),
            ],
          ),
        ),
        body: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: const TabBarView(children: [AppointmentsTab(), PharmacyTab()]),
        ),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
      ),
    );
  }
}
