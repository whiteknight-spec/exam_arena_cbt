import 'package:flutter_test/flutter_test.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/user_progress.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/arena_level.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';
import 'package:exam_arena_cbt/features/ai_generator/data/seed/seed_questions.dart';
import 'package:exam_arena_cbt/core/utils/timer_formatter.dart';

void main() {
  group('Universal Indian Competitive Exam Domain Models', () {
    test('RRB NTPC specifications: 100 Qs, 90 mins, +1 / -0.33, 4 options, Bilingual', () {
      const exam = ExamType.rrbNtpc;
      expect(exam.totalQuestions, 100);
      expect(exam.totalDurationMinutes, 90);
      expect(exam.totalDurationSeconds, 5400);
      expect(exam.positiveMark, 1.0);
      expect(exam.negativeMark, 0.33);
      expect(exam.totalOptions, 4);
      expect(exam.hasOptionE, isFalse);
      expect(exam.hasSectionalLock, isFalse);
      expect(exam.supportsBilingual, isTrue);
      expect(exam.maximumMarks, 100.0);
    });

    test('SSC CGL Tier 1 specifications: 100 Qs, 60 mins with 15-min auto-locking sections, +2.0 / -0.50, 4 options', () {
      const exam = ExamType.sscCgl;
      expect(exam.totalQuestions, 100);
      expect(exam.totalDurationMinutes, 60);
      expect(exam.positiveMark, 2.0);
      expect(exam.negativeMark, 0.50);
      expect(exam.totalOptions, 4);
      expect(exam.hasOptionE, isFalse);
      expect(exam.hasSectionalLock, isTrue);
      expect(exam.sectionalLockDurationMinutes, 15);
      expect(exam.sectionalLockDurationSeconds, 900);
      expect(exam.maximumMarks, 200.0);
    });

    test('TNPSC Group 2 & Group 4 specifications: 200 Qs, 180 mins, +1.5 / 0 negative marking, 5 options A–E', () {
      const exam = ExamType.tnpscGroup2And4;
      expect(exam.totalQuestions, 200);
      expect(exam.totalDurationMinutes, 180);
      expect(exam.totalDurationSeconds, 10800);
      expect(exam.positiveMark, 1.5);
      expect(exam.negativeMark, 0.0); // No negative marking
      expect(exam.totalOptions, 5);
      expect(exam.hasOptionE, isTrue); // Option E: Answer Not Known
      expect(exam.supportsBilingual, isTrue);
      expect(exam.maximumMarks, 300.0);
    });

    test('IBPS / SBI Clerk specifications: 100 Qs, 60 mins with 20-min sectional lock, +1.0 / -0.25, 4 options', () {
      const exam = ExamType.ibpsSbiClerk;
      expect(exam.totalQuestions, 100);
      expect(exam.totalDurationMinutes, 60);
      expect(exam.totalDurationSeconds, 3600);
      expect(exam.positiveMark, 1.0);
      expect(exam.negativeMark, 0.25);
      expect(exam.totalOptions, 4);
      expect(exam.hasOptionE, isFalse);
      expect(exam.hasSectionalLock, isTrue);
      expect(exam.sectionalLockDurationMinutes, 20); // 20-min sectional lock
      expect(exam.sectionalLockDurationSeconds, 1200);
      expect(exam.maximumMarks, 100.0);
    });
  });

  group('UserProgress XP Calculation ((correct * 10) + accuracyBonus)', () {
    test('calculates correct base XP and tiered accuracy bonus', () {
      // 90%+ Accuracy bonus = +50
      final xp95 = UserProgress.calculateEarnedXp(correct: 10, accuracyPercentage: 95.0);
      expect(xp95, (10 * 10) + 50); // 150

      // 80%-89% Accuracy bonus = +35
      final xp85 = UserProgress.calculateEarnedXp(correct: 8, accuracyPercentage: 80.0);
      expect(xp85, (8 * 10) + 35); // 115

      // 70%-79% Accuracy bonus = +20
      final xp75 = UserProgress.calculateEarnedXp(correct: 7, accuracyPercentage: 70.0);
      expect(xp75, (7 * 10) + 20); // 90

      // 50%-69% Accuracy bonus = +10
      final xp60 = UserProgress.calculateEarnedXp(correct: 6, accuracyPercentage: 60.0);
      expect(xp60, (6 * 10) + 10); // 70

      // Under 50% Accuracy bonus = 0
      final xp40 = UserProgress.calculateEarnedXp(correct: 4, accuracyPercentage: 40.0);
      expect(xp40, (4 * 10) + 0); // 40
    });
  });

  group('500-XP Per Level Unlock Progression', () {
    test('Level unlocks sequentially at every 500 XP threshold', () {
      // Level 1: 0 - 499 XP
      const pLevel1 = UserProgress(xp: 250);
      expect(pLevel1.currentLevelNumber, 1);
      expect(pLevel1.nextLevelXp, 500);
      expect(pLevel1.xpRemainingToNextLevel, 250);
      expect(pLevel1.levelProgress, 0.5);
      expect(ArenaLevel.level1.isUnlocked(pLevel1.xp), isTrue);
      expect(ArenaLevel.level2.isUnlocked(pLevel1.xp), isFalse);

      // Level 2: 500 - 999 XP
      const pLevel2 = UserProgress(xp: 500);
      expect(pLevel2.currentLevelNumber, 2);
      expect(pLevel2.nextLevelXp, 1000);
      expect(pLevel2.xpInCurrentLevel, 0);
      expect(pLevel2.levelProgress, 0.0);
      expect(ArenaLevel.level2.isUnlocked(pLevel2.xp), isTrue);
      expect(ArenaLevel.level3.isUnlocked(pLevel2.xp), isFalse);

      // Level 3: 1000 - 1499 XP
      const pLevel3 = UserProgress(xp: 1250);
      expect(pLevel3.currentLevelNumber, 3);
      expect(pLevel3.nextLevelXp, 1500);
      expect(pLevel3.xpInCurrentLevel, 250);
      expect(pLevel3.levelProgress, 0.5);
      expect(ArenaLevel.level3.isUnlocked(pLevel3.xp), isTrue);
      expect(ArenaLevel.level4.isUnlocked(pLevel3.xp), isFalse);

      // Level 4: 1500+ XP (AI Gauntlet)
      const pLevel4 = UserProgress(xp: 1500);
      expect(pLevel4.currentLevelNumber, 4);
      expect(ArenaLevel.level4.isUnlocked(pLevel4.xp), isTrue);
      expect(pLevel4.rankTitle, 'AI Gauntlet Master');
    });
  });

  group('Daily Streak Tracking', () {
    test('advances streak on consecutive days', () {
      final day1 = DateTime(2026, 11, 1);
      final day2 = DateTime(2026, 11, 2);

      var progress = const UserProgress(xp: 0, streakDays: 0, lastActiveDate: null);
      progress = progress.recordSessionActivity(earnedXp: 100, testAccuracy: 80.0, activityDate: day1);
      expect(progress.streakDays, 1);

      progress = progress.recordSessionActivity(earnedXp: 100, testAccuracy: 85.0, activityDate: day2);
      expect(progress.streakDays, 2);
    });

    test('preserves streak when completing multiple sessions on the same calendar day', () {
      final morning = DateTime(2026, 11, 1, 9, 0);
      final evening = DateTime(2026, 11, 1, 19, 30);

      var progress = const UserProgress(xp: 100, streakDays: 5, lastActiveDate: null);
      progress = progress.recordSessionActivity(earnedXp: 50, testAccuracy: 90.0, activityDate: morning);
      expect(progress.streakDays, 1);

      progress = progress.recordSessionActivity(earnedXp: 50, testAccuracy: 90.0, activityDate: evening);
      expect(progress.streakDays, 1); // Preserves streak on same day
    });

    test('resets streak to 1 when a day is missed', () {
      final monday = DateTime(2026, 11, 1);
      final wednesday = DateTime(2026, 11, 3); // Missed Tuesday!

      var progress = const UserProgress(xp: 200, streakDays: 10, lastActiveDate: null);
      progress = progress.recordSessionActivity(earnedXp: 50, testAccuracy: 90.0, activityDate: monday);
      expect(progress.streakDays, 1);

      progress = progress.recordSessionActivity(earnedXp: 50, testAccuracy: 90.0, activityDate: wednesday);
      expect(progress.streakDays, 1); // Reset to 1 after gap
    });
  });

  group('Seed Questions Bank', () {
    test('Contains questions for RRB, SSC, TNPSC, and IBPS/SBI Clerk', () {
      final questions = SeedQuestions.getInitialQuestions();
      expect(questions.length, greaterThanOrEqualTo(8));

      final rrb = questions.where((q) => q.examType == 'rrb_ntpc');
      expect(rrb.isNotEmpty, isTrue);

      final ssc = questions.where((q) => q.examType == 'ssc_cgl');
      expect(ssc.isNotEmpty, isTrue);

      final tnpsc = questions.where((q) => q.examType == 'tnpsc_group_2_4');
      expect(tnpsc.isNotEmpty, isTrue);
      expect(tnpsc.first.hasOptionE, isTrue);
      expect(tnpsc.first.optionsEn.length, 5);

      final ibps = questions.where((q) => q.examType == 'ibps_sbi_clerk');
      expect(ibps.isNotEmpty, isTrue);
      expect(ibps.first.optionsEn.length, 4);
    });
  });

  group('Timer Formatter', () {
    test('formats seconds to MM:SS and HH:MM:SS accurately', () {
      expect(TimerFormatter.formatSeconds(900), '15:00');
      expect(TimerFormatter.formatSeconds(1200), '20:00');
      expect(TimerFormatter.formatSeconds(3600), '01:00:00');
      expect(TimerFormatter.formatSeconds(5400), '01:30:00');
      expect(TimerFormatter.formatSeconds(10800), '03:00:00');
    });
  });
}
