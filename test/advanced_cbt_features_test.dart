import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/theme/app_theme.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/arena_level.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/pyq_paper.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/exam_selector_sheet.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/accuracy_badge.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/exam_arena_logo.dart';
import 'package:exam_arena_cbt/features/progression/presentation/screens/progression_hub_screen.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/exam_result.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/question.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/screens/cbt_exam_screen.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/screens/exam_summary_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  const testQuestion1 = Question(
    id: 'q_adv_1',
    subject: 'Quantitative Aptitude',
    category: 'Quantitative Aptitude',
    examType: 'rrb_ntpc',
    questionEn: 'If price rises by 20%, reduction needed to keep budget constant?',
    questionTa: 'விலை 20% உயர்ந்தால் செலவு மாறாமல் இருக்க குறைக்க வேண்டிய சதவீதம்?',
    optionsEn: ['16.67%', '20%', '25%', '15%'],
    optionsTa: ['16.67%', '20%', '25%', '15%'],
    correctIndex: 0,
    explanationEn: 'R / (100 + R) * 100 = 20 / 120 * 100 = 16.67%',
    explanationTa: '20 / 120 * 100 = 16.67%',
  );

  const testQuestion2 = Question(
    id: 'q_adv_2',
    subject: 'General Awareness',
    category: 'General Awareness',
    examType: 'upsc_cse_prelims_gs',
    questionEn: 'Dholavira, an Indus Valley Civilization city, is in which state?',
    questionTa: 'சிந்து சமவெளி நகரமான தோலவிரா எந்த மாநிலத்தில் அமைந்துள்ளது?',
    optionsEn: ['Gujarat', 'Rajasthan', 'Haryana', 'Punjab'],
    optionsTa: ['குஜராத்', 'ராஜஸ்தான்', 'ஹரியானா', 'பஞ்சாப்'],
    correctIndex: 0,
    explanationEn: 'Dholavira is located in Khadir bet, Kutch, Gujarat (UNESCO Site).',
    explanationTa: 'தோலவிரா குஜராத்தின் கட்ச் பகுதியில் அமைந்துள்ளது.',
  );

  group('Feature 1: Official Previous Year Question (PYQ) Papers Domain Model', () {
    test('PyqPaper.standardPapers contains at least 6 authentic government exam papers', () {
      expect(PyqPaper.standardPapers.length, greaterThanOrEqualTo(6));
    });

    test('Validates UPSC CSE 2024 Prelims GS-1 & CSAT PYQ papers', () {
      final gs2024 = PyqPaper.standardPapers.firstWhere((p) => p.id == 'pyq_upsc_2024_gs1');
      expect(gs2024.title, 'UPSC CSE 2024 Prelims GS Paper 1');
      expect(gs2024.year, 2024);
      expect(gs2024.examType, ExamType.upscCsePrelimsGs);
      expect(gs2024.totalQuestions, 100);
      expect(gs2024.durationMinutes, 120);

      final csat2024 = PyqPaper.standardPapers.firstWhere((p) => p.id == 'pyq_upsc_2024_csat');
      expect(csat2024.title, 'UPSC CSE 2024 Prelims CSAT Paper 2');
      expect(csat2024.year, 2024);
      expect(csat2024.examType, ExamType.upscCseCsat);
      expect(csat2024.totalQuestions, 80);
      expect(csat2024.durationMinutes, 120);
    });

    test('Validates TNPSC Group 4, RRB NTPC, and SSC CGL PYQ papers', () {
      final tnpsc = PyqPaper.standardPapers.firstWhere((p) => p.id == 'pyq_tnpsc_2024_grp4');
      expect(tnpsc.title, 'TNPSC Group 4 2024 Official Paper');
      expect(tnpsc.year, 2024);
      expect(tnpsc.examType, ExamType.tnpscGroup2And4);
      expect(tnpsc.totalQuestions, 200);

      final rrb = PyqPaper.standardPapers.firstWhere((p) => p.id == 'pyq_rrb_ntpc_cbt1');
      expect(rrb.title, 'RRB NTPC Previous Year CBT-1 Shift 1');
      expect(rrb.examType, ExamType.rrbNtpc);

      final ssc = PyqPaper.standardPapers.firstWhere((p) => p.id == 'pyq_ssc_cgl_2024_tier1');
      expect(ssc.title, 'SSC CGL 2024 Tier 1 Official Shift');
      expect(ssc.examType, ExamType.sscCgl);
      expect(ssc.durationMinutes, 60);
    });
  });

  group('Feature 2: ExamSelectorSheet Dual Mode (Exam Blueprints vs Previous Year Papers)', () {
    testWidgets('Toggles between Exam Blueprints and PYQ papers', (tester) async {
      ExamType? selectedExam;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => ExamSelectorSheet(
                        currentExam: ExamType.rrbNtpc,
                        onSelect: (exam) => selectedExam = exam,
                      ),
                    );
                  },
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open sheet
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Verify Header & Mode toggle
      expect(find.text('Target Competitive Exam'), findsOneWidget);
      expect(find.text('Exam Blueprints'), findsOneWidget);
      expect(find.textContaining('Previous Year Papers (PYQ)'), findsOneWidget);

      // Verify Blueprint view defaults: RRB visible
      expect(find.text('RRB NTPC'), findsWidgets);

      // Filter by UPSC Civil Services category
      await tester.tap(find.textContaining('UPSC Civil Services').first);
      await tester.pumpAndSettle();

      // Verify UPSC CSE Prelims GS-1 is now visible at top
      expect(find.text('UPSC CSE Prelims (GS-1)'), findsOneWidget);

      // Switch to PYQ Mode
      await tester.tap(find.textContaining('Previous Year Papers (PYQ)'));
      await tester.pumpAndSettle();

      // Verify PYQ mode shows official past papers
      expect(find.text('UPSC CSE 2024 Prelims GS Paper 1'), findsOneWidget);
      expect(find.text('UPSC CSE 2024 Prelims CSAT Paper 2'), findsOneWidget);

      // Tap on UPSC 2024 GS-1 paper to select
      await tester.tap(find.text('UPSC CSE 2024 Prelims GS Paper 1'));
      await tester.pumpAndSettle();

      expect(selectedExam, ExamType.upscCsePrelimsGs);
    });
  });

  group('Feature 3: Authentic TCS iON Exam Hall - Question Paper Modal & Overview', () {
    testWidgets('Renders Question Paper button and opens full paper overview modal', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const CbtExamScreen(
              level: ArenaLevel.level1,
              examType: ExamType.rrbNtpc,
              customQuestions: [testQuestion1, testQuestion2],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check Question Paper overview button exists
      final qpButton = find.byTooltip('Question Paper');
      expect(qpButton, findsOneWidget);

      // Tap Question Paper button to open full paper inspection modal
      await tester.tap(qpButton);
      await tester.pumpAndSettle();

      // Check modal content
      expect(find.textContaining('Official Question Paper: RRB NTPC'), findsOneWidget);
      expect(find.textContaining('Full Paper Overview • 2 Total Questions'), findsOneWidget);
      expect(find.text('Q1'), findsOneWidget);
      expect(find.text('Q2'), findsOneWidget);

      // Tap close button on modal
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      // Modal closed, back to CBT screen
      expect(find.textContaining('Full Paper Overview'), findsNothing);
      expect(find.byType(CbtExamScreen), findsOneWidget);
    });
  });

  group('Feature 4: Cut-Off Benchmark & All-India Percentile Predictor & Heatmap Drill', () {
    testWidgets('Renders Cut-Off Benchmark, percentile predictor card, and mistake vault drill', (tester) async {
      const result = ExamResult(
        totalQuestions: 2,
        attempted: 2,
        correct: 1,
        incorrect: 1,
        optionESelected: 0,
        unattempted: 0,
        positiveMarksEarned: 1.0,
        negativeMarksDeducted: 0.33,
        netScore: 0.67,
        maximumMarks: 2.0,
        timeSpentSeconds: 90,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ExamSummaryScreen(
              result: result,
              questions: [testQuestion1, testQuestion2],
              userSelections: {0: 0, 1: 1}, // Q2 user chose incorrect option 1 (Rajasthan instead of Gujarat)
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Cut-Off Benchmark & Percentile Predictor card
      expect(find.text('OFFICIAL CUT-OFF & PERCENTILE PREDICTOR'), findsOneWidget);
      expect(find.text('Estimated All-India Percentile'), findsOneWidget);
      expect(find.text('Target Benchmark Cut-Off'), findsOneWidget);
      expect(find.textContaining('%ile'), findsOneWidget);

      // Scroll down to view Topic Analytics and Mistake Vault drill
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -600));
      await tester.pumpAndSettle();

      // Verify Topic Analytics with "Drill Weak Topic in Mistake Vault" button for General Awareness topic (0% accuracy)
      expect(find.text('Topic & Sectional Analytics'), findsOneWidget);
      expect(find.text('⚠️ Needs Revision'), findsOneWidget);
      expect(find.text('Drill Weak Topic in Mistake Vault 🎯'), findsOneWidget);
    });
  });

  group('Feature 5: Smart Accuracy Placement (No standalone bulky block)', () {
    testWidgets('AccuracyBadge renders accuracy and shows SnackBar on tap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: AccuracyBadge(accuracy: 82.5),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('83%'), findsOneWidget);
      expect(find.text('🎯'), findsOneWidget);

      await tester.tap(find.byType(AccuracyBadge));
      await tester.pumpAndSettle();

      expect(find.textContaining('Accuracy: 82.5%!'), findsOneWidget);
    });

    testWidgets('ProgressionHubScreen integrates accuracy seamlessly without bulky stats block', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProgressionHubScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // AccuracyBadge present in the top AppBar
      expect(find.byType(AccuracyBadge), findsOneWidget);

      // Verify no standalone "Average Accuracy" box block exists
      expect(find.text('Average Accuracy'), findsNothing);

      // Verify accuracy is integrated into the History & Analytics tile
      expect(find.textContaining('average accuracy'), findsOneWidget);
    });
  });

  group('Feature 6: Official Prismatic Target Brand Logo (Concept 2)', () {
    testWidgets('ExamArenaLogo renders custom prismatic painter with squircle base', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ExamArenaLogo(size: 32),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExamArenaLogo), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('ExamArenaLogo with showText displays brand title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ExamArenaLogo(size: 40, showText: true, subtitle: 'Official Brand'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Exam Arena'), findsOneWidget);
      expect(find.text('Official Brand'), findsOneWidget);
    });

    testWidgets('ProgressionHubScreen AppBar displays the official ExamArenaLogo', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProgressionHubScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExamArenaLogo), findsOneWidget);
      expect(find.text('Exam Arena CBT'), findsOneWidget);
    });
  });
}
