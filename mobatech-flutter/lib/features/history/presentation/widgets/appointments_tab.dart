import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobatech_app/core/constants/strings/appointment_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:mobatech_app/core/utils/error_handler.dart';
import 'package:mobatech_app/core/utils/formatters.dart';
import 'package:mobatech_app/core/widgets/skeleton_loader.dart';
import 'package:mobatech_app/features/appointment/data/models/appointment.dart';
import '../../../appointment/providers/appointment_provider.dart';
import 'history_card.dart';

class AppointmentsTab extends ConsumerStatefulWidget {
  const AppointmentsTab({super.key});

  @override
  ConsumerState<AppointmentsTab> createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends ConsumerState<AppointmentsTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final pos = _scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        ref.read(userAppointmentsProvider.notifier).fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);
    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) return _buildEmptyState();
        final isFetching =
            ref.read(userAppointmentsProvider.notifier).isFetchingNextPage;
        return _buildListView(appointments, isFetching);
      },
      loading: () => const CardSkeletonLoader(count: 3),
      error: (e, _) => _buildErrorState(ErrorHandler.getMessage(e)),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 64, color: AppColors.TEXT_LIGHT_GREY),
          SizedBox(height: AppSpacing.md),
          Text(
            AppointmentStrings.noAppointmentHistory,
            style: TextStyle(color: AppColors.TEXT_GREY, fontSize: AppTypography.md15),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Appointment> appointments, bool isFetchingNextPage) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md20,
          ),
          itemCount: appointments.length + (isFetchingNextPage ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm12),
          itemBuilder: (context, index) {
            if (index == appointments.length) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Center(child: CupertinoActivityIndicator(radius: 14)),
              );
            }
            return _buildAppointmentItem(context, appointments[index]);
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentItem(BuildContext context, Appointment appt) {
    final docName = appt.doctor?.name ?? AppointmentStrings.defaultDoctorName;
    final date = appt.schedule?.date != null
        ? Formatters.formatDateID(appt.schedule!.date!)
        : '-';
    return HistoryCard(
      title: '${AppointmentStrings.appointmentWith} $docName',
      status: appt.status.toUpperCase(),
      date: date,
      icon: Icons.calendar_today_rounded,
      onTap: () => context.push('/appointment/user-appointments'),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: AppColors.TEXT_LIGHT_GREY),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.TEXT_GREY, fontSize: AppTypography.lg),
            ),
          ],
        ),
      ),
    );
  }
}
