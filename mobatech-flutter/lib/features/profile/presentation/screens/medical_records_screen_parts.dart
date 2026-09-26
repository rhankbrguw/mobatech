part of 'medical_records_screen.dart';

class _MedicalRecordsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _MedicalRecordsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        ProfileStrings.extDatarekammedis,
        style: TextStyle(
          color: AppColors.TEXT_WHITE,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.PRIMARY,
      centerTitle: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.BACKGROUND_WHITE),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
      ),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.borderRadiusXl),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(CoreStrings.headerLogoAsset, width: 220),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MedicalRecordsBody extends ConsumerWidget {
  const _MedicalRecordsBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 200) {
          ref.read(userAppointmentsProvider.notifier).fetchNextPage();
        }
        return false;
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSummaryCard(profileAsync, ref),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      CoreStrings.extRiwayatpemeriksaan,
                      style: TextStyle(
                        fontSize: AppTypography.xl,
                        fontWeight: FontWeight.bold,
                        color: AppColors.TEXT_DARK,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ]),
                ),
              ),
              _AppointmentsList(appointmentsAsync: appointmentsAsync),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(AsyncValue<dynamic> profileAsync, WidgetRef ref) {
    return profileAsync.when(
      data: (user) => user != null
          ? MedicalSummaryCard(user: user, ref: ref)
          : const SizedBox(),
      loading: () => const SkeletonLoader(
        width: double.infinity,
        height: 160,
        borderRadius: 24,
      ),
      error: (e, s) => const SizedBox(),
    );
  }
}
