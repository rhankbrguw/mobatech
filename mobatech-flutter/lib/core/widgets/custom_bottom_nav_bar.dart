import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  static const String navHome = 'Home';
  static const String navChat = 'Chat';
  static const String navForYou = 'For You';
  static const String navHistory = 'History';
  static const String navProfile = 'Profile';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.PRIMARY,
      unselectedItemColor: AppColors.ICON_GREY,
      currentIndex: currentIndex,
      selectedLabelStyle: textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: textTheme.labelSmall,
      onTap: (index) {
        if (index == 0 && currentIndex != 0) context.go('/home');
        if (index == 1 && currentIndex != 1) context.go('/chatbot');
        if (index == 2 && currentIndex != 2) context.go('/for-you');
        if (index == 3 && currentIndex != 3) context.go('/history');
        if (index == 4 && currentIndex != 4) context.go('/profile');
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: navHome,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble),
          label: navChat,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_outlined),
          label: navForYou,
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: navHistory),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: navProfile,
        ),
      ],
    );
  }
}
