import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/user_progress.dart';

void main() {
  group('Defensive Security Hardening - Android Manifest Checks', () {
    test('AndroidManifest.xml restricts ADB backup and cleartext traffic', () {
      final manifestFile = File('android/app/src/main/AndroidManifest.xml');
      expect(manifestFile.existsSync(), isTrue, reason: 'AndroidManifest.xml should exist');

      final content = manifestFile.readAsStringSync();

      // Check ADB backup is disabled to prevent database extraction
      expect(
        content.contains('android:allowBackup="false"'),
        isTrue,
        reason: 'allowBackup="false" must be set to prevent adb backup database theft',
      );

      // Check full backup content is disabled
      expect(
        content.contains('android:fullBackupContent="false"'),
        isTrue,
        reason: 'fullBackupContent="false" must be set to prevent cloud backup leakage',
      );

      // Check cleartext traffic is disabled to enforce TLS/HTTPS
      expect(
        content.contains('android:usesCleartextTraffic="false"'),
        isTrue,
        reason: 'usesCleartextTraffic="false" must be set to mitigate MitM sniffing',
      );
    });
  });

  group('Defensive Security Hardening - Client-Side State Anti-Tampering', () {
    test('UserProgress.fromMap clamps negative and absurdly high XP', () {
      final negativeXpMap = {
        'id': 'current_user',
        'xp': -500,
        'hearts': 3,
      };
      final sanitizedNeg = UserProgress.fromMap(negativeXpMap);
      expect(sanitizedNeg.xp, 0);

      final massiveXpMap = {
        'id': 'current_user',
        'xp': 999999999,
        'hearts': 3,
      };
      final sanitizedMax = UserProgress.fromMap(massiveXpMap);
      expect(sanitizedMax.xp, 9999999);
    });

    test('UserProgress.fromMap clamps hearts to valid range [0, 5]', () {
      final overHeartsMap = {
        'id': 'current_user',
        'xp': 100,
        'hearts': 99,
      };
      final sanitizedOver = UserProgress.fromMap(overHeartsMap);
      expect(sanitizedOver.hearts, UserProgress.maxHearts);

      final negHeartsMap = {
        'id': 'current_user',
        'xp': 100,
        'hearts': -10,
      };
      final sanitizedNeg = UserProgress.fromMap(negHeartsMap);
      expect(sanitizedNeg.hearts, 0);
    });

    test('UserProgress.fromMap clamps streak days and average accuracy', () {
      final tamperedMap = {
        'id': 'current_user',
        'streak_days': -5,
        'average_accuracy': 150.0,
      };
      final sanitized = UserProgress.fromMap(tamperedMap);
      expect(sanitized.streakDays, 0);
      expect(sanitized.averageAccuracy, 100.0);

      final negAccuracyMap = {
        'id': 'current_user',
        'average_accuracy': -25.0,
      };
      final sanitizedNegAcc = UserProgress.fromMap(negAccuracyMap);
      expect(sanitizedNegAcc.averageAccuracy, 0.0);
    });

    test('UserProgress.fromMap sanitizes custom unlocked levels', () {
      final tamperedLevelsMap = {
        'id': 'current_user',
        'unlocked_levels': '[-10, 0, 1, 2, 9999, "invalid"]',
      };
      final sanitized = UserProgress.fromMap(tamperedLevelsMap);
      expect(sanitized.customUnlockedLevels, containsAll([1, 2]));
      expect(sanitized.customUnlockedLevels?.contains(-10), isFalse);
      expect(sanitized.customUnlockedLevels?.contains(0), isFalse);
      expect(sanitized.customUnlockedLevels?.contains(9999), isFalse);
    });
  });

  group('Defensive Security Hardening - System Clock Tampering Protection', () {
    test('Future timestamp for lastHeartRefillTime is sanitized in fromMap', () {
      final farFutureTime = DateTime.now().add(const Duration(days: 5));
      final futureMap = {
        'id': 'current_user',
        'hearts': 1,
        'last_heart_refill': farFutureTime.toIso8601String(),
      };

      final progress = UserProgress.fromMap(futureMap);
      // The future refill time should be clamped to current time (not left 5 days in future)
      expect(
        progress.lastHeartRefillTime!.isBefore(DateTime.now().add(const Duration(seconds: 10))),
        isTrue,
      );
    });

    test('currentHearts does not yield unearned hearts if refill time is in future', () {
      final progress = UserProgress(
        hearts: 2,
        lastHeartRefillTime: DateTime.now().add(const Duration(hours: 10)),
      );

      // Should return current hearts (2), not give instant refills or negative numbers
      expect(progress.currentHearts, 2);
    });

    test('timeUntilNextHeart and recoveringHeartProgress handle future timestamps safely', () {
      final progress = UserProgress(
        hearts: 2,
        lastHeartRefillTime: DateTime.now().add(const Duration(hours: 2)),
      );

      // timeUntilNextHeart should not be negative
      expect(progress.timeUntilNextHeart.isNegative, isFalse);
      expect(progress.timeUntilNextHeart.inMinutes, greaterThanOrEqualTo(0));

      // recoveringHeartProgress should be 0.0, not negative
      expect(progress.recoveringHeartProgress, 0.0);
    });
  });
}
