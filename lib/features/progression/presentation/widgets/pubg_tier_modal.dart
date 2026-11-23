import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/pubg_tier.dart';
import '../../domain/models/user_progress.dart';
import 'pubg_tier_badge.dart';

class PubgTierModal extends StatelessWidget {
  final UserProgress progress;

  const PubgTierModal({super.key, required this.progress});

  static Future<void> show(BuildContext context, {required UserProgress progress}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PubgTierModal(progress: progress),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTier = PubgTier.fromXp(progress.xp);
    final nextTier = currentTier.nextTier;
    final progressToNext = currentTier.progressToNextTier(progress.xp);
    final xpNeeded = currentTier.xpNeededForNextTier(progress.xp);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASPIRANT MERIT STANDING',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF38BDF8) : AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Aspirant Rank Progression',
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            height: 1,
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Current Tier Showcase Card (Apple HIG Clean Card)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : currentTier.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: currentTier.primaryColor.withValues(alpha: isDark ? 0.6 : 0.35),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: currentTier.primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'CURRENT ASPIRANT RANK',
                          style: TextStyle(
                            color: isDark ? currentTier.accentColor : currentTier.secondaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Large Custom Vector Badge
                      PubgTierBadge(
                        tier: currentTier,
                        size: PubgBadgeSize.large,
                        showGlow: true,
                      ),
                      const SizedBox(height: 14),

                      Text(
                        '${currentTier.title.toUpperCase()} ${currentTier.tierRoman}',
                        style: TextStyle(
                          color: isDark ? currentTier.accentColor : AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${currentTier.tamilTitle} • ${currentTier.badgeSubtitle}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Progress to Next Rank Bar
                      if (nextTier != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Next: ${nextTier.title} ${nextTier.tierRoman}',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : AppColors.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '$xpNeeded XP needed',
                              style: TextStyle(
                                color: isDark ? nextTier.accentColor : currentTier.secondaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progressToNext,
                            minHeight: 10,
                            backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(currentTier.primaryColor),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${progress.xp} / ${nextTier.minXp} XP',
                            style: TextStyle(
                              color: isDark ? Colors.white38 : Colors.grey.shade600,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFBBF24)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.emoji_events_rounded, color: Color(0xFFB45309), size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Apex Conqueror Rank Achieved! State Rank 1.',
                                style: TextStyle(
                                  color: Color(0xFF78350F),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // All Tiers Ladder Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ASPIRANT PROGRESSION LADDER',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      '8 Merit Tiers',
                      style: TextStyle(
                        color: isDark ? const Color(0xFF64748B) : Colors.grey.shade500,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 8 Tiers List
                ...PubgTier.values.map((tier) {
                  final isCurrent = tier == currentTier;
                  final isUnlocked = tier.isUnlocked(progress.xp);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? (isCurrent
                              ? tier.secondaryColor.withValues(alpha: 0.25)
                              : const Color(0xFF1E293B))
                          : (isCurrent
                              ? tier.primaryColor.withValues(alpha: 0.08)
                              : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCurrent
                            ? tier.primaryColor
                            : (isUnlocked
                                ? (isDark ? tier.primaryColor.withValues(alpha: 0.4) : const Color(0xFFCBD5E1))
                                : (isDark ? Colors.white10 : const Color(0xFFE2E8F0))),
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Custom Vector Badge (Medium)
                        PubgTierBadge(
                          tier: tier,
                          size: PubgBadgeSize.medium,
                          isLocked: !isUnlocked,
                          showGlow: isCurrent,
                        ),
                        const SizedBox(width: 14),

                        // Title, Perk & Requirements
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${tier.title} ${tier.tierRoman}',
                                    style: TextStyle(
                                      color: isDark
                                          ? (isUnlocked ? tier.accentColor : Colors.white54)
                                          : (isUnlocked ? AppColors.textPrimary : Colors.grey.shade500),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isCurrent)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: tier.primaryColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'ACTIVE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    )
                                  else if (isUnlocked)
                                    const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 15),
                                        SizedBox(width: 3),
                                        Text(
                                          'Unlocked',
                                          style: TextStyle(
                                            color: Color(0xFF059669),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.lock_outline_rounded,
                                            size: 11,
                                            color: isDark ? Colors.white38 : Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${tier.minXp} XP',
                                            style: TextStyle(
                                              color: isDark ? Colors.white38 : Colors.grey.shade700,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tier.perkDescription,
                                style: TextStyle(
                                  color: isDark
                                      ? (isUnlocked ? Colors.white70 : Colors.white38)
                                      : (isUnlocked ? const Color(0xFF475569) : Colors.grey.shade400),
                                  fontSize: 11,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${tier.minXp} - ${tier.maxXp >= 999999 ? "∞" : tier.maxXp} XP',
                                style: TextStyle(
                                  color: tier.primaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
