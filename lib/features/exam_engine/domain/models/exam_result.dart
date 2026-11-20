class ExamResult {
  final int totalQuestions;
  final int attempted;
  final int correct;
  final int incorrect;
  final int optionESelected; // TNPSC Option E ("விடை தெரியவில்லை")
  final int unattempted;
  final double positiveMarksEarned;
  final double negativeMarksDeducted;
  final double netScore;
  final double maximumMarks;
  final int timeSpentSeconds;

  const ExamResult({
    required this.totalQuestions,
    required this.attempted,
    required this.correct,
    required this.incorrect,
    required this.optionESelected,
    required this.unattempted,
    required this.positiveMarksEarned,
    required this.negativeMarksDeducted,
    required this.netScore,
    required this.maximumMarks,
    required this.timeSpentSeconds,
  });

  double get accuracy {
    final scoredAttempts = correct + incorrect;
    if (scoredAttempts == 0) return 0.0;
    return (correct / scoredAttempts) * 100;
  }
}
