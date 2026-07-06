import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobatech_app/core/constants/strings/appointment_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/chat_provider.dart';
import 'chatbot_rename_dialog.dart';

class SessionItem extends ConsumerWidget {
  final Map<String, dynamic> session;
  const SessionItem({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: AppColors.transparent,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.textGrey.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: AppColors.backgroundWhite.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            ref.read(chatMessagesProvider.notifier).loadSession(session['ID']);
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: const CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                Icons.chat_bubble_outline,
                color: AppColors.primary,
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
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
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
                        color: AppColors.errorRed,
                        size: 20,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
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
