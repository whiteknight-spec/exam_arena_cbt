import 'dart:convert';
import 'exam_type.dart';
import 'pubg_tier.dart';

class UserProgress {
  final int xp;
  final int streakDays;
  final DateTime? lastActiveDate;
  final ExamType selectedExam;
  final int testsCompleted;
  final double averageAccuracy;
  final List<int>? customUnlockedLevels;
  final int hearts;
  final DateTime? lastHeartRefillTime;

  const UserProgress({
    this.xp = 350,
    this.streakDays = 7,
    this.lastActiveDate,
    this.selectedExam = ExamType.rrbNtpc,
    this.testsCompleted = 12,
    this.averageAccuracy = 82.5,
    this.customUnlockedLevels,
    this.hearts = 5,
    this.lastHeartRefillTime,
  });

  // 500-XP per level unlock progression rule
  static const int xpPerLevel = 500;
  static const int maxHearts = 5;
  static const int heartRegenMinutes = 120; // 2 hours recovery per heart

  PubgSubTier get pubgSubTier => PubgSubTier.fromXp(xp);
  PubgTier get pubgTier => pubgSubTier.tier;

  int get currentHearts {
    if (hearts >= maxHearts) return maxHearts;
    final refillTime = lastHeartRefillTime;
    if (refillTime == null) return hearts;
    final elapsedMinutes = DateTime.now().difference(refillTime).inMinutes;
    if (elapsedMinutes <= 0) return hearts;
    final regenerated = elapsedMinutes ~/ heartRegenMinutes;
    return (hearts + regenerated).clamp(0, maxHearts);
  }

  Duration get timeUntilNextHeart {
    if (currentHearts >= maxHearts) return Duration.zero;
    final refillTime = lastHeartRefillTime ?? DateTime.now();
    final elapsedSeconds = DateTime.now().difference(refillTime).inSeconds;
    final totalCycleSeconds = heartRegenMinutes * 60; // 7200 seconds (2 hours)
    final secondsIntoCycle = elapsedSeconds % totalCycleSeconds;
    final secondsRemaining = totalCycleSeconds - secondsIntoCycle;
    return Duration(seconds: secondsRemaining);
  }

  /// Progressive recovery fill factor (0.0 to 1.0) strictly parallel to the 2-hour recovery time.
  /// When stamina is full (5/5), returns 1.0.
  /// If 30 mins elapsed out of 120 mins: returns 0.25 (25%).
  /// If 60 mins elapsed out of 120 mins: returns 0.50 (50%).
  /// If 90 mins elapsed out of 120 mins: returns 0.75 (75%).
  double get recoveringHeartProgress {
    if (currentHearts >= maxHearts) return 1.0;
    final refillTime = lastHeartRefillTime;
    if (refillTime == null) return 0.0;
    final elapsedSeconds = DateTime.now().difference(refillTime).inSeconds;
    if (elapsedSeconds <= 0) return 0.0;
    final totalCycleSeconds = heartRegenMinutes * 60; // 7200 seconds (2 hours)
    final secondsIntoCycle = elapsedSeconds % totalCycleSeconds;
    final progress = secondsIntoCycle / totalCycleSeconds;
    return progress.clamp(0.0, 1.0);
  }

  UserProgress deductHeart() {
    final cur = currentHearts;
    final newHearts = (cur - 1).clamp(0, maxHearts);
    final now = DateTime.now();
    final newRefillTime = (cur >= maxHearts) ? now : (lastHeartRefillTime ?? now);
    return copyWith(
      hearts: newHearts,
      lastHeartRefillTime: newRefillTime,
    );
  }

  UserProgress refillHeartsWithXp({int costXp = 50}) {
    if (xp < costXp) return this;
    return copyWith(
      hearts: maxHearts,
      xp: xp - costXp,
      lastHeartRefillTime: null,
    );
  }

  UserProgress healOneHeart() {
    final cur = currentHearts;
    final next = (cur + 1).clamp(0, maxHearts);
    return copyWith(
      hearts: next,
      lastHeartRefillTime: next >= maxHearts ? null : lastHeartRefillTime,
    );
  }

  UserProgress syncAutoRefill() {
    final computed = currentHearts;
    if (computed != hearts) {
      return copyWith(
        hearts: computed,
        lastHeartRefillTime: computed >= maxHearts ? null : lastHeartRefillTime,
      );
    }
    return this;
  }

  int get currentLevelNumber => (xp ~/ xpPerLevel) + 1;

  int get currentLevelBaseXp => (currentLevelNumber - 1) * xpPerLevel;

  int get nextLevelXp => currentLevelNumber * xpPerLevel;

  int get xpInCurrentLevel => xp - currentLevelBaseXp;

  int get xpRemainingToNextLevel => nextLevelXp - xp;

  double get levelProgress {
    final progress = xpInCurrentLevel / xpPerLevel;
    return progress.clamp(0.0, 1.0);
  }

  bool isLevelUnlocked(int levelNumber) {
    if (xp >= (levelNumber - 1) * xpPerLevel) return true;
    if (customUnlockedLevels != null && customUnlockedLevels!.contains(levelNumber)) {
      return true;
    }
    return false;
  }

  List<int> get unlockedLevels {
    final unlocked = <int>{};
    for (int lvl = 1; lvl <= currentLevelNumber; lvl++) {
      unlocked.add(lvl);
    }
    if (customUnlockedLevels != null) {
      unlocked.addAll(customUnlockedLevels!);
    }
    final sorted = unlocked.toList()..sort();
    return sorted;
  }

