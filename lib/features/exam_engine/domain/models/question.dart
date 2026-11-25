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

  String getSafeOption(int index, bool isTamil) {
    final primary = isTamil ? optionsTa : optionsEn;
    if (index >= 0 && index < primary.length) {
      return primary[index];
    }
    if (index >= 0 && index < optionsEn.length) {
      return optionsEn[index];
    }
    return '';
  }

  String get safeCorrectOptionEn => getSafeOption(correctIndex, false);

  String get safeCorrectOptionTa => getSafeOption(correctIndex, true);

  String getSafeCorrectOption(bool isTamil) => getSafeOption(correctIndex, isTamil);

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

    final parsedOptionsEn = parseList(map['options_en']);
    final parsedOptionsTa = parseList(map['options_ta']);
    final rawCorrect = (map['correct_index'] as num?)?.toInt() ?? 0;
    final maxIdx = parsedOptionsEn.isNotEmpty
        ? parsedOptionsEn.length - 1
        : (parsedOptionsTa.isNotEmpty ? parsedOptionsTa.length - 1 : 0);
    final safeCorrectIndex = rawCorrect.clamp(0, maxIdx);

    final rawHasOptionE = map['has_option_e'];
    final parsedHasOptionE = rawHasOptionE is bool
        ? rawHasOptionE
        : (rawHasOptionE as num?)?.toInt() == 1;

    return Question(
      id: map['id']?.toString() ?? '',
      subject: map['subject']?.toString() ?? '',
      examType: map['exam_type']?.toString() ?? '',
      category: map['category']?.toString() ?? map['subject']?.toString() ?? '',
      questionEn: map['question_en']?.toString() ?? '',
      questionTa: map['question_ta']?.toString() ?? '',
      optionsEn: parsedOptionsEn,
      optionsTa: parsedOptionsTa,
      correctIndex: safeCorrectIndex,
      explanationEn: map['explanation_en']?.toString() ?? '',
      explanationTa: map['explanation_ta']?.toString() ?? '',
      hasOptionE: parsedHasOptionE,
      difficulty: map['difficulty']?.toString() ?? 'medium',
    );
  }
}
