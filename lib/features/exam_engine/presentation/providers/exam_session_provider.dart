import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/question.dart';
import '../../domain/models/question_status.dart';
import '../../domain/models/section.dart';
import '../../domain/models/exam_result.dart';
import '../../../progression/domain/models/exam_type.dart';

class ExamSessionState {
  final List<Question> questions;
  final int currentIndex;
  final Map<int, int?> userSelections; // questionIndex -> optionIndex (0..4)
  final Map<int, QuestionStatus> statuses;
  final bool isTamil;
  final int remainingSeconds;
  final int totalDurationSeconds;
  final int sectionalRemainingSeconds;
  final bool hasSectionalLock;
  final List<ExamSection> sections;
  final int currentSectionIndex;
  final ExamType examType;
  final bool isSubmitted;
  final ExamResult? result;

  const ExamSessionState({
    required this.questions,
    this.currentIndex = 0,
    required this.userSelections,
    required this.statuses,
    this.isTamil = false,
    required this.remainingSeconds,
    required this.totalDurationSeconds,
    this.sectionalRemainingSeconds = 0,
    this.hasSectionalLock = false,
    required this.sections,
    this.currentSectionIndex = 0,
    required this.examType,
    this.isSubmitted = false,
    this.result,
  });

  Question get currentQuestion => questions[currentIndex];

  int? get currentSelection => userSelections[currentIndex];

  QuestionStatus get currentStatus =>
      statuses[currentIndex] ?? QuestionStatus.notVisited;

  ExamSection? get currentSection =>
      (sections.isNotEmpty &&
              currentSectionIndex >= 0 &&
              currentSectionIndex < sections.length)
          ? sections[currentSectionIndex]
          : null;

  bool get isMultiSectionLocked => hasSectionalLock && sections.length > 1;

  bool isQuestionAccessible(int index) {
    if (index < 0 || index >= questions.length) return false;
    if (!isMultiSectionLocked) return true;
    final sec = currentSection;
    if (sec == null) return true;
    return sec.questionIndices.contains(index);
  }

  int? get previousQuestionInSection {
    if (!isMultiSectionLocked) {
      return currentIndex > 0 ? currentIndex - 1 : null;
    }
    final indices = currentSection?.questionIndices ?? const [];
    final pos = indices.indexOf(currentIndex);
    if (pos > 0) return indices[pos - 1];
    return null;
  }

  int? get nextQuestionInSection {
    if (!isMultiSectionLocked) {
      return currentIndex + 1 < questions.length ? currentIndex + 1 : null;
    }
    final indices = currentSection?.questionIndices ?? const [];
    final pos = indices.indexOf(currentIndex);
    if (pos >= 0 && pos + 1 < indices.length) return indices[pos + 1];
    return null;
  }

  ExamSessionState copyWith({
    List<Question>? questions,
    int? currentIndex,
    Map<int, int?>? userSelections,
    Map<int, QuestionStatus>? statuses,
    bool? isTamil,
    int? remainingSeconds,
    int? totalDurationSeconds,
    int? sectionalRemainingSeconds,
    bool? hasSectionalLock,
    List<ExamSection>? sections,
    int? currentSectionIndex,
    ExamType? examType,
    bool? isSubmitted,
    ExamResult? result,
  }) {
    return ExamSessionState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      userSelections: userSelections ?? this.userSelections,
      statuses: statuses ?? this.statuses,
      isTamil: isTamil ?? this.isTamil,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      sectionalRemainingSeconds:
          sectionalRemainingSeconds ?? this.sectionalRemainingSeconds,
      hasSectionalLock: hasSectionalLock ?? this.hasSectionalLock,
      sections: sections ?? this.sections,
      currentSectionIndex: currentSectionIndex ?? this.currentSectionIndex,
      examType: examType ?? this.examType,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      result: result ?? this.result,
    );
  }
}

class ExamSessionNotifier extends Notifier<ExamSessionState?> {
  Timer? _timer;

