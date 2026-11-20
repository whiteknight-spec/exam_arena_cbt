import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../constants/app_constants.dart';
import '../../features/exam_engine/domain/models/question.dart';
import '../../features/exam_engine/domain/models/test_attempt_analytics.dart';
import '../../features/progression/domain/models/user_progress.dart';
import '../../features/progression/domain/models/streak_history_entry.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  /// Visible for testing: inject or override custom in-memory database instance
  void setDatabaseForTesting(Database db) {
    _database = db;
  }

  /// Visible for testing: initialize an isolated in-memory SQLite database instance
  static Future<Database> createInMemoryDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
    final db = await openDatabase(
      inMemoryDatabasePath,
      version: AppConstants.dbVersion,
      onCreate: (d, v) => instance._createDB(d, v),
      onUpgrade: (d, o, n) => instance._onUpgrade(d, o, n),
    );
    instance.setDatabaseForTesting(db);
    return db;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Bilingual Questions Table
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

    // 2. User Progress (XP, Unlocked Levels, Streak, Tests Completed, Accuracy)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${AppConstants.tableUserProgress} (
        ${AppConstants.colProgressId} TEXT PRIMARY KEY,
        ${AppConstants.colXp} INTEGER NOT NULL DEFAULT 350,
        ${AppConstants.colStreakDays} INTEGER NOT NULL DEFAULT 7,
        ${AppConstants.colLastActiveDate} TEXT,
        ${AppConstants.colSelectedExam} TEXT NOT NULL DEFAULT 'rrb_ntpc',
        ${AppConstants.colTestsCompleted} INTEGER NOT NULL DEFAULT 12,
        ${AppConstants.colAverageAccuracy} REAL NOT NULL DEFAULT 82.5,
        ${AppConstants.colUnlockedLevels} TEXT NOT NULL DEFAULT '[1]',
        ${AppConstants.colHearts} INTEGER NOT NULL DEFAULT 5,
        ${AppConstants.colLastHeartRefill} TEXT
      )
    ''');

    // 3. Streak History Log
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${AppConstants.tableStreakHistory} (
        ${AppConstants.colStreakHistoryId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colActivityDate} TEXT NOT NULL,
        ${AppConstants.colStreakCount} INTEGER NOT NULL,
        ${AppConstants.colXpEarned} INTEGER NOT NULL,
        ${AppConstants.colDescription} TEXT
      )
    ''');

    // 4. Test Attempt Analytics
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
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Create any missing tables on upgrade
      await _createDB(db, newVersion);

      // Check if hearts column exists in user_progress table
      try {
        final progressCols = await db.rawQuery('PRAGMA table_info(${AppConstants.tableUserProgress})');
        final hasHearts = progressCols.any((c) => c['name'] == AppConstants.colHearts);
        if (!hasHearts) {
          await db.execute(
            'ALTER TABLE ${AppConstants.tableUserProgress} ADD COLUMN ${AppConstants.colHearts} INTEGER NOT NULL DEFAULT 5',
          );
        }
        final hasRefill = progressCols.any((c) => c['name'] == AppConstants.colLastHeartRefill);
        if (!hasRefill) {
          await db.execute(
            'ALTER TABLE ${AppConstants.tableUserProgress} ADD COLUMN ${AppConstants.colLastHeartRefill} TEXT',
          );
        }
      } catch (_) {}

      // Check if category column exists in questions table
      try {
        final cols = await db.rawQuery('PRAGMA table_info(${AppConstants.tableQuestions})');
        final hasCategory = cols.any((c) => c['name'] == AppConstants.colCategory);
        if (!hasCategory) {
          await db.execute(
            'ALTER TABLE ${AppConstants.tableQuestions} ADD COLUMN ${AppConstants.colCategory} TEXT NOT NULL DEFAULT ""',
          );
        }
        final hasDifficulty = cols.any((c) => c['name'] == AppConstants.colDifficulty);
        if (!hasDifficulty) {
          await db.execute(
            'ALTER TABLE ${AppConstants.tableQuestions} ADD COLUMN ${AppConstants.colDifficulty} TEXT DEFAULT "medium"',
          );
        }
      } catch (_) {}
    }
  }

  // =========================================================================
  // USER PROGRESS PERSISTENCE
  // =========================================================================

  Future<void> saveUserProgress(UserProgress progress) async {
    final db = await database;
    await db.insert(
      AppConstants.tableUserProgress,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserProgress?> getUserProgress() async {
    final db = await database;
    final results = await db.query(
      AppConstants.tableUserProgress,
      where: '${AppConstants.colProgressId} = ?',
      whereArgs: ['current_user'],
    );

    if (results.isNotEmpty) {
      return UserProgress.fromMap(results.first);
    }
    return null;
  }

  // =========================================================================
  // STREAK HISTORY PERSISTENCE
  // =========================================================================

  Future<void> insertStreakEntry(StreakHistoryEntry entry) async {
    final db = await database;
    await db.insert(
      AppConstants.tableStreakHistory,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<StreakHistoryEntry>> getStreakHistory({int limit = 30}) async {
    final db = await database;
    final results = await db.query(
      AppConstants.tableStreakHistory,
      orderBy: '${AppConstants.colActivityDate} DESC',
      limit: limit,
    );
    return results.map((m) => StreakHistoryEntry.fromMap(m)).toList();
  }

  // =========================================================================
  // TEST ATTEMPT ANALYTICS PERSISTENCE
  // =========================================================================

  Future<void> insertTestAttempt(TestAttemptAnalytics attempt) async {
    final db = await database;
    await db.insert(
      AppConstants.tableTestAttempts,
      attempt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TestAttemptAnalytics>> getTestAttempts({int limit = 50}) async {
    final db = await database;
    final results = await db.query(
      AppConstants.tableTestAttempts,
      orderBy: '${AppConstants.colTimestamp} DESC',
      limit: limit,
    );
    return results.map((m) => TestAttemptAnalytics.fromMap(m)).toList();
  }

  Future<TestAttemptAnalytics?> getLatestTestAttempt() async {
    final db = await database;
    final results = await db.query(
      AppConstants.tableTestAttempts,
      orderBy: '${AppConstants.colTimestamp} DESC',
      limit: 1,
    );
    if (results.isNotEmpty) {
      return TestAttemptAnalytics.fromMap(results.first);
    }
    return null;
  }

  // =========================================================================
  // BILINGUAL MCQS PERSISTENCE
  // =========================================================================

  Future<int> getQuestionCount() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.tableQuestions}'),
    );
    return count ?? 0;
  }

  Future<List<Question>> getAllQuestions() async {
    final db = await database;
    final results = await db.query(AppConstants.tableQuestions);
    return results.map((m) => Question.fromMap(m)).toList();
  }

  Future<List<Question>> getQuestionsByExamType(String examType) async {
    final db = await database;
    final results = await db.query(
      AppConstants.tableQuestions,
      where: '${AppConstants.colExamType} = ?',
      whereArgs: [examType],
    );
    return results.map((m) => Question.fromMap(m)).toList();
  }

  Future<List<Question>> getQuestionsByCategory(String category) async {
    final db = await database;
    final results = await db.query(
      AppConstants.tableQuestions,
      where: '${AppConstants.colCategory} = ?',
      whereArgs: [category],
    );
    return results.map((m) => Question.fromMap(m)).toList();
  }

  Future<void> insertQuestions(List<Question> questions) async {
    final db = await database;
    final batch = db.batch();
    for (final q in questions) {
      batch.insert(
        AppConstants.tableQuestions,
        q.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
