
part of 'appointment_header_widgets.dart';

class AppointmentFilterChips extends ConsumerWidget {
  const AppointmentFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polyclinicsAsync = ref.watch(polyclinicsProvider);
    final selectedId = ref.watch(selectedPolyclinicIdProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: Row(
        children: [
          _buildChip(ref, selectedId, null, 'Semua', Icons.border_all),
          ...polyclinicsAsync.when(
            data: (polyclinics) => polyclinics
                .where((p) => p.isActive)
                .map(
                  (p) => _buildChip(
                    ref,
                    selectedId,
                    p.id,
                    p.name,
                    Icons.local_hospital,
                  ),
                ),
            loading: () => [],
            error: (_, __) => [],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    WidgetRef ref,
    int? selectedId,
    int? polyId,
    String label,
    IconData icon,
  ) {
    final isSelected = selectedId == polyId;
    return GestureDetector(
      onTap: () {
        ref.read(selectedPolyclinicIdProvider.notifier).state = polyId;
      },
      child: AppointmentFilterChip(
        label: label,
        isSelected: isSelected,
        icon: icon,
      ),
    );
  }
}
