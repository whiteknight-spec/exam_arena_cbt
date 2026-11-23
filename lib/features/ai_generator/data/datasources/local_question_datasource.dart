import 'package:sqflite/sqflite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../exam_engine/domain/models/question.dart';
import '../seed/seed_questions.dart';

class LocalQuestionDatasource {
  final AppDatabase appDatabase;

  LocalQuestionDatasource({required this.appDatabase});

  /// Seeds all 30 universal high-yield bilingual questions if the database is empty.
  Future<void> seedIfEmpty() async {
    final db = await appDatabase.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.tableQuestions}'),
    );

    if (count == null || count == 0) {
      final initialQuestions = SeedQuestions.getInitialQuestions();
      final batch = db.batch();
      for (final q in initialQuestions) {
        batch.insert(
          AppConstants.tableQuestions,
          q.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    }
  }

  /// Seeds authentic UPSC Civil Services & Defence question papers on demand
  Future<void> seedUpscQuestionsIfNeeded() async {
    final db = await appDatabase.database;
    final upscCount = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM ${AppConstants.tableQuestions} WHERE ${AppConstants.colExamType} LIKE 'upsc%'"),
    );
    if (upscCount == null || upscCount == 0) {
      final upscQuestions = SeedQuestions.getUpscQuestions();
      final batch = db.batch();
      for (final q in upscQuestions) {
        batch.insert(
          AppConstants.tableQuestions,
          q.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    }
  }

  /// Seeds all authentic expanded questions for TNPSC, RRB, SSC, Banking and UPSC if needed.
  Future<void> seedAllExpandedQuestionsIfNeeded() async {
    final db = await appDatabase.database;
    final totalCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.tableQuestions}'),
    );
    if (totalCount == null || totalCount < 70) {
      final expanded = SeedQuestions.getAllComprehensiveQuestions();
      final batch = db.batch();
      for (final q in expanded) {
        batch.insert(
          AppConstants.tableQuestions,
          q.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    }
  }

  Future<List<Question>> getQuestionsByExamType(String examType) async {
    await seedIfEmpty();
    await seedAllExpandedQuestionsIfNeeded();
    if (examType.toLowerCase().contains('upsc')) {
      await seedUpscQuestionsIfNeeded();
    }
    final db = await appDatabase.database;
    final maps = await db.query(
      AppConstants.tableQuestions,
      where: '${AppConstants.colExamType} = ?',
      whereArgs: [examType],
    );

    if (maps.isEmpty) {
      // Fallback: If a Railways paper has no exact sub-id match, return all Railways questions
      if (examType.toLowerCase().contains('rrb')) {
        final rrbMaps = await db.query(
          AppConstants.tableQuestions,
          where: "${AppConstants.colExamType} LIKE 'rrb%'",
        );
        if (rrbMaps.isNotEmpty) {
          return rrbMaps.map((m) => Question.fromMap(m)).toList();
        }
      }

      // Fallback: If a UPSC paper has no exact sub-id match, return all UPSC paper questions
      if (examType.toLowerCase().contains('upsc')) {
        final upscMaps = await db.query(
          AppConstants.tableQuestions,
          where: "${AppConstants.colExamType} LIKE 'upsc%'",
        );
        if (upscMaps.isNotEmpty) {
          return upscMaps.map((m) => Question.fromMap(m)).toList();
        }
      }

      // Fallback: If an SSC paper has no exact sub-id match, return all SSC questions
      if (examType.toLowerCase().contains('ssc')) {
        final sscMaps = await db.query(
          AppConstants.tableQuestions,
          where: "${AppConstants.colExamType} LIKE 'ssc%'",
        );
        if (sscMaps.isNotEmpty) {
          return sscMaps.map((m) => Question.fromMap(m)).toList();
        }
      }

      // Fallback: return all available questions if specific exam has no subset
      final allMaps = await db.query(AppConstants.tableQuestions);
      return allMaps.map((m) => Question.fromMap(m)).toList();
    }

    return maps.map((m) => Question.fromMap(m)).toList();
  }

  Future<List<Question>> getQuestionsByCategory(String category) async {
    await seedIfEmpty();
    final db = await appDatabase.database;
    final maps = await db.query(
      AppConstants.tableQuestions,
      where: '${AppConstants.colCategory} = ?',
      whereArgs: [category],
    );

    if (maps.isEmpty) {
      final allMaps = await db.query(AppConstants.tableQuestions);
      return allMaps.map((m) => Question.fromMap(m)).toList();
    }

    return maps.map((m) => Question.fromMap(m)).toList();
  }

  Future<List<Question>> getAllQuestions() async {
    await seedIfEmpty();
    final db = await appDatabase.database;
    final maps = await db.query(AppConstants.tableQuestions);
    return maps.map((m) => Question.fromMap(m)).toList();
  }

  Future<int> getQuestionCount() async {
    await seedIfEmpty();
    final db = await appDatabase.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.tableQuestions}'),
    );
    return count ?? 0;
  }

  Future<void> saveGeneratedQuestions(List<Question> questions) async {
    final db = await appDatabase.database;
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
}
