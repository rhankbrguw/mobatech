import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import 'add_family_member_modal_parts.dart';

void showAddMemberModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.transparent,
    isScrollControlled: true,
    builder: (context) => AddFamilyMemberModalContent(ref: ref),
  );
}
