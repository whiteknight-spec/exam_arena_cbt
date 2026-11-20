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
    Color getLevelColor() {
      switch (level) {
        case ArenaLevel.level1:
          return AppColors.level1Sprint;
        case ArenaLevel.level2:
          return AppColors.level2Sectional;
        case ArenaLevel.level3:
          return AppColors.level3FullCBT;
        case ArenaLevel.level4:
          return AppColors.level4Gauntlet;
      }
    }

    final accentColor = getLevelColor();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isUnlocked ? accentColor.withValues(alpha: 0.5) : AppColors.border,
              width: isUnlocked ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isUnlocked
                    ? accentColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
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
                    // Node Avatar with Level Icon or Lock
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: isUnlocked
                            ? LinearGradient(
                                colors: [
                                  accentColor.withValues(alpha: 0.2),
                                  accentColor.withValues(alpha: 0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isUnlocked ? null : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isUnlocked
                              ? accentColor.withValues(alpha: 0.4)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isUnlocked ? level.icon : '🔒',
                          style: const TextStyle(fontSize: 26),
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
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isUnlocked ? accentColor : const Color(0xFF94A3B8),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'LEVEL ${level.levelNumber}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  level.tamilTitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isUnlocked
                                        ? AppColors.textSecondary
                                        : const Color(0xFF94A3B8),
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
                              color: isUnlocked ? AppColors.textPrimary : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            level.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isUnlocked ? AppColors.textSecondary : const Color(0xFF94A3B8),
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
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          '${level.requiredXp} XP',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 22,
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
            height: 20,
            width: 3,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: isUnlocked ? accentColor.withValues(alpha: 0.5) : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}
