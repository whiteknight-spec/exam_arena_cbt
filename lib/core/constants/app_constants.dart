class AppConstants {
  static const String appTitle = 'Exam Arena CBT';
  static const String geminiModel = 'gemini-2.5-flash';
  static const String dbName = 'exam_arena_cbt.db';
  static const int dbVersion = 3;

  // Question Table
  static const String tableQuestions = 'questions';
  static const String colId = 'id';
  static const String colSubject = 'subject';
  static const String colExamType = 'exam_type';
  static const String colCategory = 'category';
  static const String colQuestionEn = 'question_en';
  static const String colQuestionTa = 'question_ta';
  static const String colOptionsEn = 'options_en'; // JSON array string
  static const String colOptionsTa = 'options_ta'; // JSON array string
  static const String colCorrectIndex = 'correct_index';
  static const String colExplanationEn = 'explanation_en';
  static const String colExplanationTa = 'explanation_ta';
  static const String colHasOptionE = 'has_option_e'; // 1 or 0 (TNPSC)
  static const String colDifficulty = 'difficulty';

  // User Progress Table
  static const String tableUserProgress = 'user_progress';
  static const String colProgressId = 'id';
  static const String colXp = 'xp';
  static const String colStreakDays = 'streak_days';
  static const String colLastActiveDate = 'last_active_date';
  static const String colSelectedExam = 'selected_exam';
  static const String colTestsCompleted = 'tests_completed';
  static const String colAverageAccuracy = 'average_accuracy';
  static const String colUnlockedLevels = 'unlocked_levels';
  static const String colHearts = 'hearts';
  static const String colLastHeartRefill = 'last_heart_refill';
  static const int maxHearts = 5;
  static const int heartRegenMinutes = 30;

  // Streak History Table
  static const String tableStreakHistory = 'streak_history';
  static const String colStreakHistoryId = 'id';
  static const String colActivityDate = 'activity_date';
  static const String colStreakCount = 'streak_count';
  static const String colXpEarned = 'xp_earned';
  static const String colDescription = 'description';

  // Test Attempt Analytics Table
  static const String tableTestAttempts = 'test_attempts';
  static const String colAttemptId = 'id';
  static const String colAttemptExamType = 'exam_type';
  static const String colTimestamp = 'timestamp';
  static const String colTotalQuestions = 'total_questions';
  static const String colAttempted = 'attempted';
  static const String colCorrect = 'correct';
  static const String colIncorrect = 'incorrect';
  static const String colOptionESelected = 'option_e_selected';
  static const String colUnattempted = 'unattempted';
  static const String colPositiveMarks = 'positive_marks';
  static const String colNegativeMarks = 'negative_marks';
  static const String colNetScore = 'net_score';
  static const String colMaxMarks = 'max_marks';
  static const String colTimeSpentSeconds = 'time_spent_seconds';
  static const String colAccuracy = 'accuracy';
  static const String colEarnedXp = 'earned_xp';
}
