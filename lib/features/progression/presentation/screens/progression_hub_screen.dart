import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';
import '../providers/progression_provider.dart';
import '../../domain/models/arena_level.dart';
import '../widgets/xp_bar.dart';
import '../widgets/streak_badge.dart';
import '../widgets/accuracy_badge.dart';
import '../widgets/exam_arena_logo.dart';
import '../widgets/exam_selector_sheet.dart';
import '../widgets/level_map_node.dart';
import '../../../exam_engine/presentation/screens/cbt_exam_screen.dart';
import '../../../exam_engine/presentation/widgets/virtual_hall_ticket_sheet.dart';
import '../../../ai_generator/presentation/screens/ai_gauntlet_screen.dart';
import 'test_history_screen.dart';
import 'mistake_vault_screen.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
        titleSpacing: 12,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ExamArenaLogo(size: 28),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                'Exam Arena CBT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          StreakBadge(streakDays: progress.streakDays),
          const SizedBox(width: 4),
          AccuracyBadge(accuracy: progress.averageAccuracy),
          const SizedBox(width: 4),
          const HeartsBadge(compact: true),
          const SizedBox(width: 2),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.amber
                  : const Color(0xFF64748B),
              size: 19,
            ),
            tooltip: 'Toggle Midnight Study Theme',
            onPressed: () {
              HapticFeedbackHelper.selectionClick();
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
          const SizedBox(width: 8),
        ],
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
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131B2E) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? const Color(0xFF1E293B) : AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(progress.selectedExam.badgeColorHex),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TARGET COMPETITIVE EXAM',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            progress.selectedExam.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${progress.selectedExam.totalQuestions} Qs • ${progress.selectedExam.totalDurationMinutes} mins • ${progress.selectedExam.hasOptionE ? "5 Options A–E (TNPSC)" : "4 Options A–D"}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Change',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFF38BDF8) : AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: isDark ? const Color(0xFF38BDF8) : AppColors.primary,
                          ),
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

            // Aspirant Merit Standing Tile
            InkWell(
              onTap: () => PubgTierModal.show(context, progress: progress),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131B2E) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                                  color: isDark ? progress.pubgTier.accentColor : const Color(0xFF0F172A),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? progress.pubgTier.primaryColor.withValues(alpha: 0.3)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isDark
                                        ? progress.pubgTier.accentColor.withValues(alpha: 0.4)
                                        : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Text(
                                  'TIER ${progress.pubgTier.tierRoman}',
                                  style: TextStyle(
                                    color: isDark ? progress.pubgTier.accentColor : const Color(0xFF475569),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Aspirant Merit Standing • Tap to view 8 PUBG Tier Badges',
                            style: TextStyle(
                              color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.military_tech_rounded,
                      size: 20,
                      color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Link to Test History & Score Trends (with smart inline accuracy & tests count, no bulky block)
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
                  color: isDark ? const Color(0xFF131B2E) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? const Color(0xFF1E293B) : AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.insights_rounded, size: 20, color: isDark ? const Color(0xFF38BDF8) : AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Past Test History & Analytics',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                                  ),
                                ),
                                child: Text(
                                  '${progress.testsCompleted} TESTS',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? const Color(0xFF38BDF8) : AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${progress.testsCompleted} mock attempts • ${progress.averageAccuracy}% average accuracy',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF065F46).withValues(alpha: 0.3) : const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.gps_fixed_rounded, size: 11, color: Color(0xFF10B981)),
                          const SizedBox(width: 3),
                          Text(
                            '${progress.averageAccuracy}%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.chevron_right, size: 20, color: isDark ? const Color(0xFF64748B) : AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Modern Upgrade: Mistake Vault (Error Notebook for Targeted Revision)
            InkWell(
              onTap: () {
                HapticFeedbackHelper.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MistakeVaultScreen()),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131B2E) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFFBE123C).withValues(alpha: 0.4) : const Color(0xFFFECDD3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE11D48).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.troubleshoot_rounded, color: Color(0xFFE11D48), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mistake Vault (Error Notebook) 🎯',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Diagnostic Error Ledger • Practice weak questions to restore stamina',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 20, color: Color(0xFFE11D48)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4-Tier Level Unlock Ladder Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '4-Tier Level Unlock Ladder',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '500 XP per tier progression rule',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFFDE68A),
                    ),
                  ),
                  child: Text(
                    'Skill Ladder',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E),
                      letterSpacing: 0.2,
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
                    VirtualHallTicketSheet.show(
                      context,
                      level: level,
                      examType: progress.selectedExam,
                      onEnter: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CbtExamScreen(
                              level: level,
                              examType: progress.selectedExam,
                            ),
                          ),
                        );
                      },
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
