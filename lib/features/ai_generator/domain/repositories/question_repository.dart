import '../../data/datasources/local_question_datasource.dart';
import '../../data/datasources/gemini_ai_service.dart';
import '../../../exam_engine/domain/models/question.dart';

class QuestionRepository {
  final LocalQuestionDatasource localDatasource;
  final GeminiAiService geminiService;

  QuestionRepository({
    required this.localDatasource,
    required this.geminiService,
  });

  Future<List<Question>> getOfflineQuestions(String examType) {
    return localDatasource.getQuestionsByExamType(examType);
  }

  Future<List<Question>> getOfflineQuestionsByCategory(String category) {
    return localDatasource.getQuestionsByCategory(category);
  }

  Future<List<Question>> getAllOfflineQuestions() {
    return localDatasource.getAllQuestions();
  }

  Future<List<Question>> generateAndSaveWithGemini({
    required String examType,
    required String subject,
    String difficulty = 'Medium',
    int count = 5,
  }) async {
    final questions = await geminiService.generateBilingualQuestions(
      examType: examType,
      subject: subject,
      difficulty: difficulty,
      count: count,
    );

    // Persist to SQLite for permanent offline practice
    await localDatasource.saveGeneratedQuestions(questions);

    return questions;
  }
}
