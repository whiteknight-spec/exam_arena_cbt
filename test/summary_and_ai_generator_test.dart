import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/theme/app_theme.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/exam_result.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/question.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/screens/exam_summary_screen.dart';
import 'package:exam_arena_cbt/features/ai_generator/data/datasources/local_question_datasource.dart';
import 'package:exam_arena_cbt/features/ai_generator/data/datasources/gemini_ai_service.dart';
import 'package:exam_arena_cbt/features/ai_generator/presentation/screens/ai_gauntlet_screen.dart';
import 'package:exam_arena_cbt/features/ai_generator/presentation/providers/ai_generator_provider.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/user_progress.dart';
import 'package:exam_arena_cbt/features/progression/presentation/providers/progression_provider.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await AppDatabase.createInMemoryDatabase();
  });

  final sampleQuestions = [
    const Question(
      id: 'q_quant_1',
      subject: 'Quantitative Aptitude',
      category: 'Quantitative Aptitude',
      examType: 'ssc_cgl',
      questionEn: 'What is 15% of 300?',
      questionTa: '300-ல் 15% எவ்வளவு?',
      optionsEn: ['45', '40', '50', '35'],
      optionsTa: ['45', '40', '50', '35'],
      correctIndex: 0,
      explanationEn: '15% of 300 = (15/100) * 300 = 45.',
      explanationTa: '300 * 15 / 100 = 45.',
      hasOptionE: false,
    ),
    const Question(
      id: 'q_reason_1',
      subject: 'Logical Reasoning',
      category: 'Logical Reasoning',
      examType: 'ssc_cgl',
      questionEn: 'Complete the series: 2, 4, 8, 16, ?',
      questionTa: 'எண் தொடரை நிறைவு செய்க: 2, 4, 8, 16, ?',
      optionsEn: ['32', '24', '30', '36'],
      optionsTa: ['32', '24', '30', '36'],
      correctIndex: 0,
      explanationEn: 'Numbers double at each step: 16 * 2 = 32.',
      explanationTa: 'ஒவ்வொரு எண்ணும் இரட்டிப்பாகிறது: 16 * 2 = 32.',
      hasOptionE: false,
    ),
    const Question(
      id: 'q_ga_1',
      subject: 'General Awareness',
      category: 'General Awareness',
      examType: 'ssc_cgl',
      questionEn: 'Who wrote the Indian National Anthem?',
      questionTa: 'இந்திய தேசிய கீதத்தை எழுதியவர் யார்?',
      optionsEn: ['Rabindranath Tagore', 'Bankim Chandra', 'Sarojini Naidu', 'Subhas Bose'],
      optionsTa: ['ரவீந்திரநாத் தாகூர்', 'பங்கிம் சந்திரர்', 'சரோஜினி நாயுடு', 'சுபாஷ் போஸ்'],
      correctIndex: 0,
      explanationEn: 'Rabindranath Tagore composed Jana Gana Mana in 1911.',
      explanationTa: 'ஜன கண மன பாடலை ரவீந்திரநாத் தாகூர் 1911-ல் இயற்றினார்.',
      hasOptionE: false,
    ),
  ];

  group('ExamSummaryScreen Detailed Analytics & Level-Up UI', () {
    testWidgets('displays net score with exact negative marking, accuracy %, and time spent', (tester) async {
      // 3 questions: 2 correct (+4.0), 1 incorrect (-0.50), Net = 3.50
      const examResult = ExamResult(
        totalQuestions: 3,
        attempted: 3,
        correct: 2,
        incorrect: 1,
        optionESelected: 0,
        unattempted: 0,
        positiveMarksEarned: 4.0,
        negativeMarksDeducted: 0.50,
        netScore: 3.50,
        maximumMarks: 6.0,
        timeSpentSeconds: 150, // 50s per question
      );

      final userSelections = {0: 0, 1: 0, 2: 1}; // Q1 correct, Q2 correct, Q3 incorrect

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ExamSummaryScreen(
              result: examResult,
              questions: sampleQuestions,
              userSelections: userSelections,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Net score display
      expect(find.textContaining('NET CBT SCORE'), findsOneWidget);
      expect(find.text('3.50 / 6.0'), findsOneWidget);

      // Exact Gross Positive and Negative Deducted
      expect(find.text('+4.00'), findsOneWidget);
      expect(find.text('-0.50'), findsOneWidget);

      // Average Time per Question (150s / 3 Qs = 50.0s)
      expect(find.text('50.0s'), findsOneWidget);
      expect(find.textContaining('Accuracy: 66.7%'), findsOneWidget);

      // XP Reward Breakdown
      expect(find.textContaining('XP REWARD BREAKDOWN'), findsOneWidget);
      expect(find.textContaining('+30 XP Earned'), findsOneWidget); // 2 * 10 = 20 + 10 accuracy bonus = 30
    });

    testWidgets('displays weak-topic breakdown diagnostics with revision badges', (tester) async {
      const examResult = ExamResult(
        totalQuestions: 3,
        attempted: 3,
        correct: 2,
        incorrect: 1,
        optionESelected: 0,
        unattempted: 0,
        positiveMarksEarned: 4.0,
        negativeMarksDeducted: 0.50,
        netScore: 3.50,
        maximumMarks: 6.0,
        timeSpentSeconds: 150,
      );

      // Q1 (Quant): correct (100% -> Strong)
      // Q2 (Reasoning): correct (100% -> Strong)
      // Q3 (General Awareness): incorrect (0% -> Weak)
      final userSelections = {0: 0, 1: 0, 2: 1};

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ExamSummaryScreen(
              result: examResult,
              questions: sampleQuestions,
              userSelections: userSelections,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Topic Breakdown Header
      expect(find.text('Topic & Sectional Analytics'), findsOneWidget);
      expect(find.text('Quantitative Aptitude'), findsWidgets);
      expect(find.text('Logical Reasoning'), findsWidgets);
      expect(find.text('General Awareness'), findsWidgets);

      // Strong vs Weak Badges
      expect(find.text('🎯 Strong Area'), findsNWidgets(2));
      expect(find.text('⚠️ Needs Revision'), findsOneWidget);
    });

    testWidgets('renders full solution review with Tamil & English explanations', (tester) async {
      const examResult = ExamResult(
        totalQuestions: 3,
        attempted: 3,
        correct: 2,
        incorrect: 1,
        optionESelected: 0,
        unattempted: 0,
        positiveMarksEarned: 4.0,
        negativeMarksDeducted: 0.50,
        netScore: 3.50,
        maximumMarks: 6.0,
        timeSpentSeconds: 150,
      );

      final userSelections = {0: 0, 1: 0, 2: 1};

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ExamSummaryScreen(
              result: examResult,
              questions: sampleQuestions,
              userSelections: userSelections,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Solution review header and questions
      expect(find.text('Full Solutions & Review'), findsOneWidget);
      expect(find.text('What is 15% of 300?'), findsOneWidget);
      expect(find.text('300-ல் 15% எவ்வளவு?'), findsOneWidget);
      expect(find.textContaining('15% of 300 = (15/100) * 300 = 45.'), findsOneWidget);
      expect(find.textContaining('300 * 15 / 100 = 45.'), findsOneWidget);

      // Status badges
      expect(find.text('Correct ✓'), findsNWidgets(2));
      expect(find.text('Incorrect ✗'), findsOneWidget);
    });

    testWidgets('triggers Level-Up celebration card when XP crosses 500-point threshold', (tester) async {
      // User has 480 XP. Current Level = 1.
      // This test awards +30 XP -> 510 XP -> crosses 500 XP -> Promoted to Level 2!
      const initialProgress = UserProgress(xp: 480);

      const examResult = ExamResult(
        totalQuestions: 3,
        attempted: 3,
        correct: 2,
        incorrect: 1,
        optionESelected: 0,
        unattempted: 0,
        positiveMarksEarned: 4.0,
        negativeMarksDeducted: 0.50,
        netScore: 3.50,
        maximumMarks: 6.0,
        timeSpentSeconds: 150,
      );

      final userSelections = {0: 0, 1: 0, 2: 1};

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            progressionProvider.overrideWith(() => _MockProgressionNotifier(initialProgress)),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ExamSummaryScreen(
              result: examResult,
              questions: sampleQuestions,
              userSelections: userSelections,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Level-Up celebration card
      expect(find.text('🎉 LEVEL UP CELEBRATION!'), findsOneWidget);
      expect(find.text('Promoted from Level 1 → Level 2!'), findsOneWidget);
      expect(find.textContaining('You crossed the 500 XP milestone!'), findsOneWidget);
    });
  });

  group('GeminiAiService & AiGauntletScreen', () {
    test('GeminiAiService throws user-friendly exception when API key is missing', () async {
      final service = GeminiAiService(apiKey: '');
      expect(
        () => service.generateBilingualQuestions(
          examType: 'rrb_ntpc',
          subject: 'Quantitative Aptitude',
          count: 5,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Gemini API key is not configured'),
          ),
        ),
      );
    });

    test('localDatasource loads offline questions directly', () async {
      final ds = LocalQuestionDatasource(appDatabase: AppDatabase.instance);
      final qs = await ds.getQuestionsByExamType('rrb_ntpc');
      expect(qs.length, greaterThan(0));
    });

    testWidgets('AiGauntletScreen renders exam, subject, difficulty, and question count selectors', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AiGauntletScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Engine Title
      expect(find.text('Gemini 2.5 Flash Bilingual Engine'), findsOneWidget);

      // Selectors
      expect(find.text('Target Competitive Exam'), findsOneWidget);
      expect(find.text('Subject & Topic Area'), findsOneWidget);
      expect(find.text('Difficulty Level'), findsOneWidget);
      expect(find.text('Easy'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Hard'), findsOneWidget);

      // Question count chips: 5, 10, 20
      expect(find.text('5 Questions'), findsOneWidget);
      expect(find.text('10 Questions'), findsOneWidget);
      expect(find.text('20 Questions'), findsOneWidget);

      // Generation & Offline buttons
      expect(find.textContaining('Generate 5 AI MCQs'), findsOneWidget);
      expect(find.textContaining('Load 5 Questions from SQLite Bank'), findsOneWidget);
    });

    testWidgets('AiGauntletScreen loads offline questions from SQLite without API key', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localDatasourceProvider.overrideWithValue(_MockLocalQuestionDatasource(sampleQuestions)),
          ],
          child: const MaterialApp(
            home: AiGauntletScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap "Load 5 Questions from SQLite Bank (100% Offline)"
      final offlineBtn = find.textContaining('Load 5 Questions from SQLite Bank');
      await tester.ensureVisible(offlineBtn);
      await tester.tap(offlineBtn);
      await tester.pumpAndSettle();

      // Questions are retrieved from SQLite
      expect(find.textContaining('Available MCQs'), findsOneWidget);
      expect(find.text('Launch CBT'), findsOneWidget);
    });
  });
}

class _MockLocalQuestionDatasource implements LocalQuestionDatasource {
  final List<Question> _questions;
  _MockLocalQuestionDatasource(this._questions);

  @override
  AppDatabase get appDatabase => AppDatabase.instance;

  @override
  Future<void> seedIfEmpty() async {}

  @override
  Future<void> seedUpscQuestionsIfNeeded() async {}

  @override
  Future<void> seedAllExpandedQuestionsIfNeeded() async {}

  @override
  Future<List<Question>> getQuestionsByExamType(String examType) async {
    return _questions;
  }

  @override
  Future<List<Question>> getQuestionsByCategory(String category) async {
    return _questions;
  }

  @override
  Future<List<Question>> getAllQuestions() async {
    return _questions;
  }

  @override
  Future<int> getQuestionCount() async {
    return _questions.length;
  }

  @override
  Future<void> saveGeneratedQuestions(List<Question> questions) async {}
}

class _MockProgressionNotifier extends ProgressionNotifier {
  final UserProgress _initial;
  _MockProgressionNotifier(this._initial);

  @override
  UserProgress build() => _initial;
}
