import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/timer_formatter.dart';

class CountdownTimerBadge extends StatelessWidget {
  final int remainingSeconds;
  final bool isSectionalLock;
  final String? label;
  final bool compact;

  const CountdownTimerBadge({
    super.key,
    required this.remainingSeconds,
    this.isSectionalLock = false,
    this.label,
    this.compact = false,
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
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : 10,
        vertical: compact ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(compact ? 6 : 10),
        border: Border.all(color: color.withValues(alpha: 0.4), width: compact ? 1.0 : 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSectionalLock ? Icons.lock_clock_rounded : Icons.timer_outlined,
            size: compact ? 12 : 15,
            color: color,
          ),
          SizedBox(width: compact ? 2 : 5),
          if (label != null) ...[
            Text(
              '$label: ',
              style: TextStyle(
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
          Text(
            TimerFormatter.formatSeconds(remainingSeconds),
            style: TextStyle(
              fontSize: compact ? 11.5 : 13,
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
