import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam_arena_cbt/core/constants/app_constants.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/user_progress.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/pyq_paper.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/streak_history_entry.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/exam_result.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/test_attempt_analytics.dart';

class ProgressionNotifier extends Notifier<UserProgress> {
  final AppDatabase _db = AppDatabase.instance;
  bool _hasLocalMutation = false;

  @override
  UserProgress build() {
    _loadFromDatabase();
    return const UserProgress();
  }

  Future<void> _loadFromDatabase() async {
    try {
      final isTesting = WidgetsBinding.instance.runtimeType.toString().contains('Test');
      if (isTesting && !_db.hasOpenDatabase) return;

      final savedProgress = await _db.getUserProgress();
      String? savedPyqId;
      try {
        savedPyqId = await _db.getSetting(AppConstants.settingSelectedPyqId);
      } catch (_) {}

      if (_hasLocalMutation) return;

      if (savedProgress != null) {
        state = savedProgress.copyWith(
          selectedPyqId: (savedPyqId != null && savedPyqId.isNotEmpty) ? savedPyqId : null,
        );
      } else {
        await _db.saveUserProgress(state);
      }
    } catch (_) {
      // In-memory or fallback mode
    }
  }

  Future<void> selectExam(ExamType exam) async {
    _hasLocalMutation = true;
    state = state.copyWith(selectedExam: exam, clearSelectedPyq: true);
    try {
      await _db.saveUserProgress(state);
      await _db.deleteSetting(AppConstants.settingSelectedPyqId);
    } catch (_) {}
  }

  Future<void> selectPyqPaper(PyqPaper paper) async {
    _hasLocalMutation = true;
    state = state.copyWith(
      selectedExam: paper.examType,
      selectedPyqId: paper.id,
    );
    try {
      await _db.saveUserProgress(state);
      await _db.setSetting(AppConstants.settingSelectedPyqId, paper.id);
    } catch (_) {}
  }

  Future<void> addXp(int points) async {
    _hasLocalMutation = true;
    state = state.copyWith(
      xp: state.xp + points,
      testsCompleted: state.testsCompleted + 1,
    );
    try {
      await _db.saveUserProgress(state);
    } catch (_) {}
  }

  Future<void> recordTestSession({
    required int earnedXp,
    required double accuracy,
    DateTime? activityDate,
    ExamResult? result,
    String? examType,
    int heartDelta = 0,
  }) async {
    _hasLocalMutation = true;
    final activityTime = activityDate ?? DateTime.now();
    var updated = state.recordSessionActivity(
      earnedXp: earnedXp,
      testAccuracy: accuracy,
      activityDate: activityTime,
    );
    if (heartDelta > 0) {
      for (int i = 0; i < heartDelta; i++) {
        updated = updated.healOneHeart();
      }
    } else if (heartDelta < 0) {
      for (int i = 0; i < -heartDelta; i++) {
        updated = updated.deductHeart();
      }
    }
    state = updated;

    try {
      // 1. Persist User XP, Unlocked Levels, and Streak to SQLite
      await _db.saveUserProgress(state);

      // 2. Persist Streak History Log Entry
      final streakEntry = StreakHistoryEntry(
        activityDate: activityTime,
        streakCount: state.streakDays,
        xpEarned: earnedXp,
        description: 'Completed CBT session for ${state.selectedExam.title}',
      );
      await _db.insertStreakEntry(streakEntry);

      // 3. Persist Detailed Test Attempt Analytics
      if (result != null) {
        final attempt = TestAttemptAnalytics.fromExamResult(
          id: 'attempt_${activityTime.millisecondsSinceEpoch}',
          examType: examType ?? state.selectedExam.id,
          timestamp: activityTime,
          result: result,
          earnedXp: earnedXp,
        );
        await _db.insertTestAttempt(attempt);
      }

      ref.invalidate(streakHistoryProvider);
      ref.invalidate(testAttemptsProvider);
    } catch (_) {}
  }

  Future<void> incrementStreak() async {
    _hasLocalMutation = true;
    state = state.copyWith(streakDays: state.streakDays + 1);
    try {
      await _db.saveUserProgress(state);
    } catch (_) {}
  }

  Future<void> deductHeart({String? reason}) async {
    _hasLocalMutation = true;
    state = state.deductHeart();
    try {
      await _db.saveUserProgress(state);
    } catch (_) {}
  }

  Future<bool> refillHeartsWithXp({int costXp = 50}) async {
    if (state.xp < costXp) return false;
    _hasLocalMutation = true;
    state = state.refillHeartsWithXp(costXp: costXp);
    try {
      await _db.saveUserProgress(state);
    } catch (_) {}
    return true;
  }

  Future<void> healOneHeart() async {
    _hasLocalMutation = true;
    state = state.healOneHeart();
    try {
      await _db.saveUserProgress(state);
    } catch (_) {}
  }

  Future<void> syncHearts() async {
    final updated = state.syncAutoRefill();
    if (updated != state) {
      _hasLocalMutation = true;
      state = updated;
      try {
        await _db.saveUserProgress(state);
      } catch (_) {}
    }
  }

  Future<List<StreakHistoryEntry>> getStreakHistory({int limit = 30}) {
    return _db.getStreakHistory(limit: limit);
  }

  Future<List<TestAttemptAnalytics>> getTestAttempts({int limit = 50}) {
    return _db.getTestAttempts(limit: limit);
  }
}

final progressionProvider =
    NotifierProvider<ProgressionNotifier, UserProgress>(ProgressionNotifier.new);

final streakHistoryProvider = FutureProvider<List<StreakHistoryEntry>>((ref) async {
  return AppDatabase.instance.getStreakHistory();
});

final testAttemptsProvider = FutureProvider<List<TestAttemptAnalytics>>((ref) async {
  return AppDatabase.instance.getTestAttempts();
});
