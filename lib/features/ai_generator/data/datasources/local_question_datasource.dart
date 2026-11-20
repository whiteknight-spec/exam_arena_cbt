import 'package:sqflite/sqflite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../exam_engine/domain/models/question.dart';
import '../seed/seed_questions.dart';

class LocalQuestionDatasource {
  final AppDatabase appDatabase;

  LocalQuestionDatasource({required this.appDatabase});

  /// Seeds all 30 universal high-yield bilingual questions if the database has fewer than 30 questions
  Future<void> seedIfEmpty() async {
    final db = await appDatabase.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.tableQuestions}'),
    );

    if (count == null || count < 30) {
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

  Future<List<Question>> getQuestionsByExamType(String examType) async {
    await seedIfEmpty();
    final db = await appDatabase.database;
    final maps = await db.query(
      AppConstants.tableQuestions,
      where: '${AppConstants.colExamType} = ?',
      whereArgs: [examType],
    );

    if (maps.isEmpty) {
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
