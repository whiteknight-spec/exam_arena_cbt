import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LanguageToggleChip extends StatelessWidget {
  final bool isTamil;
  final VoidCallback onToggle;
  final bool compact;

  const LanguageToggleChip({
    super.key,
    required this.isTamil,
    required this.onToggle,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 5 : 10,
          vertical: compact ? 3 : 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryLight, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.g_translate_rounded, size: compact ? 11 : 14, color: AppColors.primary),
            SizedBox(width: compact ? 2 : 5),
            Text(
              isTamil ? 'தமிழ் (TA)' : 'English (EN)',
              style: TextStyle(
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            if (!compact) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.swap_horiz, size: 12, color: AppColors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
