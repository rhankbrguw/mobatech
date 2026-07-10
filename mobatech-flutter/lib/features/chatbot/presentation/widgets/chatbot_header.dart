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
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          CoreStrings.chatHospitalName,
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          CoreStrings.chatSubtitle,
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.backgroundWhite,
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
                      color: AppColors.backgroundWhite,
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
