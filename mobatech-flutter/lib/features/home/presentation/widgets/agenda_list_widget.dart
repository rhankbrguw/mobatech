import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/theme/app_colors.dart';
import 'package:mobatech_app/core/utils/error_handler.dart';
import 'package:mobatech_app/core/widgets/skeleton_loader.dart';
import '../../../appointment/providers/appointment_provider.dart';
import 'agenda_card.dart';

class AgendaListWidget extends ConsumerWidget {
  const AgendaListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);

    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                CoreStrings.emptyAgenda,
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appointments.length > 2 ? 2 : appointments.length,
          itemBuilder: (context, index) =>
              AgendaCard(appointment: appointments[index]),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: CardSkeletonLoader(count: 1),
      ),
      error: (err, stack) => Center(child: Text(ErrorHandler.getMessage(err))),
    );
  }
}
