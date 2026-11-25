import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/timer_formatter.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/models/exam_result.dart';
import '../../domain/models/question.dart';
import '../../domain/services/exam_analytics_service.dart';
import '../../../progression/domain/models/exam_type.dart';
import '../../../progression/domain/models/user_progress.dart';
import '../../../progression/domain/models/pubg_tier.dart';
import '../../../progression/presentation/providers/progression_provider.dart';
import '../../../progression/presentation/widgets/pubg_tier_badge.dart';
import '../../../progression/presentation/screens/mistake_vault_screen.dart';

class ExamSummaryScreen extends ConsumerStatefulWidget {
  final ExamResult result;
  final List<Question> questions;
  final Map<int, int?> userSelections;
  final ExamType? examType;
  final bool isMistakeDrill;
  final bool isRecoveryDrill;
  final bool isTamil;
  final int? preSessionXp;
  final bool sessionAlreadyPersisted;
  final bool persistOnInit;

  const ExamSummaryScreen({
    super.key,
    required this.result,
    required this.questions,
    required this.userSelections,
    this.examType,
    this.isMistakeDrill = false,
    this.isRecoveryDrill = false,
    this.isTamil = false,
    this.preSessionXp,
    this.sessionAlreadyPersisted = false,
    this.persistOnInit = false,
  });

  /// Persists completed exam session XP, streak, attempt analytics, stamina hearts, and Mistake Vault state.
  static Future<void> persistSession({
    required WidgetRef ref,
    required ExamResult result,
    required List<Question> questions,
    required Map<int, int?> userSelections,
    ExamType? examType,
    bool isMistakeDrill = false,
    bool isRecoveryDrill = false,
    required int preSessionXp,
  }) async {
    final baseXp = result.correct * 10;
    final accuracyBonus = UserProgress.calculateAccuracyBonus(result.accuracy);
    final totalEarnedXp = baseXp + accuracyBonus;

    final currentLevel = (preSessionXp ~/ UserProgress.xpPerLevel) + 1;
    final projectedXp = preSessionXp + totalEarnedXp;
    final projectedLevel = (projectedXp ~/ UserProgress.xpPerLevel) + 1;

    if (projectedLevel > currentLevel) {
      try {
        HapticFeedback.heavyImpact();
      } catch (_) {}
    }

    final notifier = ref.read(progressionProvider.notifier);

    int heartDelta = 0;
    if (isMistakeDrill || isRecoveryDrill) {
      if (result.accuracy >= 60.0 && result.correct > 0) {
        heartDelta = 1;
      }
    } else {
      if (result.accuracy < 40.0 && result.totalQuestions >= 3) {
        heartDelta = -1;
      } else if (result.accuracy >= 90.0) {
        heartDelta = 1;
      }
    }

    await notifier.recordTestSession(
      earnedXp: totalEarnedXp,
      accuracy: result.accuracy,
      result: result,
      examType: examType?.id ??
          (questions.isNotEmpty ? questions.first.examType : null),
      heartDelta: heartDelta,
    );

    final incorrectQuestions = <Question>[];
    final masteredIds = <String>[];
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final sel = userSelections[i];
      if (sel != null) {
        if (sel == q.correctIndex) {
          if (isMistakeDrill) {
            masteredIds.add(q.id);
          }
        } else if (!(q.hasOptionE && sel == 4)) {
          incorrectQuestions.add(q);
        }
      }
    }

    try {
      if (masteredIds.isNotEmpty) {
        await AppDatabase.instance.markMistakesMastered(masteredIds);
        ref.invalidate(mistakeVaultProvider);
      }
      if (incorrectQuestions.isNotEmpty) {
        await AppDatabase.instance.recordMistakes(incorrectQuestions);
        ref.invalidate(mistakeVaultProvider);
      }
    } catch (_) {
      // Safe fallback if test didn't mount SQLite tables
    }
  }

  @override
  ConsumerState<ExamSummaryScreen> createState() => _ExamSummaryScreenState();
}

class _ExamSummaryScreenState extends ConsumerState<ExamSummaryScreen> {
  String _activeFilter = 'All'; // 'All', 'Correct', 'Incorrect', 'Skipped'
  bool _hasTriggeredHaptic = false;
  late bool _hasPersistedSession;
  late int _preSessionXp;

