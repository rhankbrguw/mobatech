import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/strings/core_strings.dart';
import '../providers/chat_provider.dart';

class ChatbotRenameDialog extends ConsumerWidget {
  final int sessionId;
  final String currentTitle;

  const ChatbotRenameDialog({
    super.key,
    required this.sessionId,
    required this.currentTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: currentTitle);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        backgroundColor: AppColors.backgroundWhite.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Ubah Nama Percakapan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nama baru...',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              CoreStrings.extBatal,
              style: TextStyle(color: AppColors.textGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(chatMessagesProvider.notifier)
                    .renameSession(sessionId, controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text(
              'Simpan',
              style: TextStyle(color: AppColors.backgroundWhite),
            ),
          ),
        ],
      ),
    );
  }
}
