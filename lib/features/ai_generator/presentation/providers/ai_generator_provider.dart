import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../data/datasources/local_question_datasource.dart';
import '../../data/datasources/gemini_ai_service.dart';
import '../../domain/repositories/question_repository.dart';
import '../../../exam_engine/domain/models/question.dart';

final localDatasourceProvider = Provider<LocalQuestionDatasource>((ref) {
  return LocalQuestionDatasource(appDatabase: AppDatabase.instance);
});

class AiGauntletState {
  final bool isLoading;
  final String? errorMessage;
  final List<Question> generatedQuestions;
  final String apiKey;
  final String selectedExamType;
  final String selectedSubject;
  final String selectedDifficulty;
  final int selectedCount;

  const AiGauntletState({
    this.isLoading = false,
    this.errorMessage,
    this.generatedQuestions = const [],
    this.apiKey = '',
    this.selectedExamType = 'rrb_ntpc',
    this.selectedSubject = 'General Awareness & Indian Polity',
    this.selectedDifficulty = 'Medium',
    this.selectedCount = 5,
  });

  AiGauntletState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Question>? generatedQuestions,
    String? apiKey,
    String? selectedExamType,
    String? selectedSubject,
    String? selectedDifficulty,
    int? selectedCount,
  }) {
    return AiGauntletState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      generatedQuestions: generatedQuestions ?? this.generatedQuestions,
      apiKey: apiKey ?? this.apiKey,
      selectedExamType: selectedExamType ?? this.selectedExamType,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      selectedCount: selectedCount ?? this.selectedCount,
    );
  }
}

class AiGauntletNotifier extends Notifier<AiGauntletState> {
  @override
  AiGauntletState build() => const AiGauntletState();

  void setApiKey(String key) {
    state = state.copyWith(apiKey: key);
  }

  void setExamType(String examType) {
    state = state.copyWith(selectedExamType: examType);
  }

  void setSubject(String subject) {
    state = state.copyWith(selectedSubject: subject);
  }

  void setDifficulty(String difficulty) {
    state = state.copyWith(selectedDifficulty: difficulty);
  }

  void setCount(int count) {
    state = state.copyWith(selectedCount: count);
  }

  Future<void> generateQuestions({
    String? examType,
    String? subject,
    String? difficulty,
    int? count,
  }) async {
    final effectiveKey = state.apiKey.trim();
    final effectiveExam = examType ?? state.selectedExamType;
    final effectiveSubject = subject ?? state.selectedSubject;
    final effectiveDiff = difficulty ?? state.selectedDifficulty;
    final effectiveCount = count ?? state.selectedCount;

    if (effectiveKey.isEmpty) {
      state = state.copyWith(
        errorMessage:
            'Please supply a valid Gemini API Key to generate live questions, or use the offline question bank below.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final geminiService = GeminiAiService(apiKey: effectiveKey);
      final localDatasource = ref.read(localDatasourceProvider);
      final repo = QuestionRepository(
        localDatasource: localDatasource,
        geminiService: geminiService,
      );

      final questions = await repo.generateAndSaveWithGemini(
        examType: effectiveExam,
        subject: effectiveSubject,
        difficulty: effectiveDiff,
        count: effectiveCount,
      );

      state = state.copyWith(
        isLoading: false,
        generatedQuestions: questions,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> loadOfflineQuestions({
    String? examType,
    int? count,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final localDatasource = ref.read(localDatasourceProvider);
      final effectiveExam = examType ?? state.selectedExamType;
      final effectiveCount = count ?? state.selectedCount;

      final questions = await localDatasource.getQuestionsByExamType(effectiveExam);
      state = state.copyWith(
        isLoading: false,
        generatedQuestions: questions.take(effectiveCount).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load offline questions: $e',
      );
    }
  }
}

final aiGauntletProvider =
    NotifierProvider<AiGauntletNotifier, AiGauntletState>(AiGauntletNotifier.new);