  @override
  void initState() {
    super.initState();
    _hasPersistedSession = widget.sessionAlreadyPersisted;
    _preSessionXp = widget.preSessionXp ?? ref.read(progressionProvider).xp;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePostFrameInit();
    });
  }

  Future<void> _handlePostFrameInit() async {
    final baseXp = widget.result.correct * 10;
    final accuracyBonus = UserProgress.calculateAccuracyBonus(widget.result.accuracy);
    final totalEarnedXp = baseXp + accuracyBonus;
    final currentLevel = (_preSessionXp ~/ UserProgress.xpPerLevel) + 1;
    final projectedXp = _preSessionXp + totalEarnedXp;
    final projectedLevel = (projectedXp ~/ UserProgress.xpPerLevel) + 1;

    if (projectedLevel > currentLevel && !_hasTriggeredHaptic) {
      try {
        HapticFeedback.heavyImpact();
      } catch (_) {}
      _hasTriggeredHaptic = true;
    }

    if (!_hasPersistedSession && widget.persistOnInit) {
      await _ensurePersisted();
    }
  }

  Future<void> _ensurePersisted() async {
    if (_hasPersistedSession) return;
    _hasPersistedSession = true;
    await ExamSummaryScreen.persistSession(
      ref: ref,
      result: widget.result,
      questions: widget.questions,
      userSelections: widget.userSelections,
      examType: widget.examType,
      isMistakeDrill: widget.isMistakeDrill,
      isRecoveryDrill: widget.isRecoveryDrill,
      preSessionXp: _preSessionXp,
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF131B2E) : Colors.white;
    final primaryText = isDark ? Colors.white : AppColors.textPrimary;
    final secondaryText = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
    final borderClr = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    final result = widget.result;
    final questions = widget.questions;
    final userSelections = widget.userSelections;

    final baseXp = result.correct * 10;
    final accuracyBonus = UserProgress.calculateAccuracyBonus(result.accuracy);
    final totalEarnedXp = baseXp + accuracyBonus;

    final currentLevel = (_preSessionXp ~/ UserProgress.xpPerLevel) + 1;
    final projectedXp = _preSessionXp + totalEarnedXp;
    final projectedLevel = (projectedXp ~/ UserProgress.xpPerLevel) + 1;
    final hasLeveledUp = projectedLevel > currentLevel;
    final projectedTier = PubgTier.fromXp(projectedXp);

    final avgSecondsPerQ =
        questions.isNotEmpty ? result.timeSpentSeconds / questions.length : 0.0;

    final effectiveExam = widget.examType ?? progress.selectedExam;
    final cutoff = ExamAnalyticsService.calculateCutoffAndPercentile(effectiveExam, result);
    final topicBreakdowns = ExamAnalyticsService.computeTopicBreakdown(questions, userSelections);

    final filteredIndices = <int>[];
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final sel = userSelections[i];
      final isCorrect = sel == q.correctIndex;
      final isSkipped = sel == null || (q.hasOptionE && sel == 4);

      if (_activeFilter == 'All') {
        filteredIndices.add(i);
      } else if (_activeFilter == 'Correct' && isCorrect) {
        filteredIndices.add(i);
      } else if (_activeFilter == 'Incorrect' &&
          sel != null &&
          !isCorrect &&
          !(q.hasOptionE && sel == 4)) {
        filteredIndices.add(i);
      } else if (_activeFilter == 'Skipped' && isSkipped) {
        filteredIndices.add(i);
      }
    }

    final isDrill = widget.isMistakeDrill || widget.isRecoveryDrill;
    final drillHealed = isDrill && result.accuracy >= 60.0 && result.correct > 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _ensurePersisted();
        if (context.mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          title: const Text(
            'CBT Exam Result & Analysis',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEVEL-UP CELEBRATION CARD
              if (hasLeveledUp) ...[
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF581C87), Color(0xFF7E22CE), Color(0xFF9333EA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFFBBF24), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7E22CE).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      PubgTierBadge(
                        tier: projectedTier,
                        size: PubgBadgeSize.medium,
                        showGlow: true,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  '🎉 LEVEL UP CELEBRATION!',
                                  style: TextStyle(
                                    color: Color(0xFFFDE68A),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Promoted from Level $currentLevel → Level $projectedLevel!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'You crossed the ${currentLevel * UserProgress.xpPerLevel} XP milestone! Next level unlocked on Arena Ladder.',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: projectedTier.primaryColor.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: projectedTier.accentColor.withValues(alpha: 0.6),
                                ),
                              ),
                              child: Text(
                                'Aspirant Merit Rank: ${projectedTier.title.toUpperCase()} ${projectedTier.tierRoman} (${projectedTier.tamilTitle})',
                                style: TextStyle(
                                  color: projectedTier.accentColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // NET SCORE HEADER CARD (With Exact Negative Marking)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'NET CBT SCORE (AFTER NEGATIVE MARKING)',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${result.netScore.toStringAsFixed(2)} / ${result.maximumMarks.toStringAsFixed(1)}',
                      style: const TextStyle(
                        color: Color(0xFFFBBF24),
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Accuracy: ${result.accuracy.toStringAsFixed(1)}% • Time: ${TimerFormatter.formatSeconds(result.timeSpentSeconds)} • ${result.attempted}/${result.totalQuestions} Attempted',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreDetail(
                          label: 'Gross Earned',
                          value: '+${result.positiveMarksEarned.toStringAsFixed(2)}',
                          color: const Color(0xFF4ADE80),
                        ),
                        Container(width: 1, height: 24, color: Colors.white24),
                        _buildScoreDetail(
                          label: 'Neg. Deducted',
                          value: '-${result.negativeMarksDeducted.toStringAsFixed(2)}',
                          color: const Color(0xFFF87171),
                        ),
                        Container(width: 1, height: 24, color: Colors.white24),
                        _buildScoreDetail(
                          label: 'Avg Time/Q',
                          value: '${avgSecondsPerQ.toStringAsFixed(1)}s',
                          color: const Color(0xFF38BDF8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CUT-OFF BENCHMARK & ESTIMATED PERCENTILE PREDICTOR CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? (cutoff.isCutoffCleared ? const Color(0xFF064E3B).withValues(alpha: 0.3) : const Color(0xFF451A03).withValues(alpha: 0.4))
                      : (cutoff.isCutoffCleared ? const Color(0xFFECFDF5) : const Color(0xFFFFF7ED)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? (cutoff.isCutoffCleared ? const Color(0xFF059669) : const Color(0xFFD97706))
                        : (cutoff.isCutoffCleared ? const Color(0xFFA7F3D0) : const Color(0xFFFED7AA)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                cutoff.isCutoffCleared
                                    ? Icons.verified_rounded
                                    : Icons.trending_up_rounded,
                                color: cutoff.isCutoffCleared
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF59E0B),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'OFFICIAL CUT-OFF & PERCENTILE PREDICTOR',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: primaryText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: cutoff.isCutoffCleared
                                ? const Color(0xFF059669)
                                : const Color(0xFFD97706),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cutoff.isCutoffCleared ? 'CUT-OFF CLEARED' : 'BORDERLINE GAP',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimated All-India Percentile',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: secondaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${cutoff.estimatedPercentile.toStringAsFixed(1)}%ile',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: cutoff.isCutoffCleared
                                      ? (isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46))
                                      : (isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E)),
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Target Benchmark Cut-Off',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: secondaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${cutoff.benchmarkCutoffMarks.toStringAsFixed(1)} M (${cutoff.benchmarkCutoffPercent.toStringAsFixed(0)}%)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: primaryText,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                cutoff.isCutoffCleared
                                    ? '+${cutoff.cutoffGap.toStringAsFixed(1)} Surplus'
                                    : '${cutoff.cutoffGap.toStringAsFixed(1)} Gap',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: cutoff.isCutoffCleared
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // PERFORMANCE METRICS GRID
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      'Correct Answers',
                      '${result.correct}',
                      '+${result.positiveMarksEarned.toStringAsFixed(1)} Marks',
                      AppColors.tcsAnswered,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      'Incorrect Answers',
                      '${result.incorrect}',
                      '-${result.negativeMarksDeducted.toStringAsFixed(2)} Penalty',
                      AppColors.tcsNotAnswered,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      'Unattempted Questions',
                      '${result.unattempted}',
                      '0 Marks Penalty',
                      const Color(0xFF64748B),
                      isDark: isDark,
                    ),
                  ),
                  if (result.optionESelected > 0) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricTile(
                        'Option E (TNPSC)',
                        '${result.optionESelected}',
                        'விடை தெரியவில்லை',
                        const Color(0xFFD97706),
                        isDark: isDark,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // XP REWARD CALCULATION CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF451A03).withValues(alpha: 0.4)
                      : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFFD97706) : const Color(0xFFFDE68A),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('⚡', style: TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'XP REWARD BREAKDOWN',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                              letterSpacing: 0.6,
                            ),
                          ),
                          Text(
                            '+$totalEarnedXp XP Earned',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
                            ),
                          ),
                          Text(
                            'Formula: (${result.correct} correct × 10) + $accuracyBonus Accuracy Bonus (${result.accuracy.toStringAsFixed(0)}% accuracy)',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF78350F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Exam Stamina & Lives Impact Card
              () {
                final bool isPositive =
                    drillHealed || (!isDrill && result.accuracy >= 90.0);
                final bool isNeutral =
                    isDrill ? !drillHealed : (result.accuracy >= 40.0 && result.accuracy < 90.0);

                final cardColor = isDark
                    ? (isPositive
                        ? const Color(0xFF831843).withValues(alpha: 0.3)
                        : (isNeutral
                            ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                            : const Color(0xFF7F1D1D).withValues(alpha: 0.3)))
                    : (isPositive
                        ? const Color(0xFFFDF2F8)
                        : (isNeutral ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2)));

                final borderColor = isPositive
                    ? const Color(0xFFFBCFE8)
                    : (isNeutral ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA));

                final titleText = isDrill
                    ? (drillHealed
                        ? 'Revision Mastery Reward (+1 ❤️ Healed)'
                        : 'Revision Drill Logged (Score ≥60% to Heal +1 ❤️)')
                    : (result.accuracy >= 90.0
                        ? 'Sharpshooter Stamina Reward (+1 ❤️ Healed)'
                        : result.accuracy >= 40.0
                            ? 'Discipline Shield Active (0 Lives Lost)'
                            : 'Stamina Penalty (-1 ❤️ Life Lost)');

                final subText = isDrill
                    ? (drillHealed
                        ? 'Great work! Passing the revision drill restored +1 Heart stamina.'
                        : 'Keep practicing! Score ≥60% in a revision drill to heal a Heart.')
                    : (result.accuracy >= 90.0
                        ? 'Outstanding ≥90% accuracy! +1 Heart bonus stamina awarded.'
                        : result.accuracy >= 40.0
                            ? 'Good test discipline maintained. All your Lives remain protected.'
                            : 'Negative marking penalty (<40% accuracy). Review solutions to heal your Hearts!');

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? borderColor.withValues(alpha: 0.4) : borderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive
                            ? Icons.favorite_rounded
                            : (isNeutral ? Icons.shield_rounded : Icons.heart_broken_rounded),
                        color: isPositive
                            ? const Color(0xFFDB2777)
                            : (isNeutral ? const Color(0xFF059669) : const Color(0xFFDC2626)),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titleText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              subText,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? const Color(0xFFCBD5E1) : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }(),
              const SizedBox(height: 24),

              // WEAK-TOPIC BREAKDOWN
              Text(
                'Topic & Sectional Analytics',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Diagnostic accuracy across test domains to target revision areas.',
                style: TextStyle(fontSize: 12, color: secondaryText),
              ),
              const SizedBox(height: 12),

              ...topicBreakdowns.map((tb) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: tb.isWeak
                          ? const Color(0xFFFCA5A5)
                          : (tb.isStrong ? const Color(0xFFA7F3D0) : borderClr),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              tb.topic,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: primaryText,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: tb.isWeak
                                  ? const Color(0xFFFEE2E2)
                                  : (tb.isStrong ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tb.isWeak
                                  ? '⚠️ Needs Revision'
                                  : (tb.isStrong ? '🎯 Strong Area' : '✓ Proficient'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: tb.isWeak
                                    ? const Color(0xFF991B1B)
                                    : (tb.isStrong ? const Color(0xFF065F46) : AppColors.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (tb.accuracy / 100).clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            tb.isWeak
                                ? const Color(0xFFEF4444)
                                : (tb.isStrong ? const Color(0xFF10B981) : AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${tb.correctCount} of ${tb.totalCount} Correct',
                              style: TextStyle(fontSize: 12, color: secondaryText),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${tb.accuracy.toStringAsFixed(1)}% Accuracy',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: tb.isWeak
                                  ? const Color(0xFFEF4444)
                                  : (tb.isStrong ? const Color(0xFF10B981) : AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      if (tb.isWeak) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFEF4444)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            icon: const Icon(Icons.troubleshoot_rounded, size: 14, color: Color(0xFFDC2626)),
                            label: const Text(
                              'Drill Weak Topic in Mistake Vault 🎯',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const MistakeVaultScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              // FULL SOLUTION REVIEW SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Full Solutions & Review',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: primaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${questions.length} Total Qs',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: secondaryText),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Solution Review Filter Chips
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: ['All', 'Correct', 'Incorrect', 'Skipped'].map((filter) {
                  final isSelected = _activeFilter == filter;
                  return ChoiceChip(
                    label: Text(filter, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _activeFilter = filter);
                    },
                    selectedColor: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                    backgroundColor: cardBg,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? (isDark ? const Color(0xFF38BDF8) : AppColors.primary)
                          : secondaryText,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Filtered Questions List
              ...filteredIndices.map((index) {
                final q = questions[index];
                final userSel = userSelections[index];
                final isCorrect = userSel == q.correctIndex;
                final isOptionE = q.hasOptionE && userSel == 4;

                Color statusColor;
                String statusLabel;
                if (userSel == null) {
                  statusColor = const Color(0xFF64748B);
                  statusLabel = 'Unattempted';
                } else if (isOptionE) {
                  statusColor = const Color(0xFFD97706);
                  statusLabel = 'Option E (விடை தெரியவில்லை)';
                } else if (isCorrect) {
                  statusColor = const Color(0xFF10B981);
                  statusLabel = 'Correct ✓';
                } else {
                  statusColor = const Color(0xFFEF4444);
                  statusLabel = 'Incorrect ✗';
                }

                return Card(
                  color: cardBg,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: borderClr),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Q${index + 1} • ${q.displayCategory}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: primaryText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Text(
                          q.questionEn,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),

                        Text(
                          q.questionTa,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                          ),
                        ),
                        const Divider(height: 20),

                        if (userSel != null) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Answer: ',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primaryText),
                              ),
                              Expanded(
                                child: Text(
                                  'Option ${String.fromCharCode(65 + userSel)} (${q.getSafeOption(userSel, widget.isTamil)})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Correct Answer: ',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primaryText),
                            ),
                            Expanded(
                              child: Text(
                                'Option ${String.fromCharCode(65 + q.correctIndex)} (${q.getSafeCorrectOption(widget.isTamil)})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderClr),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.lightbulb_outline, size: 15, color: Color(0xFFD97706)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Detailed Explanation:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                q.explanationEn,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                q.explanationTa,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryText,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),

                        _buildMnemonicCard(q, isDark: isDark),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Bottom Return to Arena Hub Button (Progress already persisted safely!)
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(
                    'Saved +$totalEarnedXp XP • Return to Arena Hub',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  onPressed: () async {
                    await _ensurePersisted();
                    if (context.mounted) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreDetail({required String label, required String value, required Color color}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    String label,
    String value,
    String subtext,
    Color color, {
    bool isDark = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMnemonicCard(Question q, {bool isDark = false}) {
    final (trickEn, trickTa) = ExamAnalyticsService.getMnemonicForQuestion(q);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF4C1D95).withValues(alpha: 0.25)
            : const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF7C3AED) : const Color(0xFFDDD6FE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 15, color: Color(0xFF8B5CF6)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'AI Memory Shortcut / Mnemonic:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFFDDD6FE) : const Color(0xFF6D28D9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            trickEn,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFEDE9FE) : const Color(0xFF4C1D95),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trickTa,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFFC4B5FD) : const Color(0xFF5B21B6),
            ),
          ),
        ],
      ),
    );
  }
}
