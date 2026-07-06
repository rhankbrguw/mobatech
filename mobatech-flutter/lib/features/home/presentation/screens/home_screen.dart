import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';

import 'home_screen_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundScreen,
      body: HomeBody(),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
    );
  }
}
