import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/progression_provider.dart';
import 'hearts_refill_modal.dart';

class HeartsBadge extends ConsumerWidget {
  const HeartsBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressionProvider);
    final hearts = progress.currentHearts;
    final isCritical = hearts <= 1;

    return GestureDetector(
      onTap: () => HeartsRefillModal.show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: isCritical ? const Color(0xFFFEF2F2) : const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isCritical ? const Color(0xFFEF4444) : const Color(0xFFFECDD3),
            width: isCritical ? 1.5 : 1,
          ),
          boxShadow: isCritical
              ? [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hearts > 0 ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: hearts > 0 ? const Color(0xFFE11D48) : const Color(0xFF94A3B8),
              size: 15,
            ),
            const SizedBox(width: 4),
            Text(
              '$hearts/5',
              style: TextStyle(
                color: hearts > 0 ? const Color(0xFFBE123C) : const Color(0xFF64748B),
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
