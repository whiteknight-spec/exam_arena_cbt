import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/arena_level.dart';

class LevelMapNode extends StatelessWidget {
  final ArenaLevel level;
  final bool isUnlocked;
  final int currentXp;
  final bool isLast;
  final VoidCallback onTap;

  const LevelMapNode({
    super.key,
    required this.level,
    required this.isUnlocked,
    this.currentXp = 0,
    this.isLast = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color getLevelColor() {
      switch (level) {
        case ArenaLevel.level1:
          return const Color(0xFF0284C7); // Technical Sky Cobalt
        case ArenaLevel.level2:
          return const Color(0xFF6366F1); // Precision Indigo
        case ArenaLevel.level3:
          return const Color(0xFFD97706); // Engineering Amber
        case ArenaLevel.level4:
          return const Color(0xFF059669); // Adaptive Emerald
      }
    }

    final accentColor = getLevelColor();

    IconData getLevelIcon() {
      switch (level) {
        case ArenaLevel.level1:
          return Icons.speed_rounded;
        case ArenaLevel.level2:
          return Icons.timer_outlined;
        case ArenaLevel.level3:
          return Icons.computer_rounded;
        case ArenaLevel.level4:
          return Icons.psychology_rounded;
      }
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131B2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnlocked
                  ? accentColor.withValues(alpha: isDark ? 0.4 : 0.3)
                  : (isDark ? const Color(0xFF1E293B) : AppColors.border),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isUnlocked
                    ? accentColor.withValues(alpha: isDark ? 0.1 : 0.05)
                    : Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isUnlocked
                  ? onTap
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            '🔒 Locked! Reach ${level.requiredXp} XP to unlock Level ${level.levelNumber}: ${level.title} (You have $currentXp XP).',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Node Avatar with Technical Vector Glyph
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? accentColor.withValues(alpha: isDark ? 0.2 : 0.08)
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isUnlocked
                              ? accentColor.withValues(alpha: isDark ? 0.5 : 0.25)
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          isUnlocked ? getLevelIcon() : Icons.lock_outline_rounded,
                          color: isUnlocked
                              ? accentColor
                              : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Level Info & Tamil Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? accentColor.withValues(alpha: 0.15)
                                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isUnlocked
                                        ? accentColor.withValues(alpha: 0.4)
                                        : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                                  ),
                                ),
                                child: Text(
                                  'LEVEL ${level.levelNumber}',
                                  style: TextStyle(
                                    color: isUnlocked
                                        ? accentColor
                                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                    fontFeatures: const [FontFeature.tabularFigures()],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  level.tamilTitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            level.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? (isUnlocked ? Colors.white : const Color(0xFF94A3B8))
                                  : (isUnlocked ? AppColors.textPrimary : const Color(0xFF64748B)),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            level.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Action / Status Badge
                    if (!isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          '${level.requiredXp} XP',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 20,
                          color: accentColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Connecting Ladder Path Indicator
        if (!isLast)
          Container(
            height: 16,
            width: 2,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? accentColor.withValues(alpha: 0.4)
                  : (isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1)),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
      ],
    );
  }
}