  @override
  ExamSessionState? build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return null;
  }

  void startSession(ExamSessionState initialState) {
    _timer?.cancel();
    state = initialState;
    _markCurrentAsVisited();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      tickOneSecond();
    });
  }

  @visibleForTesting
  void tickOneSecond() {
    final current = state;
    if (current == null || current.isSubmitted) {
      _timer?.cancel();
      return;
    }

    final nextOverallSeconds = current.remainingSeconds - 1;
    if (nextOverallSeconds <= 0) {
      state = current.copyWith(remainingSeconds: 0);
      submitExam();
      return;
    }

    if (current.hasSectionalLock) {
      final nextSectionalSeconds = current.sectionalRemainingSeconds - 1;
      if (nextSectionalSeconds <= 0) {
        // Lock current section and auto-advance to next section, or submit on final section expiry
        if (current.currentSectionIndex + 1 < current.sections.length) {
          final updatedSections = List<ExamSection>.from(current.sections);
          updatedSections[current.currentSectionIndex] =
              updatedSections[current.currentSectionIndex].copyWith(isLocked: true);

          final nextSectionIndex = current.currentSectionIndex + 1;
          final nextSection = updatedSections[nextSectionIndex].copyWith(isLocked: false);
          updatedSections[nextSectionIndex] = nextSection;

          final nextQuestionIndex = nextSection.questionIndices.isNotEmpty
              ? nextSection.questionIndices.first
              : current.currentIndex;
          final nextSectionTimer = nextSection.allottedSeconds <= nextOverallSeconds
              ? nextSection.allottedSeconds
              : nextOverallSeconds;

          state = current.copyWith(
            remainingSeconds: nextOverallSeconds,
            sectionalRemainingSeconds: nextSectionTimer,
            sections: updatedSections,
            currentSectionIndex: nextSectionIndex,
            currentIndex: nextQuestionIndex,
          );
          _markCurrentAsVisited();
          return;
        } else {
          // Final section expired -> auto-submit exam
          state = current.copyWith(
            remainingSeconds: nextOverallSeconds,
            sectionalRemainingSeconds: 0,
          );
          submitExam();
          return;
        }
      }

      state = current.copyWith(
        remainingSeconds: nextOverallSeconds,
        sectionalRemainingSeconds: nextSectionalSeconds,
      );
      return;
    }

    state = current.copyWith(remainingSeconds: nextOverallSeconds);
  }

  void _markCurrentAsVisited() {
    final cur = state;
    if (cur == null) return;

    final curStatus = cur.statuses[cur.currentIndex];
    if (curStatus == null || curStatus == QuestionStatus.notVisited) {
      final updated = Map<int, QuestionStatus>.from(cur.statuses);
      updated[cur.currentIndex] = QuestionStatus.notAnswered;
      state = cur.copyWith(statuses: updated);
    }
  }

  void toggleLanguage() {
    final cur = state;
    if (cur == null) return;
    state = cur.copyWith(isTamil: !cur.isTamil);
  }

  void selectOption(int optionIndex) {
    final cur = state;
    if (cur == null || cur.isSubmitted) return;
    final optionsCount = cur.currentQuestion.optionsEn.length;
    if (optionIndex < 0 || (optionsCount > 0 && optionIndex >= optionsCount)) {
      return;
    }

    final updated = Map<int, int?>.from(cur.userSelections);
    updated[cur.currentIndex] = optionIndex;
    state = cur.copyWith(userSelections: updated);
  }

  void clearResponse() {
    final cur = state;
    if (cur == null || cur.isSubmitted) return;

    final updatedSelections = Map<int, int?>.from(cur.userSelections);
    updatedSelections.remove(cur.currentIndex);

    final updatedStatuses = Map<int, QuestionStatus>.from(cur.statuses);
    updatedStatuses[cur.currentIndex] = QuestionStatus.notAnswered;

    state = cur.copyWith(
      userSelections: updatedSelections,
      statuses: updatedStatuses,
    );
  }

  void saveAndNext() {
    final cur = state;
    if (cur == null || cur.isSubmitted) return;

    final hasSelected = cur.userSelections[cur.currentIndex] != null;
    final updatedStatuses = Map<int, QuestionStatus>.from(cur.statuses);
    updatedStatuses[cur.currentIndex] =
        hasSelected ? QuestionStatus.answered : QuestionStatus.notAnswered;

    final nextIndex = cur.nextQuestionInSection ?? cur.currentIndex;

    state = cur.copyWith(
      statuses: updatedStatuses,
      currentIndex: nextIndex,
    );
    _markCurrentAsVisited();
  }

  void markForReviewAndNext() {
    final cur = state;
    if (cur == null || cur.isSubmitted) return;

    final hasSelected = cur.userSelections[cur.currentIndex] != null;
    final updatedStatuses = Map<int, QuestionStatus>.from(cur.statuses);
    updatedStatuses[cur.currentIndex] =
        hasSelected ? QuestionStatus.answeredReview : QuestionStatus.review;

    final nextIndex = cur.nextQuestionInSection ?? cur.currentIndex;

    state = cur.copyWith(
      statuses: updatedStatuses,
      currentIndex: nextIndex,
    );
    _markCurrentAsVisited();
  }

  void jumpToQuestion(int index) {
    final cur = state;
    if (cur == null || cur.isSubmitted) return;

    if (cur.isQuestionAccessible(index)) {
      state = cur.copyWith(currentIndex: index);
      _markCurrentAsVisited();
    }
  }

  void submitExam() {
    _timer?.cancel();
    final cur = state;
    if (cur == null || cur.isSubmitted) return;

    int correct = 0;
    int incorrect = 0;
    int optionESelected = 0;
    int attempted = 0;

    for (int i = 0; i < cur.questions.length; i++) {
      final q = cur.questions[i];
      final sel = cur.userSelections[i];

      if (sel != null) {
        attempted++;
        // TNPSC 5th option (Option E index 4: "விடை தெரியவில்லை")
        if (q.hasOptionE && sel == 4) {
          optionESelected++;
        } else if (sel == q.correctIndex) {
          correct++;
        } else {
          incorrect++;
        }
      }
    }

    final unattempted = cur.questions.length - attempted;
    final positiveEarned = correct * cur.examType.positiveMark;
    final negativeDeducted = incorrect * cur.examType.negativeMark;
    final netScore =
        double.parse((positiveEarned - negativeDeducted).toStringAsFixed(2));
    final maxMarks = cur.questions.length * cur.examType.positiveMark;
    final timeSpent =
        (cur.totalDurationSeconds - cur.remainingSeconds).clamp(0, cur.totalDurationSeconds);

    final result = ExamResult(
      totalQuestions: cur.questions.length,
      attempted: attempted,
      correct: correct,
      incorrect: incorrect,
      optionESelected: optionESelected,
      unattempted: unattempted,
      positiveMarksEarned: positiveEarned,
      negativeMarksDeducted: negativeDeducted,
      netScore: netScore,
      maximumMarks: maxMarks,
      timeSpentSeconds: timeSpent,
    );

    state = cur.copyWith(
      isSubmitted: true,
      result: result,
    );
  }
}

final examSessionProvider =
    NotifierProvider<ExamSessionNotifier, ExamSessionState?>(ExamSessionNotifier.new);
