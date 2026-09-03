import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_colors.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kReleaseMode) {}
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: AppColors.BACKGROUND_SCREEN,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.ERROR_RED,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Terjadi kesalahan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.TEXT_DARK,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              kDebugMode
                  ? details.exceptionAsString()
                  : 'Silakan coba lagi atau hubungi dukungan.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.TEXT_GREY),
            ),
          ],
        ),
      ),
    );
  };

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ProviderScope(child: MobatechApp()),
    ),
  );
}

class MobatechApp extends ConsumerWidget {
  const MobatechApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Mobatech',
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.PRIMARY),
        scaffoldBackgroundColor: AppColors.BACKGROUND_SCREEN,
        useMaterial3: true,
      ),
    );
  }
}
