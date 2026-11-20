import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../exam_engine/domain/models/question.dart';

class GeminiAiService {
  final String? apiKey;

  GeminiAiService({this.apiKey});

  Future<List<Question>> generateBilingualQuestions({
    required String examType,
    required String subject,
    String difficulty = 'Medium',
    int count = 5,
  }) async {
    final key = apiKey;
    if (key == null || key.trim().isEmpty) {
      throw Exception(
        'Gemini API key is not configured. Please supply your API key or load from the offline question bank.',
      );
    }

    // Defensive Security: Clamp count and sanitize subject to prevent quota exhaustion and prompt injection
    final sanitizedCount = count.clamp(1, 20);
    final cleanSubject = subject
        .replaceAll(RegExp(r'[\r\n\t]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final sanitizedSubject = cleanSubject.length > 100 ? cleanSubject.substring(0, 100) : cleanSubject;

    final cleanExamType = examType
        .replaceAll(RegExp(r'[\r\n\t]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final sanitizedExamType = cleanExamType.length > 50 ? cleanExamType.substring(0, 50) : cleanExamType;

    final cleanDifficulty = difficulty.trim().toLowerCase();
    final sanitizedDifficulty = ['easy', 'medium', 'hard'].contains(cleanDifficulty)
        ? cleanDifficulty
        : 'medium';

    final model = GenerativeModel(
      model: AppConstants.geminiModel,
      apiKey: key.trim(),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.7,
      ),
    );

    final isTnpsc = sanitizedExamType.toLowerCase().contains('tnpsc');

    final prompt = '''
You are an expert exam question generator for Indian Competitive Exams ($sanitizedExamType).
Generate $sanitizedCount high-yield multiple-choice questions for subject/topic "$sanitizedSubject" with difficulty level "$sanitizedDifficulty".
Every question MUST be completely bilingual (both English and Tamil) with detailed explanations in BOTH languages.

Requirements:
- question_en: Clear question in English.
- question_ta: Accurate, natural academic question in Tamil.
- options_en: Array of 4 strings (Options A, B, C, D). ${isTnpsc ? 'For TNPSC exams, provide a 5th option "Option E: Answer Not Known (விடை தெரியவில்லை)".' : ''}
- options_ta: Parallel array of 4 strings in Tamil. ${isTnpsc ? 'For TNPSC exams, provide a 5th option "Option E: விடை தெரியவில்லை".' : ''}
- correct_index: 0 for A, 1 for B, 2 for C, 3 for D.
- explanation_en: Step-by-step reasoning and rationale in English.
- explanation_ta: Step-by-step reasoning and rationale in Tamil.
- has_option_e: ${isTnpsc ? true : false}.
- category: "$sanitizedSubject".
- difficulty: "$sanitizedDifficulty".

Return ONLY a valid JSON array matching this structure:
[
  {
    "id": "gemini_${DateTime.now().millisecondsSinceEpoch}_1",
    "subject": "$sanitizedSubject",
    "exam_type": "$sanitizedExamType",
    "category": "$sanitizedSubject",
    "question_en": "Question text in English",
    "question_ta": "தமிழில் வினா",
    "options_en": ["Opt A", "Opt B", "Opt C", "Opt D"${isTnpsc ? ', "Option E: Answer Not Known (விடை தெரியவில்லை)"' : ''}],
    "options_ta": ["ஆப்ஷன் A", "ஆப்ஷன் B", "ஆப்ஷன் C", "ஆப்ஷன் D"${isTnpsc ? ', "Option E: விடை தெரியவில்லை"' : ''}],
    "correct_index": 0,
    "explanation_en": "Detailed rationale in English",
    "explanation_ta": "தமிழில் விரிவான விளக்கம்",
    "has_option_e": ${isTnpsc ? true : false},
    "difficulty": "$sanitizedDifficulty"
  }
]
''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    final responseText = response.text;

    if (responseText == null || responseText.trim().isEmpty) {
      throw Exception('Empty response received from Gemini 2.5 Flash.');
    }

    try {
      final List<dynamic> decoded = jsonDecode(responseText);
      return decoded.map((item) {
        final map = item as Map<String, dynamic>;
        return Question.fromMap(map);
      }).toList();
    } catch (e) {
      throw Exception('Failed to parse Gemini output: $e\nResponse was: $responseText');
    }
  }
}
