import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/screens/cbt_exam_screen.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/widgets/exit_guard_dialog.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/user_progress.dart';
import 'package:exam_arena_cbt/features/progression/presentation/providers/progression_provider.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/hearts_badge.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/hearts_refill_modal.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    await AppDatabase.createInMemoryDatabase();
  });

  group('UserProgress Hearts & Life Mechanics (2-Hour Recovery)', () {
    test('starts with full 5 hearts by default', () {
      const progress = UserProgress();
      expect(progress.hearts, 5);
      expect(progress.currentHearts, 5);
      expect(progress.timeUntilNextHeart, Duration.zero);
      expect(progress.recoveringHeartProgress, 1.0);
    });

    test('deductHeart decrements hearts and records refill timer for 2 hours', () {
      const progress = UserProgress(hearts: 5);
      final lostOne = progress.deductHeart();

      expect(lostOne.hearts, 4);
      expect(lostOne.currentHearts, 4);
      expect(lostOne.lastHeartRefillTime, isNotNull);
      expect(lostOne.timeUntilNextHeart.inMinutes, inInclusiveRange(1, 120));
      expect(lostOne.recoveringHeartProgress, inInclusiveRange(0.0, 1.0));
    });

    test('recoveringHeartProgress loads strictly parallel to elapsed recovery time', () {
      final now = DateTime.now();
      // 0 minutes elapsed -> 0.0 fill
      final p0 = UserProgress(hearts: 4, lastHeartRefillTime: now);
      expect(p0.recoveringHeartProgress, closeTo(0.0, 0.01));

      // 30 minutes elapsed out of 120 minutes -> 25% fill (0.25)
      final p30 = UserProgress(hearts: 4, lastHeartRefillTime: now.subtract(const Duration(minutes: 30)));
      expect(p30.recoveringHeartProgress, closeTo(0.25, 0.01));

      // 60 minutes elapsed out of 120 minutes -> 50% fill (0.50)
      final p60 = UserProgress(hearts: 4, lastHeartRefillTime: now.subtract(const Duration(minutes: 60)));
      expect(p60.recoveringHeartProgress, closeTo(0.50, 0.01));

      // 90 minutes elapsed out of 120 minutes -> 75% fill (0.75)
      final p90 = UserProgress(hearts: 4, lastHeartRefillTime: now.subtract(const Duration(minutes: 90)));
      expect(p90.recoveringHeartProgress, closeTo(0.75, 0.01));

      // When full 5 hearts -> 100% (1.0)
      const pFull = UserProgress(hearts: 5);
      expect(pFull.recoveringHeartProgress, 1.0);
    });

    test('hearts cannot drop below 0', () {
      var progress = const UserProgress(hearts: 1);
      progress = progress.deductHeart();
      expect(progress.currentHearts, 0);

      progress = progress.deductHeart();
      expect(progress.currentHearts, 0);
    });

    test('auto-refill restores hearts after 2-hour intervals', () {
      // User lost a heart 245 minutes ago (2 full 120-minute cycles have passed)
      final pastTime = DateTime.now().subtract(const Duration(minutes: 245));
      final progress = UserProgress(
        hearts: 2,
        lastHeartRefillTime: pastTime,
      );

      // 2 + 2 = 4 hearts restored
      expect(progress.currentHearts, 4);
    });

    test('refillHeartsWithXp restores all 5 hearts and deducts 50 XP', () {
      const progress = UserProgress(xp: 350, hearts: 1);
      final refilled = progress.refillHeartsWithXp(costXp: 50);

      expect(refilled.currentHearts, 5);
      expect(refilled.xp, 300);
      expect(refilled.lastHeartRefillTime, isNull);
    });

    test('refillHeartsWithXp does nothing if XP balance is insufficient', () {
      const progress = UserProgress(xp: 30, hearts: 1);
      final failed = progress.refillHeartsWithXp(costXp: 50);

      expect(failed.currentHearts, 1);
      expect(failed.xp, 30);
    });

    test('healOneHeart increments hearts up to max 5', () {
      const progress = UserProgress(hearts: 4);
      final healed = progress.healOneHeart();
      expect(healed.currentHearts, 5);

      final overHealed = healed.healOneHeart();
      expect(overHealed.currentHearts, 5);
    });
  });

  group('HeartsBadge and HeartsRefillModal UI Tests', () {
    testWidgets('HeartsBadge displays 5 hearts and opens modal on tap', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: HeartsBadge(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Full stamina: all 5 hearts are solid red
      expect(find.byIcon(Icons.favorite_rounded), findsNWidgets(5));
      expect(find.byType(SingleHeartWidget), findsNWidgets(5));

      // Tap badge to open modal
      await tester.tap(find.byType(HeartsBadge));
      await tester.pumpAndSettle();

      expect(find.textContaining('Exam Lives & Stamina'), findsOneWidget);
      expect(find.textContaining('5-Life Discipline System'), findsOneWidget);
      expect(find.textContaining('Mistake Revision Drill'), findsOneWidget);
    });

    testWidgets('HeartsBadge renders empty outlines and recovering heart when hearts are lost', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Deduct 2 hearts -> 3 full hearts, 1 recovering heart, 1 empty outline
      await tester.runAsync(() async {
        await container.read(progressionProvider.notifier).deductHeart();
        await container.read(progressionProvider.notifier).deductHeart();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: HeartsBadge(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // When 0s elapsed: exactly 3 solid full hearts + 2 outline hearts (1 recovering at 0% + 1 empty)
      expect(find.byIcon(Icons.favorite_rounded), findsNWidgets(3));
      expect(find.byIcon(Icons.favorite_border_rounded), findsNWidgets(2));
    });

    testWidgets('HeartsRefillModal launches recovery drill without granting free unearned heart', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set user to 3 hearts
      await tester.runAsync(() async {
        await container.read(progressionProvider.notifier).deductHeart();
        await container.read(progressionProvider.notifier).deductHeart();
      });

      expect(container.read(progressionProvider).currentHearts, 3);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: HeartsRefillModal(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Next Life (+1 ❤️) in'), findsOneWidget);

      // Tap Mistake Revision Drill (+1 Heart Heal) button -> should open drill/vault, NOT grant a free instant heart
      final drillButton = find.textContaining('Mistake Revision Drill (+1 Heart Heal)');
      expect(drillButton, findsOneWidget);
      await tester.ensureVisible(drillButton);
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await tester.tap(drillButton);
        await Future.delayed(const Duration(milliseconds: 300));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Launches CbtExamScreen recovery drill without granting a free instant heart
      expect(find.byType(CbtExamScreen), findsOneWidget);
      expect(container.read(progressionProvider).currentHearts, 3);

      // Cleanly unmount & dispose container before invariant check cancels periodic timer
      await tester.pumpWidget(const SizedBox());
      container.dispose();
    });

    testWidgets('ExitGuardDialog displays Discipline Penalty warning about losing 1 Life', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExitGuardDialog(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Discipline Rule: Exiting midway deducts 1 Life (-1 ❤️)!'), findsOneWidget);
    });
  });
}
