import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../appointment/providers/appointment_provider.dart';
import '../../../appointment/providers/polyclinic_provider.dart';
import 'search_widgets.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class SearchAllResults extends ConsumerWidget {
  final String query;
  const SearchAllResults({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.isEmpty) {
      return const SearchEmptyState(msg: 'Ketik sesuatu untuk mencari');
    }

    final doctorsAsync = ref.watch(doctorsProvider);
    final polyclinicsAsync = ref.watch(polyclinicsProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm12, vertical: AppSpacing.sm),
      children: [
        const SearchSectionHeader(title: 'Dokter'),
        doctorsAsync.when(
          data: (doctors) {
            final filtered = doctors
                .where((d) => d.name.toLowerCase().contains(query))
                .take(2)
                .toList();
            if (filtered.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(CoreStrings.extTidakditemukan),
              );
            }
            return Column(
              children: filtered
                  .map(
                    (d) => SearchItem(
                      icon: Icons.person,
                      title: d.name,
                      subtitle: d.specialization,
                      onTap: () => context.push('/appointment'),
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => Text(ErrorStrings.extErrormemuatdokter),
        ),
        const SizedBox(height: 16),
        const SearchSectionHeader(title: 'Layanan / Poliklinik'),
        polyclinicsAsync.when(
          data: (polys) {
            final filtered = polys
                .where((p) => p.name.toLowerCase().contains(query))
                .take(2)
                .toList();
            if (filtered.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(CoreStrings.extTidakditemukan),
              );
            }
            return Column(
              children: filtered
                  .map(
                    (p) => SearchItem(
                      icon: Icons.local_hospital,
                      title: p.name,
                      subtitle: p.description,
                      onTap: () => context.push('/appointment'),
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => Text(ErrorStrings.extErrormemuatlayanan),
        ),
      ],
    );
  }
}
