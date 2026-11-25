import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ExitGuardDialog extends StatelessWidget {
  final bool deductsHeart;

  const ExitGuardDialog({super.key, this.deductsHeart = true});

  static Future<bool> show(BuildContext context, {bool deductsHeart = true}) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ExitGuardDialog(deductsHeart: deductsHeart),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF131B2E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.tcsNotAnswered,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Exit CBT Exam Hall?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your competitive CBT session is currently running. Exiting now will terminate your test and all unsubmitted answers will be lost.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF991B1B) : const Color(0xFFFECACA),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.gavel_rounded,
                  size: 16,
                  color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Exiting this session will terminate your exam and unsubmitted answers will be discarded.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFFECACA) : const Color(0xFF991B1B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (deductsHeart) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF4C0519) : const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? const Color(0xFFBE123C) : const Color(0xFFFECDD3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.heart_broken_rounded, size: 16, color: Color(0xFFE11D48)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Discipline Rule: Exiting midway deducts 1 Life (-1 ❤️)!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFFFDA4AF) : const Color(0xFFBE123C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Exit & Forfeit Test',
            style: TextStyle(
              color: AppColors.tcsNotAnswered,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'Resume Test',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
