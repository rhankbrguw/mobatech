import 'package:mobatech_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/appointment_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/chat_provider.dart';
import 'chatbot_rename_dialog.dart';
import 'package:mobatech_app/core/theme/app_spacing.dart';

class SessionItem extends ConsumerWidget {
  final Map<String, dynamic> session;
  const SessionItem({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: AppColors.TRANSPARENT,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        side: BorderSide(color: AppColors.TEXT_GREY.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: AppColors.BACKGROUND_WHITE.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
        child: InkWell(
          onTap: () {
            ref.read(chatMessagesProvider.notifier).loadSession(session['ID']);
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              // AppSpacing
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            leading: const CircleAvatar(
              backgroundColor: AppColors.PRIMARY_LIGHT,
              child: Icon(
                Icons.chat_bubble_outline,
                color: AppColors.PRIMARY,
                size: 20,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    session['title'] ?? AppointmentStrings.chatNewConversation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppTypography.md,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.PRIMARY,
                        size: 20,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      constraints: const BoxConstraints(),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => ChatbotRenameDialog(
                          sessionId: session['ID'],
                          currentTitle:
                              session['title'] ??
                              AppointmentStrings.chatNewConversation,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.ERROR_RED,
                        size: 20,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      constraints: const BoxConstraints(),
                      onPressed: () => ref
                          .read(chatMessagesProvider.notifier)
                          .deleteSession(session['ID']),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
