part of 'profile_screen.dart';

class ProfileSliverAppBar extends StatelessWidget {
  const ProfileSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.PRIMARY,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.xl),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          CoreStrings.extProfilsaya,
          style: TextStyle(
            color: AppColors.TEXT_WHITE,
            fontWeight: FontWeight.bold,
            fontSize: AppTypography.xl,
          ),
        ),
        background: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            // AppSpacing
            bottom: Radius.circular(AppSpacing.xl),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset('assets/header_logo.png', width: 220),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.TRANSPARENT,
                      AppColors.PRIMARY.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileNullUserView extends ConsumerWidget {
  const ProfileNullUserView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AuthStrings.extDataprofiltidakditemukansilakanloginulang,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ERROR_RED,
              foregroundColor: AppColors.BACKGROUND_WHITE,
            ),
            onPressed: () async {
              const secureStorage = FlutterSecureStorage();
              await secureStorage.delete(key: 'jwt_token');
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              // Just use secureStorage to delete

              ref.invalidate(userProfileProvider);
              if (context.mounted) context.go('/login');
            },
            child: const Text(ProfileStrings.extKeluardariakun),
          ),
        ],
      ),
    );
  }
}
