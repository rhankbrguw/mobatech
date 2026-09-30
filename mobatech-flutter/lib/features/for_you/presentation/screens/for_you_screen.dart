import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/strings/error_strings.dart';
import '../../../../core/providers/mock_ui_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';
import '../widgets/article_card.dart';
import '../widgets/for_you_app_bar.dart';
import '../widgets/for_you_promos_view.dart';
part 'for_you_screen_components.dart';

class ForYouScreen extends ConsumerWidget {
  const ForYouScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArticles = ref.watch(forYouArticlesProvider);
    final asyncPromos = ref.watch(specialOffersProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.BACKGROUND_SCREEN,
        appBar: const ForYouAppBar(),
        body: TabBarView(
          children: [
            _ArticlesListView(asyncArticles: asyncArticles),
            ForYouPromosView(asyncPromos: asyncPromos),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
      ),
    );
  }
}
