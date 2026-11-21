import 'package:flutter/material.dart';

/// Simple, sleek daily streak indicator.
/// Designed without bulky card/block styling: clean fire icon, bold count, and interactive tap feedback.
class StreakBadge extends StatelessWidget {
  final int streakDays;

  const StreakBadge({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '$streakDays Days Daily Streak Active',
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
                      '$streakDays Days Streak! Practice daily to keep the flame burning.',
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
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFEA580C), // Vibrant Fire Orange
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

