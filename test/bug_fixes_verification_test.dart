import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/core/theme/theme_provider.dart';
import 'package:exam_arena_cbt/features/ai_generator/data/datasources/gemini_ai_service.dart';
import 'package:exam_arena_cbt/features/ai_generator/data/datasources/local_question_datasource.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/exam_result.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/question.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/question_status.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/services/exam_analytics_service.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/providers/exam_session_provider.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/screens/exam_summary_screen.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/widgets/virtual_hall_ticket_sheet.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/arena_level.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/pyq_paper.dart';
import 'package:exam_arena_cbt/features/progression/presentation/providers/progression_provider.dart';
import 'package:exam_arena_cbt/features/progression/presentation/screens/test_history_screen.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/test_attempt_analytics.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() async {
    await AppDatabase.createInMemoryDatabase();
  });

  const qQuant = Question(
    id: 'q_s1',
    subject: 'Quantitative Aptitude',
    category: 'Quantitative Aptitude',
    examType: 'ssc_cgl',
    questionEn: 'What is 10% of 200?',
    questionTa: '200-ல் 10% எவ்வளவு?',
    optionsEn: ['20', '30', '40', '50'],
    optionsTa: ['20', '30', '40', '50'],
    correctIndex: 0,
    explanationEn: '10% of 200 = 20.',
    explanationTa: '200 * 10 / 100 = 20.',
  );

  const qReasoning = Question(
    id: 'q_s2',
    subject: 'Logical Reasoning',
    category: 'Logical Reasoning',
    examType: 'ssc_cgl',
    questionEn: 'Next number: 2, 4, 6, ?',
    questionTa: 'அடுத்த எண்: 2, 4, 6, ?',
    optionsEn: ['8', '10', '12', '14'],
    optionsTa: ['8', '10', '12', '14'],
    correctIndex: 0,
    explanationEn: '+2 pattern gives 8.',
    explanationTa: '+2 கூட்டினால் 8 வரும்.',
  );

  group('Manifest & Offline Fonts Verification', () {
    test('AndroidManifest.xml includes INTERNET permission alongside security flags', () {
      final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
      expect(manifest.contains('android.permission.INTERNET'), isTrue);
      expect(manifest.contains('android:allowBackup="false"'), isTrue);
      expect(manifest.contains('android:usesCleartextTraffic="false"'), isTrue);
    });

    test('Bundled offline Inter and NotoSansTamil fonts exist in assets/google_fonts', () {
      expect(File('assets/google_fonts/Inter-Regular.ttf').existsSync(), isTrue);
      expect(File('assets/google_fonts/Inter-Bold.ttf').existsSync(), isTrue);
      expect(File('assets/google_fonts/NotoSansTamil-Regular.ttf').existsSync(), isTrue);
      expect(File('assets/google_fonts/NotoSansTamil-Bold.ttf').existsSync(), isTrue);
    });
  });

  group('Sectional Auto-Lock & Negative Net Score Enforcement', () {
    test('Locks expired section, advances to next section, blocks cross-section jump, and auto-submits on last section', () {
      final setup = ExamAnalyticsService.buildSectionsForExam(
        questions: [qQuant, qReasoning],
        examType: ExamType.sscCgl,
        level: ArenaLevel.level2,
        hasSectionLock: true,
        totalDurationSeconds: 120,
      );

      expect(setup.sections.length, 2);
      expect(setup.sections[0].isLocked, isFalse);
      expect(setup.sections[1].isLocked, isTrue);

      final container = ProviderContainer();

      final notifier = container.read(examSessionProvider.notifier);
      notifier.startSession(
        ExamSessionState(
          questions: setup.orderedQuestions,
          userSelections: const {},
          statuses: const {
            0: QuestionStatus.notAnswered,
            1: QuestionStatus.notVisited,
          },
          remainingSeconds: 120,
          totalDurationSeconds: 120,
          sectionalRemainingSeconds: 2,
          hasSectionalLock: true,
          sections: [
            setup.sections[0].copyWith(allottedSeconds: 2),
            setup.sections[1].copyWith(allottedSeconds: 2),
          ],
          currentSectionIndex: 0,
          examType: ExamType.sscCgl,
        ),
      );

      // Cross-section jump to Q2 (index 1) must be blocked while in Section 0
      notifier.jumpToQuestion(1);
      expect(container.read(examSessionProvider)!.currentIndex, 0);

      // Tick 1s -> sec 0 has 1s left
      notifier.tickOneSecond();
      expect(container.read(examSessionProvider)!.currentSectionIndex, 0);
      expect(container.read(examSessionProvider)!.sectionalRemainingSeconds, 1);

      // Tick 1s -> sec 0 expires, locks sec 0, advances to sec 1 (index 1)
      notifier.tickOneSecond();
      final afterAdvance = container.read(examSessionProvider)!;
      expect(afterAdvance.currentSectionIndex, 1);
      expect(afterAdvance.currentIndex, 1);
      expect(afterAdvance.sections[0].isLocked, isTrue);
      expect(afterAdvance.sections[1].isLocked, isFalse);
      expect(afterAdvance.sectionalRemainingSeconds, 2);

      // Jumping back into locked Section 0 must be blocked
      notifier.jumpToQuestion(0);
      expect(container.read(examSessionProvider)!.currentIndex, 1);

      // Final section expiry auto-submits exam
      notifier.tickOneSecond();
      notifier.tickOneSecond();
      expect(container.read(examSessionProvider)!.isSubmitted, isTrue);
    });

    test('Preserves genuine negative netScore when wrong answers outweigh correct ones', () {
      final container = ProviderContainer();

      final notifier = container.read(examSessionProvider.notifier);
      notifier.startSession(
        const ExamSessionState(
          questions: [qQuant, qReasoning],
          userSelections: {0: 1, 1: 2}, // both wrong
          statuses: {0: QuestionStatus.answered, 1: QuestionStatus.answered},
          remainingSeconds: 800,
          totalDurationSeconds: 900,
          sections: [],
          examType: ExamType.sscCgl, // -0.50 per wrong
        ),
      );

      notifier.submitExam();
      final result = container.read(examSessionProvider)!.result!;
      expect(result.incorrect, 2);
      expect(result.negativeMarksDeducted, 1.0);
      expect(result.netScore, -1.0);
    });
  });

  group('Question Bounds Safety & Gemini JSON Robustness', () {
    test('Question.fromMap clamps out-of-range correct_index safely', () {
      final q = Question.fromMap({
        'id': 'bad_1',
        'subject': 'Test',
        'exam_type': 'ssc_cgl',
        'question_en': 'Sample?',
        'question_ta': 'மாதிரி?',
        'options_en': ['A', 'B', 'C', 'D'],
        'options_ta': ['அ', 'ஆ', 'இ', 'ஈ'],
        'correct_index': 99,
        'explanation_en': 'Exp',
        'explanation_ta': 'விளக்கம்',
      });

      expect(q.correctIndex, 3);
      expect(q.safeCorrectOptionEn, 'D');
      expect(q.getSafeOption(99, false), '');
    });

    test('GeminiAiService.parseGeneratedQuestionsJson strips markdown fences and validates fields', () {
      const fenced = '''
```json
[
  {
    "subject": "Polity",
    "question_en": "Which Article abolishes untouchability?",
    "question_ta": "தீண்டாமையை ஒழிக்கும் பிரிவு எது?",
    "options_en": ["Article 17", "Article 18", "Article 19", "Article 21"],
    "options_ta": ["பிரிவு 17", "பிரிவு 18", "பிரிவு 19", "பிரிவு 21"],
    "correct_index": 0,
    "explanation_en": "Article 17 abolishes untouchability.",
    "explanation_ta": "பிரிவு 17 தீண்டாமையை ஒழிக்கிறது."
  }
]
```
''';

      final parsed = GeminiAiService.parseGeneratedQuestionsJson(fenced);
      expect(parsed.length, 1);
      expect(parsed.first.id, isNotEmpty);
      expect(parsed.first.safeCorrectOptionEn, 'Article 17');
    });
  });

  group('Hall Ticket, Summary Persistence & Mistake Mastery', () {
    testWidgets('VirtualHallTicketSheet displays accurate Level 2 duration and exact exam negative marks', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualHallTicketSheet(
              level: ArenaLevel.level2,
              examType: ExamType.sscCgl,
              onEnter: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15 Mins'), findsOneWidget);
      expect(find.textContaining('-0.50 Marks per wrong response'), findsOneWidget);
    });

    testWidgets('ExamSummaryScreen automatically persists session & masters solved Mistake Vault items', (tester) async {
      await tester.runAsync(() async {
        await AppDatabase.instance.recordMistake(qQuant);
      });
      final initialMistakes =
          await tester.runAsync(() => AppDatabase.instance.getActiveMistakeCount());
      expect(initialMistakes, 1);

      final container = ProviderContainer();

      // Deduct 1 heart first so we can verify passing mistake drill heals +1 heart
      await tester.runAsync(() async {
        await container.read(progressionProvider.notifier).deductHeart();
      });
      expect(container.read(progressionProvider).currentHearts, 4);

      const result = ExamResult(
        totalQuestions: 1,
        attempted: 1,
        correct: 1,
        incorrect: 0,
        optionESelected: 0,
        unattempted: 0,
        positiveMarksEarned: 2.0,
        negativeMarksDeducted: 0.0,
        netScore: 2.0,
        maximumMarks: 2.0,
        timeSpentSeconds: 30,
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ExamSummaryScreen(
              result: result,
              questions: [qQuant],
              userSelections: {0: 0},
              examType: ExamType.sscCgl,
              isMistakeDrill: true,
              persistOnInit: true,
            ),
          ),
        ),
      );
      await tester.pump(); // Execute post-frame callback
      for (int i = 0; i < 6; i++) {
        await tester.runAsync(() async {
          await Future.delayed(const Duration(milliseconds: 50));
        });
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // Session persisted automatically without clicking bottom button
      expect(container.read(progressionProvider).xp, greaterThan(0));
      expect(container.read(progressionProvider).testsCompleted, 1);
      expect(container.read(progressionProvider).currentHearts, 5);

      // Mistake Vault item was auto-marked mastered
      final remaining = await tester.runAsync(() => AppDatabase.instance.getActiveMistakeCount());
      expect(remaining, 0);

      await tester.pumpWidget(const SizedBox());
      container.dispose();
    });
  });

  group('Persistence of Theme, PYQ Selection, Subject Filters & History Chips', () {
    test('ThemeModeNotifier persists dark theme preference into SQLite', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(themeModeProvider.notifier).setTheme(ThemeMode.dark);
      await Future.delayed(const Duration(milliseconds: 50));

      final stored = await AppDatabase.instance.getSetting('theme_mode');
      expect(stored, 'dark');
    });

    test('ProgressionNotifier tracks selectedPyqId and clears it on blueprint select', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final paper = PyqPaper.standardPapers.first;
      await container.read(progressionProvider.notifier).selectPyqPaper(paper);
      expect(container.read(progressionProvider).selectedPyqId, paper.id);
      expect(container.read(progressionProvider).selectedExam, paper.examType);

      await container.read(progressionProvider.notifier).selectExam(ExamType.tnpscGroup2And4);
      expect(container.read(progressionProvider).selectedPyqId, isNull);
    });

    test('LocalQuestionDatasource prioritizes requested subject and handles Banking/TNPSC families', () async {
      final ds = LocalQuestionDatasource(appDatabase: AppDatabase.instance);
      final quantPriority = await ds.getQuestionsByExamType(
        'rrb_ntpc',
        subject: 'Quantitative Aptitude',
      );
      expect(quantPriority.isNotEmpty, isTrue);
      expect(quantPriority.first.category.toLowerCase(), contains('quant'));

      final bankingPo = await ds.getQuestionsByExamType('ibps_sbi_po');
      expect(bankingPo.isNotEmpty, isTrue);
      expect(bankingPo.every((q) => q.examType.startsWith('ibps')), isTrue);
    });

    testWidgets('TestHistoryScreen renders UPSC and Banking filter chips accurately', (tester) async {
      final attempt = TestAttemptAnalytics(
        id: 'att_upsc_1',
        examType: 'upsc_cse_prelims_gs',
        timestamp: DateTime(2026, 11, 22, 14, 0),
        totalQuestions: 10,
        attempted: 10,
        correct: 6,
        incorrect: 4,
        optionESelected: 0,
        unattempted: 0,
        positiveMarks: 12.0,
        negativeMarks: 2.68,
        netScore: 9.32,
        maxMarks: 20.0,
        timeSpentSeconds: 400,
        accuracy: 60.0,
        earnedXp: 70,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: TestHistoryScreen(initialAttempts: [attempt]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('UPSC'), findsOneWidget);
      expect(find.text('Banking'), findsOneWidget);
      expect(find.text('UPSC CSE Prelims (GS-1)'), findsOneWidget);
    });
  });
}
