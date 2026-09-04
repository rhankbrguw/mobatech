import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/chat_provider.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class ChatbotHeader extends ConsumerWidget {
  final VoidCallback onShowHistory;

  const ChatbotHeader({super.key, required this.onShowHistory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.PRIMARY,
        borderRadius: BorderRadius.only(
          // AppSpacing
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -10,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset('assets/header_logo.png', width: 160),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md20,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10), // AppSpacing
                    decoration: const BoxDecoration(
                      color: AppColors.BACKGROUND_WHITE,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      color: AppColors.PRIMARY,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CoreStrings.chatHospitalName,
                          style: TextStyle(
                            color: AppColors.TEXT_WHITE,
                            fontSize: AppTypography.xxl,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          CoreStrings.chatSubtitle,
                          style: TextStyle(
                            color: AppColors.TEXT_WHITE,
                            fontSize: AppTypography.sm13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.BACKGROUND_WHITE,
                    ),
                    tooltip: CoreStrings.chatNewTooltip,
                    onPressed: () {
                      ref.read(currentSessionIdProvider.notifier).state = null;
                      ref.read(chatMessagesProvider.notifier).clearMessages();
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.history,
                      color: AppColors.BACKGROUND_WHITE,
                    ),
                    tooltip: CoreStrings.chatHistoryTooltip,
                    onPressed: onShowHistory,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
