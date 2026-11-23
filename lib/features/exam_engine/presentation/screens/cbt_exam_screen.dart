import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';
import '../../../progression/domain/models/arena_level.dart';
import '../../../progression/domain/models/exam_type.dart';
import '../../domain/models/question.dart';
import '../../domain/models/question_status.dart';
import '../../domain/models/section.dart';
import '../providers/exam_session_provider.dart';
import '../widgets/countdown_timer_badge.dart';
import '../widgets/language_toggle_chip.dart';
import '../widgets/tcs_question_palette.dart';
import '../widgets/cbt_option_tile.dart';
import '../widgets/exit_guard_dialog.dart';
import 'exam_summary_screen.dart';
import '../../../ai_generator/presentation/providers/ai_generator_provider.dart';
import '../../../progression/presentation/providers/progression_provider.dart';

class CbtExamScreen extends ConsumerStatefulWidget {
  final ArenaLevel level;
  final ExamType examType;
  final List<Question>? customQuestions;

  const CbtExamScreen({
    super.key,
    required this.level,
    required this.examType,
    this.customQuestions,
  });

  @override
  ConsumerState<CbtExamScreen> createState() => _CbtExamScreenState();
}

class _CbtExamScreenState extends ConsumerState<CbtExamScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInitializing = true;
  bool _hasWarned5Min = false;
  double _fontScale = 1.0;
  final TextEditingController _roughSheetController = TextEditingController();

  @override
  void dispose() {
    _roughSheetController.dispose();
    super.dispose();
  }

  void _showQuestionPaperModal(BuildContext context, ExamSessionState sessionState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.description_outlined, color: Color(0xFF0284C7), size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Official Question Paper: ${widget.examType.title}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                      ),
                      Text(
                        'Full Paper Overview • ${sessionState.questions.length} Total Questions',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: sessionState.questions.length,
                separatorBuilder: (context, index) => const Divider(height: 16),
                itemBuilder: (ctx, idx) {
                  final q = sessionState.questions[idx];
                  final status = sessionState.statuses[idx] ?? QuestionStatus.notVisited;
                  final userSel = sessionState.userSelections[idx];
                  final isAnswered = status == QuestionStatus.answered || status == QuestionStatus.answeredReview;
                  final statusColor = status.backgroundColor == AppColors.tcsNotVisited
                      ? AppColors.textPrimary
                      : status.backgroundColor;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      ref.read(examSessionProvider.notifier).jumpToQuestion(idx);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: status.backgroundColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: status.borderColor.withValues(alpha: 0.4)),
                                ),
                                child: Text(
                                  'Q${idx + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  q.subject,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Text(
                                isAnswered ? 'Marked' : status.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            sessionState.isTamil ? q.questionTa : q.questionEn,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.3),
                          ),
                          const SizedBox(height: 6),
                          ...q.getOptions(sessionState.isTamil).asMap().entries.map((opt) {
                            final isUserChoice = userSel == opt.key;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                '${String.fromCharCode(65 + opt.key)}) ${opt.value}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isUserChoice ? FontWeight.w800 : FontWeight.w400,
                                  color: isUserChoice ? AppColors.primary : AppColors.textPrimary,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoughSheetModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_note_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Virtual Rough Sheet',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _roughSheetController.clear(),
                    icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                    label: const Text('Clear', style: TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Use this scratchpad for math calculations, formulas & rough work. Your notes are kept active during the exam.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: _roughSheetController,
                  maxLines: 8,
                  style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                  decoration: const InputDecoration(
                    hintText: 'e.g. Speed = Dist / Time = 300 / 15 = 20 m/s...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Minimize Scratchpad & Continue Exam', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuestionsAndInit();
    });
  }

  Future<void> _loadQuestionsAndInit() async {
    List<Question> questions = widget.customQuestions ?? [];

    if (questions.isEmpty) {
      final localDs = ref.read(localDatasourceProvider);
      questions = await localDs.getQuestionsByExamType(widget.examType.id);
    }

    if (questions.isEmpty) {
      final localDs = ref.read(localDatasourceProvider);
      await localDs.seedIfEmpty();
      questions = await localDs.getAllQuestions();
    }

    // Level-specific authentic sizing & replay variety:
    // If custom questions are passed (e.g. from tests or AI gauntlet), respect them
    if (widget.customQuestions == null && questions.isNotEmpty) {
      final shuffled = List<Question>.from(questions)..shuffle();
      if (widget.level == ArenaLevel.level1) {
        // Level 1: 15-min Topic Speed Sprint -> 10 Questions
        questions = shuffled.take(10).toList();
      } else if (widget.level == ArenaLevel.level2) {
        // Level 2: Sectional Timed Drill -> 20 Questions
        questions = shuffled.take(20).toList();
      } else if (widget.level == ArenaLevel.level3) {
        // Level 3: Full-Length CBT Mock -> All available authentic questions
        questions = shuffled;
      } else if (widget.level == ArenaLevel.level4) {
        // Level 4: AI Adaptive Boss Gauntlet -> 10 Questions
        questions = shuffled.take(10).toList();
      }
    }

    // Set duration based on level and exam specifications
    int durationSecs = 900; // 15 mins for Level 1 Topic Speed Sprint
    if (widget.level == ArenaLevel.level1) {
      durationSecs = 900; // 15-min Topic Speed Sprint
    } else if (widget.level == ArenaLevel.level2) {
      durationSecs = widget.examType.hasSectionalLock && widget.examType.sectionalLockDurationMinutes > 0
          ? widget.examType.sectionalLockDurationSeconds
          : 900; // 15 mins sectional drill
    } else if (widget.level == ArenaLevel.level3) {
      durationSecs = widget.examType.totalDurationSeconds; // Full CBT Mock
    } else if (widget.level == ArenaLevel.level4) {
      durationSecs = 600; // 10 mins AI gauntlet
    }

    final hasSectionLock = widget.level == ArenaLevel.level2 || widget.examType.hasSectionalLock;
    final sectionLockSecs = widget.examType.sectionalLockDurationMinutes > 0
        ? widget.examType.sectionalLockDurationSeconds
        : 900;

    final initialStatuses = <int, QuestionStatus>{};
    for (int i = 0; i < questions.length; i++) {
      initialStatuses[i] = QuestionStatus.notVisited;
    }
    initialStatuses[0] = QuestionStatus.notAnswered;

    final dummySection = ExamSection(
      id: 'sec_1',
      name: widget.level.title,
      tamilName: widget.level.tamilTitle,
      questionIndices: List.generate(questions.length, (i) => i),
      allottedSeconds: durationSecs,
      isLocked: hasSectionLock,
    );

    final initialState = ExamSessionState(
      questions: questions,
      currentIndex: 0,
      userSelections: {},
      statuses: initialStatuses,
      isTamil: false,
      remainingSeconds: durationSecs,
      totalDurationSeconds: durationSecs,
      sectionalRemainingSeconds: hasSectionLock ? sectionLockSecs : 0,
      hasSectionalLock: hasSectionLock,
      sections: [dummySection],
      examType: widget.examType,
    );

    if (mounted) {
      ref.read(examSessionProvider.notifier).startSession(initialState);
      setState(() {
        _isInitializing = false;
      });
    }
  }

  void _showSubmitConfirmationDialog(BuildContext context, ExamSessionState sessionState) {
    int answeredCount = 0;
    int reviewCount = 0;
    int unattemptedCount = 0;

    for (int i = 0; i < sessionState.questions.length; i++) {
      final status = sessionState.statuses[i] ?? QuestionStatus.notVisited;
      if (status == QuestionStatus.answered || status == QuestionStatus.answeredReview) {
        answeredCount++;
      } else if (status == QuestionStatus.review) {
        reviewCount++;
      } else {
        unattemptedCount++;
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF10B981)),
            SizedBox(width: 8),
            Text('Submit Examination?', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to finalize and submit your CBT session?',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Total Questions:', '${sessionState.questions.length}'),
                  const SizedBox(height: 6),
                  _buildSummaryRow('Answered:', '$answeredCount', color: const Color(0xFF10B981)),
                  const SizedBox(height: 6),
                  _buildSummaryRow('Marked for Review:', '$reviewCount', color: const Color(0xFF7C3AED)),
                  const SizedBox(height: 6),
                  _buildSummaryRow('Unattempted:', '$unattemptedCount', color: const Color(0xFFEF4444)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Return to Exam'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(examSessionProvider.notifier).submitExam();
            },
            child: const Text('Yes, Submit Final Responses'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFontZoomBtn(String label, double scale, String tooltip) {
    final isSelected = (_fontScale - scale).abs() < 0.05;
    return InkWell(
      onTap: () => setState(() => _fontScale = scale),
      child: Tooltip(
        message: tooltip,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.white : const Color(0xFF334155),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(examSessionProvider);
    final notifier = ref.read(examSessionProvider.notifier);

    // Listen for exam submission and 5-minute threshold
    ref.listen<ExamSessionState?>(examSessionProvider, (prev, next) {
      if (next != null) {
        if (next.isSubmitted && next.result != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ExamSummaryScreen(
                result: next.result!,
                questions: next.questions,
                userSelections: next.userSelections,
              ),
            ),
          );
        } else if (next.remainingSeconds <= 300 && next.remainingSeconds > 0 && !_hasWarned5Min) {
          _hasWarned5Min = true;
          HapticFeedbackHelper.heavyImpact();
        }
      }
    });

    if (_isInitializing || sessionState == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Initializing TCS iON CBT Exam Hall Environment...',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    final currentQ = sessionState.currentQuestion;
    final isTamil = sessionState.isTamil;
    final options = currentQ.getOptions(isTamil);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await ExitGuardDialog.show(context);
        if (shouldExit && context.mounted) {
          ref.read(progressionProvider.notifier).deductHeart(reason: 'Exited active CBT session midway');
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        // Authentic TCS iON Question Palette EndDrawer
        endDrawer: TcsQuestionPalette(
          totalQuestions: sessionState.questions.length,
          currentIndex: sessionState.currentIndex,
          statuses: sessionState.statuses,
          isDrawer: true,
          onQuestionSelected: (idx) => notifier.jumpToQuestion(idx),
          onSubmit: () => _showSubmitConfirmationDialog(context, sessionState),
        ),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () async {
              final shouldExit = await ExitGuardDialog.show(context);
              if (shouldExit && context.mounted) {
                ref.read(progressionProvider.notifier).deductHeart(reason: 'Exited active CBT session midway');
                Navigator.of(context).pop();
              }
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.examType.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Terminal C-04 • TCS iON CBT Console',
                style: TextStyle(fontSize: 9.0, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          actions: [
            // Live Countdown Timer Badge
            CountdownTimerBadge(
              remainingSeconds: sessionState.remainingSeconds,
              compact: true,
            ),
            const SizedBox(width: 2),

            // Instant Tamil <-> English Language Switch Chip
            LanguageToggleChip(
              isTamil: isTamil,
              compact: true,
              onToggle: () => notifier.toggleLanguage(),
            ),
            const SizedBox(width: 1),

            // Official Question Paper Full View Button
            IconButton(
              icon: const Icon(Icons.description_outlined, color: Color(0xFF0284C7), size: 18),
              tooltip: 'Question Paper',
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              onPressed: () => _showQuestionPaperModal(context, sessionState),
            ),

            // Open TCS iON Palette Drawer Button
            IconButton(
              icon: const Icon(Icons.apps_rounded, color: AppColors.primary, size: 19),
              tooltip: 'Question Palette',
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            const SizedBox(width: 2),
          ],
        ),
        body: Column(
          children: [
            // 5-Minute Warning Banner (Simulates authentic TCS iON Exam Hall pressure)
            if (sessionState.remainingSeconds <= 300 && sessionState.remainingSeconds > 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  border: Border(bottom: BorderSide(color: Color(0xFFFECDD3))),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFDC2626)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '⚠️ 5-Minute Warning: Exam auto-submits at 00:00! Review flagged and unattempted answers.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Sectional Lock Banner (for SSC CGL & IBPS Clerk)
            if (sessionState.hasSectionalLock)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  border: Border(bottom: BorderSide(color: Color(0xFFFDE68A))),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_clock, size: 16, color: Color(0xFFB45309)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Automatic Sectional Lock Active (${widget.examType.title}) • Switching sections is disabled until timer expires.',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                    if (sessionState.sectionalRemainingSeconds > 0)
                      CountdownTimerBadge(
                        remainingSeconds: sessionState.sectionalRemainingSeconds,
                        isSectionalLock: true,
                        label: 'Section',
                      ),
                  ],
                ),
              ),

            // Top Status Bar: Q Index & Marking Scheme
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Text(
                        'Question ${sessionState.currentIndex + 1} of ${sessionState.questions.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        currentQ.displayCategory,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Marking Scheme Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Text(
                        '+${widget.examType.positiveMark} / -${widget.examType.negativeMark} Marks',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // TCS iON Font Zoom Controls (A- / A / A+)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildFontZoomBtn('A-', 0.9, 'Small Font'),
                          _buildFontZoomBtn('1x', 1.0, 'Default Font'),
                          _buildFontZoomBtn('A+', 1.25, 'Large Font'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Rough Sheet / Scratchpad Button
                    InkWell(
                      onTap: () => _showRoughSheetModal(context),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_note_rounded, size: 14, color: Color(0xFFB45309)),
                            SizedBox(width: 3),
                            Text(
                              'Rough Sheet',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Question and Options Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primary Question Text (in selected language)
                    Text(
                      currentQ.getQuestion(isTamil),
                      style: AppTheme.bilingualTextStyle(
                        isTamil: isTamil,
                        fontSize: 16 * _fontScale,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Parallel Bilingual Preview in alternate language
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.translate, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              currentQ.getQuestion(!isTamil),
                              style: AppTheme.bilingualTextStyle(
                                isTamil: !isTamil,
                                fontSize: 13 * _fontScale,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // OMR Options List (4 options standard, 5 options for TNPSC)
                    ...List.generate(options.length, (optIdx) {
                      final isSelected = sessionState.currentSelection == optIdx;
                      final isOptE = currentQ.hasOptionE && optIdx == 4;

                      return CbtOptionTile(
                        index: optIdx,
                        text: options[optIdx],
                        isSelected: isSelected,
                        isOptionE: isOptE,
                        isTamil: isTamil,
                        fontScale: _fontScale,
                        onTap: () => notifier.selectOption(optIdx),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom Navigation and Action Bar (TCS iON Standard Layout)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        // Previous Question Button (Mobile Optimized)
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF475569),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: sessionState.currentIndex > 0
                              ? () => notifier.jumpToQuestion(sessionState.currentIndex - 1)
                              : null,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back_ios, size: 9),
                              SizedBox(width: 1),
                              Text('Prev', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Mark for Review & Next (Violet)
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.tcsReview,
                              side: const BorderSide(color: AppColors.tcsReview, width: 1.2),
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => notifier.markForReviewAndNext(),
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Mark & Next',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Clear Response
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF64748B),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => notifier.clearResponse(),
                          child: const Text('Clear', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 4),

                        // Save & Next (Primary Blue)
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => notifier.saveAndNext(),
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Save & Next',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Secondary Bar: Submit Test Action
                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.send_rounded, size: 16),
                        label: const Text(
                          'Submit Test',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                        onPressed: () => _showSubmitConfirmationDialog(context, sessionState),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
