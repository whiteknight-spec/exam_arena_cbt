import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LanguageToggleChip extends StatelessWidget {
  final bool isTamil;
  final VoidCallback onToggle;

  const LanguageToggleChip({
    super.key,
    required this.isTamil,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryLight, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.g_translate_rounded, size: 14, color: AppColors.primary),
            const SizedBox(width: 5),
            Text(
              isTamil ? 'தமிழ் (TA)' : 'English (EN)',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
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
        ),
      ),
    );
  }
}
