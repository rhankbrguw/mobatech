import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';

import '../providers/branch_provider.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_access_grid.dart';
import '../widgets/promo_banner_carousel.dart';
import '../widgets/assistant_card.dart';
import '../widgets/agenda_list_widget.dart';
import '../widgets/hospitals_list_widget.dart';

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: TweenAnimationBuilder<double>(
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
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(branchProvider);
              ref.invalidate(userAppointmentsProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 16),
                  const QuickAccessGrid(),
                  const SizedBox(height: 16),
                  const PromoBannerCarousel(),
                  const SizedBox(height: 20),
                  _buildSectionTitle(CoreStrings.sectionAgenda),
                  const SizedBox(height: 12),
                  const AgendaListWidget(),
                  const SizedBox(height: 20),
                  _buildSectionTitle(CoreStrings.sectionAssistant),
                  const SizedBox(height: 12),
                  const AssistantCard(),
                  const SizedBox(height: 20),
                  _buildSectionTitle(CoreStrings.sectionHospitals),
                  const SizedBox(height: 12),
                  const HospitalsListWidget(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    ),
  );
}
