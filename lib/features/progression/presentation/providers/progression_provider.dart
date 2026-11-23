import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/user_progress.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/streak_history_entry.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/exam_result.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/test_attempt_analytics.dart';

class ProgressionNotifier extends Notifier<UserProgress> {
  final AppDatabase _db = AppDatabase.instance;

  @override
  UserProgress build() {
    _loadFromDatabase();
    return const UserProgress();
  }

  Future<void> _loadFromDatabase() async {
    try {
      final savedProgress = await _db.getUserProgress();
      if (savedProgress != null) {
        if (savedProgress.xp == 350 && savedProgress.testsCompleted == 12 && savedProgress.streakDays == 7) {
          const fresh = UserProgress();
          state = fresh;
          await _db.saveUserProgress(fresh);
        } else {
          state = savedProgress;
        }
      } else {
        // Initialize default clean user progress in SQLite if not yet persisted
        await _db.saveUserProgress(state);
      }
    } catch (_) {
      // In-memory or fallback mode
    }
  }

  Future<void> selectExam(ExamType exam) async {
    state = state.copyWith(selectedExam: exam);
    try {
      await _db.saveUserProgress(state);
    } catch (_) {}
  }

  Future<void> addXp(int points) async {
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
  }) async {
    final activityTime = activityDate ?? DateTime.now();
    state = state.recordSessionActivity(
      earnedXp: earnedXp,
      testAccuracy: accuracy,
      activityDate: activityTime,
    );

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
    } catch (_) {}
  }

  Future<void> incrementStreak() async {
    state = state.copyWith(streakDays: state.streakDays + 1);
    try {
      await _db.saveUserProgress(state);
    } catch (_) {}
  }

  Future<void> deductHeart({String? reason}) async {
    state = state.deductHeart();
    try {
      await _db.saveUserProgress(state);
    } catch (_) {}
  }

  Future<bool> refillHeartsWithXp({int costXp = 50}) async {
    if (state.xp < costXp) return false;
    state = state.refillHeartsWithXp(costXp: costXp);
    try {
      await _db.saveUserProgress(state);
    } catch (_) {}
    return true;
  }

  Future<void> healOneHeart() async {
    state = state.healOneHeart();
    try {
      await _db.saveUserProgress(state);
    } catch (_) {}
  }

  Future<void> syncHearts() async {
    final updated = state.syncAutoRefill();
    if (updated != state) {
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
