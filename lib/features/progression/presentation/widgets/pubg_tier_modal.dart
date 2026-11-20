import 'package:flutter/material.dart';
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

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Dark esports tactical theme
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                color: Colors.white24,
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BATTLE TIER RANKING',
                      style: TextStyle(
                        color: Color(0xFF38BDF8),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'PUBG Tier Arena Badges',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Current Tier Showcase Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        currentTier.secondaryColor.withValues(alpha: 0.5),
                        const Color(0xFF1E293B),
                        const Color(0xFF0F172A),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: currentTier.primaryColor.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: currentTier.glowColor.withValues(alpha: 0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'CURRENT BATTLE RANK',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
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
                          color: currentTier.accentColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        currentTier.badgeSubtitle,
                        style: const TextStyle(
                          color: Colors.white70,
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
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '$xpNeeded XP needed',
                              style: TextStyle(
                                color: nextTier.primaryColor,
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
                            backgroundColor: Colors.white12,
                            valueColor: AlwaysStoppedAnimation<Color>(nextTier.primaryColor),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${progress.xp} / ${nextTier.minXp} XP',
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFBBF24)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.emoji_events_rounded, color: Color(0xFFFBBF24), size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Apex Conqueror Rank Achieved! State Rank 1.',
                                style: TextStyle(
                                  color: Color(0xFFFBBF24),
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
                const Text(
                  'ALL 8 PUBG BATTLE TIERS',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
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
                      color: isCurrent
                          ? tier.secondaryColor.withValues(alpha: 0.25)
                          : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCurrent
                            ? tier.primaryColor
                            : isUnlocked
                                ? tier.primaryColor.withValues(alpha: 0.4)
                                : Colors.white10,
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
                                      color: isUnlocked ? tier.accentColor : Colors.white54,
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
                                    const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16)
                                  else
                                    Text(
                                      '${tier.minXp} XP',
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tier.perkDescription,
                                style: TextStyle(
                                  color: isUnlocked ? Colors.white70 : Colors.white38,
                                  fontSize: 11,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${tier.minXp} - ${tier.maxXp >= 999999 ? "∞" : tier.maxXp} XP',
                                style: TextStyle(
                                  color: tier.primaryColor.withValues(alpha: 0.8),
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
