import 'exam_result.dart';

class TestAttemptAnalytics {
  final String id;
  final String examType;
  final DateTime timestamp;
  final int totalQuestions;
  final int attempted;
  final int correct;
  final int incorrect;
  final int optionESelected;
  final int unattempted;
  final double positiveMarks;
  final double negativeMarks;
  final double netScore;
  final double maxMarks;
  final int timeSpentSeconds;
  final double accuracy;
  final int earnedXp;

  const TestAttemptAnalytics({
    required this.id,
    required this.examType,
    required this.timestamp,
    required this.totalQuestions,
    required this.attempted,
    required this.correct,
    required this.incorrect,
    required this.optionESelected,
    required this.unattempted,
    required this.positiveMarks,
    required this.negativeMarks,
    required this.netScore,
    required this.maxMarks,
    required this.timeSpentSeconds,
    required this.accuracy,
    required this.earnedXp,
  });

  factory TestAttemptAnalytics.fromExamResult({
    required String id,
    required String examType,
    required DateTime timestamp,
    required ExamResult result,
    required int earnedXp,
  }) {
    return TestAttemptAnalytics(
      id: id,
      examType: examType,
      timestamp: timestamp,
      totalQuestions: result.totalQuestions,
      attempted: result.attempted,
      correct: result.correct,
      incorrect: result.incorrect,
      optionESelected: result.optionESelected,
      unattempted: result.unattempted,
      positiveMarks: result.positiveMarksEarned,
      negativeMarks: result.negativeMarksDeducted,
      netScore: result.netScore,
      maxMarks: result.maximumMarks,
      timeSpentSeconds: result.timeSpentSeconds,
      accuracy: result.accuracy,
      earnedXp: earnedXp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exam_type': examType,
      'timestamp': timestamp.toIso8601String(),
      'total_questions': totalQuestions,
      'attempted': attempted,
      'correct': correct,
      'incorrect': incorrect,
      'option_e_selected': optionESelected,
      'unattempted': unattempted,
      'positive_marks': positiveMarks,
      'negative_marks': negativeMarks,
      'net_score': netScore,
      'max_marks': maxMarks,
      'time_spent_seconds': timeSpentSeconds,
      'accuracy': accuracy,
      'earned_xp': earnedXp,
    };
  }

  factory TestAttemptAnalytics.fromMap(Map<String, dynamic> map) {
    return TestAttemptAnalytics(
      id: map['id']?.toString() ?? '',
      examType: map['exam_type']?.toString() ?? '',
      timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      totalQuestions: map['total_questions'] as int? ?? 0,
      attempted: map['attempted'] as int? ?? 0,
      correct: map['correct'] as int? ?? 0,
      incorrect: map['incorrect'] as int? ?? 0,
      optionESelected: map['option_e_selected'] as int? ?? 0,
      unattempted: map['unattempted'] as int? ?? 0,
      positiveMarks: (map['positive_marks'] as num?)?.toDouble() ?? 0.0,
      negativeMarks: (map['negative_marks'] as num?)?.toDouble() ?? 0.0,
      netScore: (map['net_score'] as num?)?.toDouble() ?? 0.0,
      maxMarks: (map['max_marks'] as num?)?.toDouble() ?? 0.0,
      timeSpentSeconds: map['time_spent_seconds'] as int? ?? 0,
      accuracy: (map['accuracy'] as num?)?.toDouble() ?? 0.0,
      earnedXp: map['earned_xp'] as int? ?? 0,
    );
  }
}
