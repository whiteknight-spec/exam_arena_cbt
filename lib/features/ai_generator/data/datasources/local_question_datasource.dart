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
      await db.rawQuery(
        "SELECT COUNT(*) FROM ${AppConstants.tableQuestions} WHERE ${AppConstants.colExamType} LIKE 'upsc%'",
      ),
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

  Future<List<Question>> getQuestionsByExamType(
    String examType, {
    String? subject,
    String? difficulty,
  }) async {
    await seedIfEmpty();
    await seedAllExpandedQuestionsIfNeeded();
    if (examType.toLowerCase().contains('upsc')) {
      await seedUpscQuestionsIfNeeded();
    }

    final db = await appDatabase.database;
    final lower = examType.toLowerCase();
    var maps = await db.query(
      AppConstants.tableQuestions,
      where: '${AppConstants.colExamType} = ?',
      whereArgs: [examType],
    );

    if (maps.isEmpty) {
      String? familyPrefix;
      if (lower.contains('rrb')) {
        familyPrefix = 'rrb%';
      } else if (lower.contains('upsc')) {
        familyPrefix = 'upsc%';
      } else if (lower.contains('ssc')) {
        familyPrefix = 'ssc%';
      } else if (lower.contains('tnpsc') || lower.contains('tnusrb')) {
        familyPrefix = 'tnpsc%';
      } else if (lower.contains('ibps') || lower.contains('rbi')) {
        familyPrefix = 'ibps%';
      }

      if (familyPrefix != null) {
        final familyMaps = await db.query(
          AppConstants.tableQuestions,
          where: '${AppConstants.colExamType} LIKE ?',
          whereArgs: [familyPrefix],
        );
        if (familyMaps.isNotEmpty) {
          maps = familyMaps;
        }
      }

      if (maps.isEmpty) {
        maps = await db.query(AppConstants.tableQuestions);
      }
    }

    var questions = maps.map((m) => Question.fromMap(m)).toList();

    // Prioritize matching subject & difficulty when requested (e.g. AI Gauntlet offline bank)
    if ((subject != null && subject.trim().isNotEmpty) ||
        (difficulty != null && difficulty.trim().isNotEmpty)) {
      questions = _prioritizeByFilters(
        questions,
        subject: subject,
        difficulty: difficulty,
      );
    }

    return questions;
  }

  List<Question> _prioritizeByFilters(
    List<Question> source, {
    String? subject,
    String? difficulty,
  }) {
    final subLower = subject?.toLowerCase() ?? '';
    final diffLower = difficulty?.toLowerCase() ?? '';

    int scoreQuestion(Question q) {
      int score = 0;
      if (subLower.isNotEmpty) {
        final qSub = '${q.subject} ${q.category}'.toLowerCase();
        if (subLower.contains('quant') && qSub.contains('quant')) {
          score += 2;
        } else if (subLower.contains('reason') && qSub.contains('reason')) {
          score += 2;
        } else if ((subLower.contains('awareness') ||
                subLower.contains('polity') ||
                subLower.contains('science')) &&
            (qSub.contains('awareness') ||
                qSub.contains('polity') ||
                qSub.contains('science') ||
                qSub.contains('history') ||
                qSub.contains('economy'))) {
          score += 2;
        } else if ((subLower.contains('tamil') ||
                subLower.contains('thirukkural') ||
                subLower.contains('english')) &&
            (qSub.contains('tamil') || qSub.contains('english'))) {
          score += 2;
        }
      }
      if (diffLower.isNotEmpty && q.difficulty.toLowerCase() == diffLower) {
        score += 1;
      }
      return score;
    }

    final sorted = List<Question>.from(source);
    sorted.sort((a, b) => scoreQuestion(b).compareTo(scoreQuestion(a)));
    return sorted;
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
