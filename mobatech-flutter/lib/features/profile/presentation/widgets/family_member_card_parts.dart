part of 'family_member_card.dart';

class _FamilyMemberHeader extends StatelessWidget {
  final String name;
  final bool isPrimary;
  final String relation;

  const _FamilyMemberHeader({
    required this.name,
    required this.isPrimary,
    required this.relation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: AppTypography.lg,
                  fontWeight: FontWeight.bold,
                  color: AppColors.TEXT_DARK,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isPrimary)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.borderRadiusMd,
                  ),
                ),
                child: const Text(
                  CoreStrings.extUtama,
                  style: TextStyle(
                    color: AppColors.BACKGROUND_WHITE,
                    fontSize: AppTypography.xs,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6.0), // AppSpacing
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.PRIMARY
                : AppColors.PRIMARY_LIGHT.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          ),
          child: Text(
            relation,
            style: TextStyle(
              color: isPrimary ? AppColors.BACKGROUND_WHITE : AppColors.PRIMARY,
              fontSize: AppTypography.xs11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _FamilyMemberDetails extends StatelessWidget {
  final String? dob;
  final String? gender;

  const _FamilyMemberDetails({this.dob, this.gender});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DetailRow(
          icon: Icons.cake_outlined,
          text: Formatters.parseAndFormatDateID(dob ?? '-'),
        ),
        const SizedBox(height: 6.0), // AppSpacing
        _DetailRow(
          icon: gender?.toLowerCase() == 'perempuan'
              ? Icons.female
              : Icons.male,
          text: gender ?? '-',
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.TEXT_GREY),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.TEXT_GREY,
              fontSize: AppTypography.sm13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
