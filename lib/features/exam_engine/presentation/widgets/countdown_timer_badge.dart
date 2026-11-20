import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/timer_formatter.dart';

class CountdownTimerBadge extends StatelessWidget {
  final int remainingSeconds;
  final bool isSectionalLock;
  final String? label;

  const CountdownTimerBadge({
    super.key,
    required this.remainingSeconds,
    this.isSectionalLock = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    Color getBadgeColor() {
      if (isSectionalLock) {
        if (remainingSeconds <= 60) return const Color(0xFFDC2626); // Red critical
        if (remainingSeconds <= 180) return const Color(0xFFD97706); // Amber
        return const Color(0xFF7C3AED); // Violet for section lock
      }
      if (remainingSeconds <= 120) return AppColors.timerCritical;
      if (remainingSeconds <= 300) return AppColors.timerWarning;
      return AppColors.timerNormal;
    }

    final color = getBadgeColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSectionalLock ? Icons.lock_clock_rounded : Icons.timer_outlined,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 5),
          if (label != null) ...[
            Text(
              '$label: ',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
          Text(
            TimerFormatter.formatSeconds(remainingSeconds),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
