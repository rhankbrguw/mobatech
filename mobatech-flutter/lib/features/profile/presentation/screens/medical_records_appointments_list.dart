part of 'medical_records_screen.dart';

class _AppointmentsList extends StatelessWidget {
  final AsyncValue<List<dynamic>> appointmentsAsync;

  const _AppointmentsList({required this.appointmentsAsync});

  @override
  Widget build(BuildContext context) {
    return appointmentsAsync.when(
      data: (appointments) {
        if (appointments.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  ProfileStrings.extBelumadariwayatmedis,
                  style: TextStyle(color: AppColors.TEXT_GREY),
                ),
              ),
            ),
          );
        }
        final sorted = List.of(appointments)
          ..sort((a, b) {
            final dateA = a.schedule?.date ?? DateTime.now();
            final dateB = b.schedule?.date ?? DateTime.now();
            return dateB.compareTo(dateA);
          });

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildItem(sorted[index]),
              childCount: sorted.length,
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              SkeletonLoader(
                width: double.infinity,
                height: 100,
                borderRadius: 20,
              ),
              SizedBox(height: AppSpacing.md),
              SkeletonLoader(
                width: double.infinity,
                height: 100,
                borderRadius: 20,
              ),
            ],
          ),
        ),
      ),
      error: (err, stack) => SliverToBoxAdapter(
        child: Center(child: Text(ErrorHandler.getMessage(err))),
      ),
    );
  }

  Widget _buildItem(dynamic appt) {
    final isDone = appt.status.toLowerCase() == 'completed';
    final dateStr = appt.schedule?.date != null
        ? Formatters.formatDateID(
            appt.schedule?.date ?? DateTime.now(),
          )
        : '-';
    final docSpec = appt.doctor?.specialization ?? 'Umum';
    final docName = appt.doctor?.name ?? AppointmentStrings.defaultDoctorName;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: MedicalRecordCard(
        date: dateStr,
        type: 'Konsultasi $docSpec',
        doctor: docName,
        status: appt.status.toUpperCase(),
        icon: Icons.medical_services_outlined,
        color: isDone ? AppColors.PRIMARY : AppColors.ICON_ORANGE,
      ),
    );
  }
}
