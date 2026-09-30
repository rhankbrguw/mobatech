part of 'onboarding_screen.dart';

class _OnboardingImageSection extends StatelessWidget {
  final Size size;
  final AnimationController slideController;

  const _OnboardingImageSection({
    required this.size,
    required this.slideController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.55,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.PRIMARY, AppColors.PRIMARY_DARK],
        ),
        borderRadius: BorderRadius.only(
          // AppSpacing
          bottomLeft: Radius.circular(AppSizes.borderRadiusCard),
          bottomRight: Radius.circular(AppSizes.borderRadiusCard),
        ),
      ),
      child: Stack(children: [_buildLogoOpacity(), _buildDoctorImage()]),
    );
  }

  Widget _buildLogoOpacity() {
    return Positioned(
      top: -20,
      right: -40,
      child: Opacity(
        opacity: 0.3,
        child: Image.asset('assets/header_logo.png', width: 220),
      ),
    );
  }

  Widget _buildDoctorImage() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: slideController,
                curve: Curves.easeOutCubic,
              ),
            ),
        child: Image.asset('assets/doctor.png', height: size.height * 0.4),
      ),
    );
  }
}

class _OnboardingTextSection extends StatelessWidget {
  final AnimationController fadeController;

  const _OnboardingTextSection({required this.fadeController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: FadeTransition(
          opacity: fadeController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(),
              const SizedBox(height: AppSpacing.md),
              _buildSubtitle(),
              const SizedBox(height: AppSpacing.xxl),
              _buildGetStartedButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      CoreStrings.welcomeTitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: AppTypography.display28,
        fontWeight: FontWeight.bold,
        color: AppColors.TEXT_DARK,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      CoreStrings.welcomeSubtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: AppTypography.md15,
        color: AppColors.TEXT_GREY,
        height: 1.5,
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      // AppSpacing
      width: double.infinity,
      height: AppSizes.buttonHeightLarge,
      child: ElevatedButton(
        onPressed: () => context.go('/login'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.PRIMARY,
          foregroundColor: AppColors.TEXT_WHITE,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSizes.borderRadiusXL,
            ), // AppSpacing
          ),
          elevation: 0,
        ),
        child: const Text(
          CoreStrings.getStarted,
          style: TextStyle(
            fontSize: AppTypography.xl,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
