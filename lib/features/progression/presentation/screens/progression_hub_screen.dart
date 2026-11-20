import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/progression_provider.dart';
import '../../domain/models/arena_level.dart';
import '../widgets/xp_bar.dart';
import '../widgets/streak_badge.dart';
import '../widgets/exam_selector_sheet.dart';
import '../widgets/level_map_node.dart';
import '../../../exam_engine/presentation/screens/cbt_exam_screen.dart';
import '../../../ai_generator/presentation/screens/ai_gauntlet_screen.dart';
import 'test_history_screen.dart';
import '../widgets/pubg_tier_badge.dart';
import '../widgets/pubg_tier_modal.dart';
import '../widgets/hearts_badge.dart';
import '../widgets/hearts_refill_modal.dart';

class ProgressionHubScreen extends ConsumerWidget {
  const ProgressionHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressionProvider);
    final notifier = ref.read(progressionProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.military_tech_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Exam Arena CBT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            StreakBadge(streakDays: progress.streakDays),
            const SizedBox(width: 4),
            const HeartsBadge(),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.history_rounded, color: AppColors.primary),
              tooltip: 'Test History & Analytics',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TestHistoryScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Exam Switcher Card
            InkWell(
              onTap: () {
                ExamSelectorSheet.show(
                  context,
                  currentExam: progress.selectedExam,
                  onSelect: (newExam) => notifier.selectExam(newExam),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Color(progress.selectedExam.badgeColorHex),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Color(progress.selectedExam.badgeColorHex).withValues(alpha: 0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TARGET COMPETITIVE EXAM',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            progress.selectedExam.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${progress.selectedExam.totalQuestions} Qs • ${progress.selectedExam.totalDurationMinutes} mins • ${progress.selectedExam.hasOptionE ? "5 Options A–E (TNPSC)" : "4 Options A–D"}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Change',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // User Animated XP Progress Bar
            XpBar(progress: progress),
            const SizedBox(height: 12),

            // PUBG Tier Showcase Quick Tile
            InkWell(
              onTap: () => PubgTierModal.show(context, progress: progress),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      progress.pubgTier.secondaryColor.withValues(alpha: 0.25),
                      const Color(0xFF0F172A),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: progress.pubgTier.primaryColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    PubgTierBadge(
                      tier: progress.pubgTier,
                      size: PubgBadgeSize.small,
                      showGlow: false,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${progress.pubgTier.title.toUpperCase()} ${progress.pubgTier.tierRoman}',
                                style: TextStyle(
                                  color: progress.pubgTier.accentColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: progress.pubgTier.primaryColor.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'TIER ${progress.pubgTier.tierRoman}',
                                  style: TextStyle(
                                    color: progress.pubgTier.accentColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            progress.pubgTier.nextTier != null
                                ? 'Tap to view 8 PUBG Tier Badges • Next: ${progress.pubgTier.nextTier!.title}'
                                : 'Apex Rank Achieved! View Trophy Room',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.military_tech_rounded, size: 20, color: Color(0xFFFBBF24)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Stats Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tests Completed',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${progress.testsCompleted}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Average Accuracy',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${progress.averageAccuracy}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Link to Test History & Score Trends
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TestHistoryScreen()),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.insights_rounded, size: 20, color: AppColors.primary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Past Test History & Analytics',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Review previous mock scores, accuracy & SQLite attempts',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4-Tier Level Unlock Ladder Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '4-Tier Level Unlock Ladder',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '500 XP per tier progression rule',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Skill Ladder',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4-Tier Level Unlock Ladder Nodes
            ...ArenaLevel.values.asMap().entries.map((entry) {
              final idx = entry.key;
              final level = entry.value;
              final isUnlocked = level.isUnlocked(progress.xp);
              final isLast = idx == ArenaLevel.values.length - 1;

              return LevelMapNode(
                level: level,
                isUnlocked: isUnlocked,
                currentXp: progress.xp,
                isLast: isLast,
                onTap: () {
                  if (progress.currentHearts <= 0) {
                    HeartsRefillModal.show(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('💔 Out of Lives! You need at least 1 Heart (❤️) to enter the CBT Hall.'),
                        backgroundColor: Color(0xFFE11D48),
                      ),
                    );
                    return;
                  }
                  if (level == ArenaLevel.level4) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AiGauntletScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CbtExamScreen(
                          level: level,
                          examType: progress.selectedExam,
                        ),
                      ),
                    );
                  }
                },
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