  String get rankTitle {
    switch (currentLevelNumber) {
      case 1:
        return 'Topic Aspirant';
      case 2:
        return 'Sectional Specialist';
      case 3:
        return 'Mock Veteran';
      case 4:
        return 'AI Gauntlet Master';
      default:
        return 'Arena Legend (Lvl $currentLevelNumber)';
    }
  }

  /// Calculates accuracy bonus:
  /// - 90%+ Accuracy: +50 XP
  /// - 80%–89% Accuracy: +35 XP
  /// - 70%–79% Accuracy: +20 XP
  /// - 50%–69% Accuracy: +10 XP
  static int calculateAccuracyBonus(double accuracyPercentage) {
    if (accuracyPercentage >= 90.0) return 50;
    if (accuracyPercentage >= 80.0) return 35;
    if (accuracyPercentage >= 70.0) return 20;
    if (accuracyPercentage >= 50.0) return 10;
    return 0;
  }

  /// XP Formula: ((correct * 10) + accuracyBonus)
  static int calculateEarnedXp({
    required int correct,
    required double accuracyPercentage,
  }) {
    final baseScore = correct * 10;
    final accuracyBonus = calculateAccuracyBonus(accuracyPercentage);
    return baseScore + accuracyBonus;
  }

  /// Updates daily streak, XP, test count, and average accuracy.
  UserProgress recordSessionActivity({
    required int earnedXp,
    required double testAccuracy,
    DateTime? activityDate,
  }) {
    final today = activityDate ?? DateTime.now();
    int updatedStreak = streakDays;

    if (lastActiveDate == null) {
      updatedStreak = 1;
    } else {
      final lastDate = DateTime(lastActiveDate!.year, lastActiveDate!.month, lastActiveDate!.day);
      final currentDate = DateTime(today.year, today.month, today.day);
      final diffDays = currentDate.difference(lastDate).inDays;

      if (diffDays == 1) {
        // Consecutive calendar day -> advance streak
        updatedStreak = streakDays + 1;
      } else if (diffDays > 1) {
        // Broken streak -> reset to day 1
        updatedStreak = 1;
      }
      // diffDays == 0: already practiced today -> preserve current streak
    }

    final newTestsCount = testsCompleted + 1;
    final newAvgAccuracy = ((averageAccuracy * testsCompleted) + testAccuracy) / newTestsCount;

    return copyWith(
      xp: xp + earnedXp,
      streakDays: updatedStreak,
      lastActiveDate: today,
      testsCompleted: newTestsCount,
      averageAccuracy: double.parse(newAvgAccuracy.toStringAsFixed(1)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 'current_user',
      'xp': xp,
      'streak_days': streakDays,
      'last_active_date': lastActiveDate?.toIso8601String(),
      'selected_exam': selectedExam.id,
      'tests_completed': testsCompleted,
      'average_accuracy': averageAccuracy,
      'unlocked_levels': jsonEncode(unlockedLevels),
      'hearts': currentHearts,
      'last_heart_refill': lastHeartRefillTime?.toIso8601String(),
    };
  }

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    DateTime? lastActive;
    if (map['last_active_date'] != null) {
      lastActive = DateTime.tryParse(map['last_active_date'].toString());
    }

    DateTime? lastRefill;
    if (map['last_heart_refill'] != null) {
      lastRefill = DateTime.tryParse(map['last_heart_refill'].toString());
    }

    final examId = map['selected_exam']?.toString() ?? 'rrb_ntpc';
    final exam = ExamType.values.firstWhere(
      (e) => e.id == examId,
      orElse: () => ExamType.rrbNtpc,
    );

    List<int>? levels;
    if (map['unlocked_levels'] != null) {
      try {
        final decoded = jsonDecode(map['unlocked_levels'].toString());
        if (decoded is List) {
          levels = decoded.map((e) => int.tryParse(e.toString()) ?? 1).toList();
        }
      } catch (_) {}
    }

    return UserProgress(
      xp: (map['xp'] as num?)?.toInt() ?? 350,
      streakDays: (map['streak_days'] as num?)?.toInt() ?? 7,
      lastActiveDate: lastActive,
      selectedExam: exam,
      testsCompleted: (map['tests_completed'] as num?)?.toInt() ?? 12,
      averageAccuracy: (map['average_accuracy'] as num?)?.toDouble() ?? 82.5,
      customUnlockedLevels: levels,
      hearts: (map['hearts'] as num?)?.toInt() ?? 5,
      lastHeartRefillTime: lastRefill,
    );
  }

  UserProgress copyWith({
    int? xp,
    int? streakDays,
    DateTime? lastActiveDate,
    ExamType? selectedExam,
    int? testsCompleted,
    double? averageAccuracy,
    List<int>? customUnlockedLevels,
    int? hearts,
    DateTime? lastHeartRefillTime,
  }) {
    return UserProgress(
      xp: xp ?? this.xp,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      selectedExam: selectedExam ?? this.selectedExam,
      testsCompleted: testsCompleted ?? this.testsCompleted,
      averageAccuracy: averageAccuracy ?? this.averageAccuracy,
      customUnlockedLevels: customUnlockedLevels ?? this.customUnlockedLevels,
      hearts: hearts ?? this.hearts,
      lastHeartRefillTime: lastHeartRefillTime ?? this.lastHeartRefillTime,
    );
  }
}
