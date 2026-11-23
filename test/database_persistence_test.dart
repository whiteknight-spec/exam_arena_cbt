import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/constants/app_constants.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/features/ai_generator/data/seed/seed_questions.dart';
import 'package:exam_arena_cbt/features/ai_generator/data/datasources/local_question_datasource.dart';
import 'package:exam_arena_cbt/features/ai_generator/domain/repositories/question_repository.dart';
import 'package:exam_arena_cbt/features/ai_generator/data/datasources/gemini_ai_service.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/user_progress.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/streak_history_entry.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/test_attempt_analytics.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/exam_result.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Seed 30 Universal High-Yield Bilingual Questions Bank', () {
    final questions = SeedQuestions.getInitialQuestions();

    test('Total questions seeded is exactly 30', () {
      expect(questions.length, 30);
    });

    test('Covers Quantitative Aptitude (Percentages, Ratio, Time & Work, Simplification)', () {
      final quant = questions.where((q) => q.category == 'Quantitative Aptitude').toList();
      expect(quant.length, 8);

      // Percentages
      expect(quant.any((q) => q.id == 'quant_01' && q.questionEn.contains('price of sugar')), isTrue);
      expect(quant.any((q) => q.id == 'quant_02' && q.questionEn.contains('population')), isTrue);

      // Ratio & Proportion
      expect(quant.any((q) => q.id == 'quant_03' && q.questionEn.contains('ages of A and B')), isTrue);
      expect(quant.any((q) => q.id == 'quant_04' && q.questionEn.contains('milk and water')), isTrue);

      // Time & Work
      expect(quant.any((q) => q.id == 'quant_05' && q.questionEn.contains('fraction of the total work')), isTrue);
      expect(quant.any((q) => q.id == 'quant_06' && q.questionEn.contains('15 men')), isTrue);

      // Simplification
      expect(quant.any((q) => q.id == 'quant_07' && q.questionEn.contains('√[176 + √(2401)]')), isTrue);
      expect(quant.any((q) => q.id == 'quant_08' && q.questionEn.contains('25% of 480')), isTrue);
    });

    test('Covers Logical Reasoning (Series, Coding-Decoding, Blood Relations, Syllogisms)', () {
      final reasoning = questions.where((q) => q.category == 'Logical Reasoning').toList();
      expect(reasoning.length, 7);

      // Series
      expect(reasoning.any((q) => q.id == 'reason_01' && q.questionEn.contains('7, 11, 20, 36, 61')), isTrue);
      expect(reasoning.any((q) => q.id == 'reason_02' && q.questionEn.contains('B2D, E4G, H8J')), isTrue);

      // Coding-Decoding
      expect(reasoning.any((q) => q.id == 'reason_03' && q.questionEn.contains('TEACHER')), isTrue);
      expect(reasoning.any((q) => q.id == 'reason_04' && q.questionEn.contains('CAT is coded as 24')), isTrue);

      // Blood Relations
      expect(reasoning.any((q) => q.id == 'reason_05' && q.questionEn.contains('daughter of my grandfather')), isTrue);
      expect(reasoning.any((q) => q.id == 'reason_06' && q.questionEn.contains('aunt of N')), isTrue);

      // Syllogisms
      expect(reasoning.any((q) => q.id == 'reason_07' && q.questionEn.contains('roses are flowers')), isTrue);
    });

    test('Covers General Awareness & Indian Polity/History (Constitution, Freedom, Current Affairs, Science)', () {
      final ga = questions.where((q) => q.category == 'General Awareness').toList();
      expect(ga.length, 8);

      // Constitution
      expect(ga.any((q) => q.id == 'ga_01' && q.questionEn.contains('Socialist, Secular')), isTrue);
      expect(ga.any((q) => q.id == 'ga_02' && q.questionEn.contains('Heart and Soul')), isTrue);

      // Freedom Movement
      expect(ga.any((q) => q.id == 'ga_03' && q.questionEn.contains('Barrackpore')), isTrue);
      expect(ga.any((q) => q.id == 'ga_04' && q.questionEn.contains('Dandi March')), isTrue);

      // Indian History / Culture
      expect(ga.any((q) => q.id == 'ga_05' && q.questionEn.contains('Brihadisvara Temple')), isTrue);

      // Current Affairs
      expect(ga.any((q) => q.id == 'ga_06' && q.optionsEn.contains('Aditya-L1')), isTrue);

      // General Science
      expect(ga.any((q) => q.id == 'ga_07' && q.optionsEn.contains("Ohm's Law")), isTrue);
      expect(ga.any((q) => q.id == 'ga_08' && q.questionEn.contains('Universal Donor')), isTrue);
    });

    test('Covers General Tamil & English (TNPSC Ilakkanam/Ilakkiyam + SSC/Banking English Grammar)', () {
      final lang = questions.where((q) => q.category == 'General Tamil & English').toList();
      expect(lang.length, 7);

      // TNPSC Tamil Ilakkanam
      expect(lang.any((q) => q.id == 'lang_01' && q.questionTa.contains('வல்லினம்')), isTrue);
      expect(lang.any((q) => q.id == 'lang_02' && q.questionTa.contains('வந்தனன்')), isTrue);

      // TNPSC Tamil Ilakkiyam
      expect(lang.any((q) => q.id == 'lang_03' && q.questionTa.contains('எப்பொருள் யார்யார்வாய்க் கேட்பினும்')), isTrue);
      expect(lang.any((q) => q.id == 'lang_04' && q.questionTa.contains('யாதும் ஊரே யாவரும் கேளிர்')), isTrue);

      // English Grammar
      expect(lang.any((q) => q.id == 'lang_05' && q.questionEn.contains('Subject-Verb Agreement')), isTrue);
      expect(lang.any((q) => q.id == 'lang_06' && q.questionEn.contains('blessing in disguise')), isTrue);
      expect(lang.any((q) => q.id == 'lang_07' && q.questionEn.contains('chief architect designed')), isTrue);
    });

    test('All 30 questions have full 100% bilingual text and explanations', () {
      for (final q in questions) {
        expect(q.id.isNotEmpty, isTrue, reason: 'ID must not be empty');
        expect(q.subject.isNotEmpty, isTrue, reason: 'Subject must not be empty');
        expect(q.examType.isNotEmpty, isTrue, reason: 'Exam type must not be empty');
        expect(q.questionEn.isNotEmpty, isTrue, reason: 'questionEn must not be empty in ${q.id}');
        expect(q.questionTa.isNotEmpty, isTrue, reason: 'questionTa must not be empty in ${q.id}');
        expect(q.optionsEn.isNotEmpty, isTrue, reason: 'optionsEn must not be empty in ${q.id}');
        expect(q.optionsTa.isNotEmpty, isTrue, reason: 'optionsTa must not be empty in ${q.id}');
        expect(q.optionsEn.length, q.optionsTa.length, reason: 'Option count mismatch in ${q.id}');
        expect(q.correctIndex, greaterThanOrEqualTo(0));
        expect(q.correctIndex, lessThan(q.optionsEn.length));
        expect(q.explanationEn.isNotEmpty, isTrue, reason: 'explanationEn must not be empty in ${q.id}');
        expect(q.explanationTa.isNotEmpty, isTrue, reason: 'explanationTa must not be empty in ${q.id}');
      }
    });

    test('TNPSC questions have 5 options A–E with Option E as Answer Not Known', () {
      final tnpscQuestions = questions.where((q) => q.examType == 'tnpsc_group_2_4').toList();
      expect(tnpscQuestions.length, 5);

      for (final q in tnpscQuestions) {
        expect(q.hasOptionE, isTrue);
        expect(q.optionsEn.length, 5);
        expect(q.optionsTa.length, 5);
        expect(q.optionsEn[4].contains('Option E'), isTrue);
        expect(q.optionsTa[4].contains('Option E'), isTrue);
      }
    });
  });

  group('SQLite Persistence in exam_arena_cbt.db', () {
    late Database testDb;
    late AppDatabase appDb;

    setUp(() async {
      // In-memory SQLite database instance for pure test isolation
      testDb = await openDatabase(
        inMemoryDatabasePath,
        version: AppConstants.dbVersion,
        onCreate: (db, version) async {
          // 1. Questions Table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ${AppConstants.tableQuestions} (
              ${AppConstants.colId} TEXT PRIMARY KEY,
              ${AppConstants.colSubject} TEXT NOT NULL,
              ${AppConstants.colExamType} TEXT NOT NULL,
              ${AppConstants.colCategory} TEXT NOT NULL,
              ${AppConstants.colQuestionEn} TEXT NOT NULL,
              ${AppConstants.colQuestionTa} TEXT NOT NULL,
              ${AppConstants.colOptionsEn} TEXT NOT NULL,
              ${AppConstants.colOptionsTa} TEXT NOT NULL,
              ${AppConstants.colCorrectIndex} INTEGER NOT NULL,
              ${AppConstants.colExplanationEn} TEXT NOT NULL,
              ${AppConstants.colExplanationTa} TEXT NOT NULL,
              ${AppConstants.colHasOptionE} INTEGER NOT NULL DEFAULT 0,
              ${AppConstants.colDifficulty} TEXT DEFAULT 'medium'
            )
          ''');

          // 2. User Progress Table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ${AppConstants.tableUserProgress} (
              ${AppConstants.colProgressId} TEXT PRIMARY KEY,
              ${AppConstants.colXp} INTEGER NOT NULL DEFAULT 0,
              ${AppConstants.colStreakDays} INTEGER NOT NULL DEFAULT 0,
              ${AppConstants.colLastActiveDate} TEXT,
              ${AppConstants.colSelectedExam} TEXT NOT NULL DEFAULT 'rrb_ntpc',
              ${AppConstants.colTestsCompleted} INTEGER NOT NULL DEFAULT 0,
              ${AppConstants.colAverageAccuracy} REAL NOT NULL DEFAULT 0.0,
              ${AppConstants.colUnlockedLevels} TEXT NOT NULL DEFAULT '[1]',
              ${AppConstants.colHearts} INTEGER NOT NULL DEFAULT 5,
              ${AppConstants.colLastHeartRefill} TEXT
            )
          ''');

          // 3. Streak History Table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ${AppConstants.tableStreakHistory} (
              ${AppConstants.colStreakHistoryId} INTEGER PRIMARY KEY AUTOINCREMENT,
              ${AppConstants.colActivityDate} TEXT NOT NULL,
              ${AppConstants.colStreakCount} INTEGER NOT NULL,
              ${AppConstants.colXpEarned} INTEGER NOT NULL,
              ${AppConstants.colDescription} TEXT
            )
          ''');

          // 4. Test Attempts Table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ${AppConstants.tableTestAttempts} (
              ${AppConstants.colAttemptId} TEXT PRIMARY KEY,
              ${AppConstants.colAttemptExamType} TEXT NOT NULL,
              ${AppConstants.colTimestamp} TEXT NOT NULL,
              ${AppConstants.colTotalQuestions} INTEGER NOT NULL,
              ${AppConstants.colAttempted} INTEGER NOT NULL,
              ${AppConstants.colCorrect} INTEGER NOT NULL,
              ${AppConstants.colIncorrect} INTEGER NOT NULL,
              ${AppConstants.colOptionESelected} INTEGER NOT NULL,
              ${AppConstants.colUnattempted} INTEGER NOT NULL,
              ${AppConstants.colPositiveMarks} REAL NOT NULL,
              ${AppConstants.colNegativeMarks} REAL NOT NULL,
              ${AppConstants.colNetScore} REAL NOT NULL,
              ${AppConstants.colMaxMarks} REAL NOT NULL,
              ${AppConstants.colTimeSpentSeconds} INTEGER NOT NULL,
              ${AppConstants.colAccuracy} REAL NOT NULL,
              ${AppConstants.colEarnedXp} INTEGER NOT NULL
            )
          ''');
        },
      );

      appDb = AppDatabase.instance;
      appDb.setDatabaseForTesting(testDb);
    });

    tearDown(() async {
      await testDb.close();
    });

    test('Persists and loads UserProgress (XP, streak, unlocked levels)', () async {
      const initialProgress = UserProgress(
        xp: 1200,
        streakDays: 14,
        selectedExam: ExamType.sscCgl,
        testsCompleted: 25,
        averageAccuracy: 88.5,
      );

      await appDb.saveUserProgress(initialProgress);

      final loaded = await appDb.getUserProgress();
      expect(loaded, isNotNull);
      expect(loaded!.xp, 1200);
      expect(loaded.streakDays, 14);
      expect(loaded.selectedExam, ExamType.sscCgl);
      expect(loaded.testsCompleted, 25);
      expect(loaded.averageAccuracy, 88.5);
      expect(loaded.currentLevelNumber, 3);
      expect(loaded.isLevelUnlocked(1), isTrue);
      expect(loaded.isLevelUnlocked(2), isTrue);
      expect(loaded.isLevelUnlocked(3), isTrue);
      expect(loaded.isLevelUnlocked(4), isFalse);
      expect(loaded.unlockedLevels, containsAll([1, 2, 3]));
    });

    test('Persists and retrieves Streak History log entries', () async {
      final now = DateTime.now();
      final entry1 = StreakHistoryEntry(
        activityDate: now.subtract(const Duration(days: 1)),
        streakCount: 5,
        xpEarned: 120,
        description: 'Completed RRB NTPC mock test',
      );
      final entry2 = StreakHistoryEntry(
        activityDate: now,
        streakCount: 6,
        xpEarned: 150,
        description: 'Completed SSC CGL mock test',
      );

      await appDb.insertStreakEntry(entry1);
      await appDb.insertStreakEntry(entry2);

      final history = await appDb.getStreakHistory();
      expect(history.length, 2);
      expect(history.first.streakCount, 6);
      expect(history.first.xpEarned, 150);
      expect(history.last.streakCount, 5);
      expect(history.last.xpEarned, 120);
    });

    test('Persists and retrieves Test Attempt Analytics', () async {
      const examResult = ExamResult(
        totalQuestions: 20,
        attempted: 18,
        correct: 16,
        incorrect: 2,
        optionESelected: 0,
        unattempted: 2,
        positiveMarksEarned: 32.0,
        negativeMarksDeducted: 1.0,
        netScore: 31.0,
        maximumMarks: 40.0,
        timeSpentSeconds: 720,
      );

      final attempt = TestAttemptAnalytics.fromExamResult(
        id: 'test_attempt_001',
        examType: 'ssc_cgl',
        timestamp: DateTime.now(),
        result: examResult,
        earnedXp: 210,
      );

      await appDb.insertTestAttempt(attempt);

      final attempts = await appDb.getTestAttempts();
      expect(attempts.length, 1);
      expect(attempts.first.id, 'test_attempt_001');
      expect(attempts.first.examType, 'ssc_cgl');
      expect(attempts.first.totalQuestions, 20);
      expect(attempts.first.correct, 16);
      expect(attempts.first.incorrect, 2);
      expect(attempts.first.netScore, 31.0);
      expect(attempts.first.earnedXp, 210);
      expect(attempts.first.accuracy, (16 / 18) * 100);

      final latest = await appDb.getLatestTestAttempt();
      expect(latest, isNotNull);
      expect(latest!.id, 'test_attempt_001');
    });

    test('LocalQuestionDatasource seeds all 30 questions into SQLite and queries offline', () async {
      final datasource = LocalQuestionDatasource(appDatabase: appDb);

      // Verify empty initially
      final initialCount = await appDb.getQuestionCount();
      expect(initialCount, 0);

      // Run seeding
      await datasource.seedIfEmpty();

      final countAfterSeed = await appDb.getQuestionCount();
      expect(countAfterSeed, 30);

      // Query by Exam Type
      final rrbQuestions = await datasource.getQuestionsByExamType('rrb_ntpc');
      expect(rrbQuestions.isNotEmpty, isTrue);

      final sscQuestions = await datasource.getQuestionsByExamType('ssc_cgl');
      expect(sscQuestions.isNotEmpty, isTrue);

      final tnpscQuestions = await datasource.getQuestionsByExamType('tnpsc_group_2_4');
      expect(tnpscQuestions.isNotEmpty, isTrue);
      expect(tnpscQuestions.first.hasOptionE, isTrue);

      final ibpsQuestions = await datasource.getQuestionsByExamType('ibps_sbi_clerk');
      expect(ibpsQuestions.isNotEmpty, isTrue);

      // Query by Category
      final quantQuestions = await datasource.getQuestionsByCategory('Quantitative Aptitude');
      expect(quantQuestions.length, 8);

      final reasoningQuestions = await datasource.getQuestionsByCategory('Logical Reasoning');
      expect(reasoningQuestions.length, 7);

      final gaQuestions = await datasource.getQuestionsByCategory('General Awareness');
      expect(gaQuestions.length, 8);

      final langQuestions = await datasource.getQuestionsByCategory('General Tamil & English');
      expect(langQuestions.length, 7);
    });

    test('QuestionRepository works 100% offline out of the box with SQLite', () async {
      final datasource = LocalQuestionDatasource(appDatabase: appDb);
      await datasource.seedIfEmpty();

      final repository = QuestionRepository(
        localDatasource: datasource,
        geminiService: GeminiAiService(),
      );

      final offlineQuestions = await repository.getOfflineQuestions('rrb_ntpc');
      expect(offlineQuestions.isNotEmpty, isTrue);
      expect(offlineQuestions.first.questionEn.isNotEmpty, isTrue);
      expect(offlineQuestions.first.questionTa.isNotEmpty, isTrue);

      final allQuestions = await repository.getAllOfflineQuestions();
      expect(allQuestions.length, 30);
    });
  });
}
