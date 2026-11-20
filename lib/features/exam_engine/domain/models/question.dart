import 'dart:convert';

class Question {
  final String id;
  final String subject;
  final String examType;
  final String category;
  final String questionEn;
  final String questionTa;
  final List<String> optionsEn;
  final List<String> optionsTa;
  final int correctIndex;
  final String explanationEn;
  final String explanationTa;
  final bool hasOptionE;
  final String difficulty;

  const Question({
    required this.id,
    required this.subject,
    required this.examType,
    this.category = '',
    required this.questionEn,
    required this.questionTa,
    required this.optionsEn,
    required this.optionsTa,
    required this.correctIndex,
    required this.explanationEn,
    required this.explanationTa,
    this.hasOptionE = false,
    this.difficulty = 'medium',
  });

  String get displayCategory => category.isNotEmpty ? category : subject;

  String getQuestion(bool isTamil) => isTamil ? questionTa : questionEn;

  List<String> getOptions(bool isTamil) => isTamil ? optionsTa : optionsEn;

  String getExplanation(bool isTamil) => isTamil ? explanationTa : explanationEn;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'exam_type': examType,
      'category': displayCategory,
      'question_en': questionEn,
      'question_ta': questionTa,
      'options_en': jsonEncode(optionsEn),
      'options_ta': jsonEncode(optionsTa),
      'correct_index': correctIndex,
      'explanation_en': explanationEn,
      'explanation_ta': explanationTa,
      'has_option_e': hasOptionE ? 1 : 0,
      'difficulty': difficulty,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    List<String> parseList(dynamic val) {
      if (val is List) return val.map((e) => e.toString()).toList();
      if (val is String) {
        try {
          final decoded = jsonDecode(val);
          if (decoded is List) return decoded.map((e) => e.toString()).toList();
        } catch (_) {}
      }
      return [];
    }

    return Question(
      id: map['id']?.toString() ?? '',
      subject: map['subject']?.toString() ?? '',
      examType: map['exam_type']?.toString() ?? '',
      category: map['category']?.toString() ?? map['subject']?.toString() ?? '',
      questionEn: map['question_en']?.toString() ?? '',
      questionTa: map['question_ta']?.toString() ?? '',
      optionsEn: parseList(map['options_en']),
      optionsTa: parseList(map['options_ta']),
      correctIndex: map['correct_index'] as int? ?? 0,
      explanationEn: map['explanation_en']?.toString() ?? '',
      explanationTa: map['explanation_ta']?.toString() ?? '',
      hasOptionE: (map['has_option_e'] as int? ?? 0) == 1,
      difficulty: map['difficulty']?.toString() ?? 'medium',
    );
  }
}
