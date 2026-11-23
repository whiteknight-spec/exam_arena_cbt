import 'package:flutter/material.dart';

/// Simple, sleek daily streak indicator.
/// Designed without bulky card/block styling: clean fire icon, bold count, and interactive tap feedback.
class StreakBadge extends StatelessWidget {
  final int streakDays;

  const StreakBadge({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final hasStreak = streakDays > 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = hasStreak
        ? const Color(0xFFEA580C) // Vibrant Fire Orange
        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));

    return Tooltip(
      message: hasStreak
          ? '$streakDays Days Daily Streak Active'
          : '0 Day Streak. Practice daily to start your streak flame!',
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              content: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasStreak
                          ? '$streakDays Days Streak! Practice daily to keep the flame burning.'
                          : 'Start your streak flame today! Complete your first CBT drill.',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 15)),
              const SizedBox(width: 3),
              Text(
                '$streakDays',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

