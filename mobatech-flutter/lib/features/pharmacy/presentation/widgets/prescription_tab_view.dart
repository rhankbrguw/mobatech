import 'package:flutter/cupertino.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pharmacy_provider.dart';
import '../widgets/shimmer_loading.dart';
import 'prescription_card.dart';
import 'prescription_upload_button.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class PrescriptionTabView extends ConsumerStatefulWidget {
  const PrescriptionTabView({super.key});

  @override
  ConsumerState<PrescriptionTabView> createState() =>
      _PrescriptionTabViewState();
}

class _PrescriptionTabViewState extends ConsumerState<PrescriptionTabView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(prescriptionsProvider.notifier).fetchNextPage();
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
    final prescriptionsAsync = ref.watch(prescriptionsProvider);

    return prescriptionsAsync.when(
      data: (prescriptions) {
        final isFetchingNextPage = ref
            .read(prescriptionsProvider.notifier)
            .isFetchingNextPage;
        return CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: PrescriptionUploadButton(),
            ),
            if (prescriptions.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text(CoreStrings.noPrescription)),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == prescriptions.length) {
                      return const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Center(
                          child: CupertinoActivityIndicator(radius: 14),
                        ),
                      );
                    }
                    return PrescriptionCard(prescription: prescriptions[index]);
                  },
                  childCount:
                      prescriptions.length + (isFetchingNextPage ? 1 : 0),
                ),
              ),
          ],
        );
      },
      loading: () => ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, __) => const ShimmerLoading(
          width: double.infinity,
          height: 180,
          borderRadius: 16,
        ),
      ),
      error: (err, stack) =>
          const Center(child: Text(ErrorStrings.errorLoadPrescriptions)),
    );
  }
}
