import 'package:flutter/material.dart';

/// Simple, sleek accuracy status indicator.
/// Replaces bulky standalone card/block styling with a clean, high-density pill badge.
class AccuracyBadge extends StatelessWidget {
  final double accuracy;

  const AccuracyBadge({super.key, required this.accuracy});

  @override
  Widget build(BuildContext context) {
    final hasData = accuracy > 0.0;
    final isHigh = accuracy >= 80.0;
    final isMid = accuracy >= 60.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = hasData
        ? (isHigh
            ? const Color(0xFF059669)
            : (isMid ? const Color(0xFF0284C7) : const Color(0xFFD97706)))
        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B));

    return Tooltip(
      message: hasData
          ? 'Average Accuracy: ${accuracy.toStringAsFixed(1)}%'
          : 'No test attempts yet. Complete a CBT drill to calculate accuracy!',
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              content: Row(
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasData
                          ? 'Accuracy: ${accuracy.toStringAsFixed(1)}%! Keep precision high to avoid negative marking.'
                          : 'No test attempts yet. Take your first CBT drill to measure accuracy!',
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
              const Text('🎯', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 3),
              Text(
                '${accuracy.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
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
