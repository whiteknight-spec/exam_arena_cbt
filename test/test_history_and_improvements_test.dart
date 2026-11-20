import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/exam_result.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/question.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/test_attempt_analytics.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/screens/cbt_exam_screen.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/screens/exam_summary_screen.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/arena_level.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';
import 'package:exam_arena_cbt/features/progression/presentation/screens/test_history_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    await AppDatabase.createInMemoryDatabase();
  });

  final testQuestion = Question(
    id: 'test_q_1',
    subject: 'History',
    examType: 'rrb_ntpc',
    category: 'Indus Valley',
    questionEn: 'Which Indus Valley site is famous for water reservoirs?',
    questionTa: 'நீர் தேக்கங்களுக்கு புகழ்பெற்ற சிந்து சமவெளி தளம் எது?',
    optionsEn: ['Dholavira', 'Lothal', 'Kalibangan', 'Harappa'],
    optionsTa: ['தோலவிரா', 'லோத்தல்', 'காலிபங்கன்', 'ஹரப்பா'],
    correctIndex: 0,
    explanationEn: 'Dholavira has sophisticated water conservation systems.',
    explanationTa: 'தோலவிராவில் மேம்பட்ட நீர் மேலாண்மை அமைப்பு காணப்பட்டது.',
  );

  group('TestHistoryScreen & Analytics', () {
    testWidgets('renders empty state when no past attempts exist', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TestHistoryScreen(initialAttempts: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test History & Analytics'), findsOneWidget);
      expect(find.text('No Test Attempts Yet'), findsOneWidget);
      expect(find.text('Start Practicing Now'), findsOneWidget);
    });

    testWidgets('renders aggregated metrics and attempt cards when records exist', (tester) async {
      final attempt = TestAttemptAnalytics(
        id: 'attempt_1',
        examType: 'rrb_ntpc',
        timestamp: DateTime(2026, 11, 20, 10, 30),
        totalQuestions: 10,
        attempted: 9,
        correct: 8,
        incorrect: 1,
        optionESelected: 0,
        unattempted: 1,
        positiveMarks: 8.0,
        negativeMarks: 0.33,
        netScore: 7.67,
        maxMarks: 10.0,
        timeSpentSeconds: 320,
        accuracy: 88.8,
        earnedXp: 115,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: TestHistoryScreen(initialAttempts: [attempt]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cumulative Mock Test Analytics'), findsOneWidget);
      expect(find.text('+7.7 / 10'), findsOneWidget);
      expect(find.text('88.8%'), findsNWidgets(2)); // in summary metric and attempt card
      expect(find.text('+115 XP'), findsOneWidget);
      expect(find.text('RRB NTPC CBT 1'), findsOneWidget);
      expect(find.textContaining('Correct: 8'), findsOneWidget);
      expect(find.textContaining('Wrong: 1'), findsOneWidget);
    });
  });

  group('CBT Exam Hall Updates (Font Zoom & Rough Sheet)', () {
    testWidgets('renders font zoom toolbar and toggles font scaling', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: CbtExamScreen(
              level: ArenaLevel.level1,
              examType: ExamType.rrbNtpc,
              customQuestions: [testQuestion],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Font Zoom buttons
      expect(find.text('A-'), findsOneWidget);
      expect(find.text('1x'), findsOneWidget);
      expect(find.text('A+'), findsOneWidget);

      // Tap A+ to zoom
      await tester.tap(find.text('A+'));
      await tester.pumpAndSettle();

      // Tap A- to zoom out
      await tester.tap(find.text('A-'));
      await tester.pumpAndSettle();
    });

    testWidgets('tapping Rough Sheet opens virtual scratchpad modal', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: CbtExamScreen(
              level: ArenaLevel.level1,
              examType: ExamType.rrbNtpc,
              customQuestions: [testQuestion],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit_note_rounded), findsWidgets);
      await tester.tap(find.byIcon(Icons.edit_note_rounded).first);
      await tester.pumpAndSettle();

      // Scratchpad modal should be visible
      expect(find.text('Virtual Rough Sheet'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Minimize Scratchpad & Continue Exam'), findsOneWidget);

      // Tap to close modal
      await tester.tap(find.text('Minimize Scratchpad & Continue Exam'));
      await tester.pumpAndSettle();
      expect(find.text('Virtual Rough Sheet'), findsNothing);
    });
  });

  group('ExamSummaryScreen AI Mnemonic & Memory Hacks', () {
    testWidgets('renders AI memory shortcut card with bilingual mnemonics', (tester) async {
      const result = ExamResult(
        totalQuestions: 1,
        attempted: 1,
        correct: 1,
        incorrect: 0,
        optionESelected: 0,
        unattempted: 0,
        positiveMarksEarned: 1.0,
        negativeMarksDeducted: 0.0,
        netScore: 1.0,
        maximumMarks: 1.0,
        timeSpentSeconds: 45,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ExamSummaryScreen(
              result: result,
              questions: [testQuestion],
              userSelections: const {0: 0},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('AI Memory Shortcut / Mnemonic'), findsOneWidget);
      expect(find.textContaining('IVC Acronym'), findsOneWidget);
      expect(find.textContaining('தோலவிரா (குஜராத்)'), findsOneWidget);
    });
  });
}
