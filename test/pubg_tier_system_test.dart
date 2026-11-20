import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/pubg_tier.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/user_progress.dart';
import 'package:exam_arena_cbt/features/progression/presentation/screens/progression_hub_screen.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/pubg_tier_badge.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/pubg_tier_modal.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    await AppDatabase.createInMemoryDatabase();
  });

  group('PUBG Battle Tier Domain Model Specifications', () {
    test('accurately classifies XP into all 8 PUBG Tiers', () {
      // Bronze: 0 - 499 XP
      expect(PubgTier.fromXp(0), PubgTier.bronze);
      expect(PubgTier.fromXp(350), PubgTier.bronze);
      expect(PubgTier.fromXp(499), PubgTier.bronze);

      // Silver: 500 - 999 XP
      expect(PubgTier.fromXp(500), PubgTier.silver);
      expect(PubgTier.fromXp(850), PubgTier.silver);
      expect(PubgTier.fromXp(999), PubgTier.silver);

      // Gold: 1000 - 1999 XP
      expect(PubgTier.fromXp(1000), PubgTier.gold);
      expect(PubgTier.fromXp(1500), PubgTier.gold);

      // Platinum: 2000 - 3499 XP
      expect(PubgTier.fromXp(2000), PubgTier.platinum);
      expect(PubgTier.fromXp(3000), PubgTier.platinum);

      // Diamond: 3500 - 4999 XP
      expect(PubgTier.fromXp(3500), PubgTier.diamond);
      expect(PubgTier.fromXp(4800), PubgTier.diamond);

      // Crown: 5000 - 7499 XP
      expect(PubgTier.fromXp(5000), PubgTier.crown);
      expect(PubgTier.fromXp(6200), PubgTier.crown);

      // Ace: 7500 - 9999 XP
      expect(PubgTier.fromXp(7500), PubgTier.ace);
      expect(PubgTier.fromXp(9500), PubgTier.ace);

      // Conqueror: 10000+ XP
      expect(PubgTier.fromXp(10000), PubgTier.conqueror);
      expect(PubgTier.fromXp(25000), PubgTier.conqueror);
    });

    test('calculates XP remaining and progress percentage to next tier', () {
      // User with 350 XP in Bronze (Next is Silver at 500 XP)
      const bronzeTier = PubgTier.bronze;
      expect(bronzeTier.nextTier, PubgTier.silver);
      expect(bronzeTier.xpNeededForNextTier(350), 150);
      expect(bronzeTier.progressToNextTier(350), closeTo(0.7, 0.01));

      // Conqueror has no next tier
      const conquerorTier = PubgTier.conqueror;
      expect(conquerorTier.nextTier, isNull);
      expect(conquerorTier.xpNeededForNextTier(12000), 0);
      expect(conquerorTier.progressToNextTier(12000), 1.0);
    });

    test('has complete Tamil translations and Roman numerals for all tiers', () {
      for (final tier in PubgTier.values) {
        expect(tier.title, isNotEmpty);
        expect(tier.tamilTitle, isNotEmpty);
        expect(tier.tierRoman, isNotEmpty);
        expect(tier.badgeSubtitle, isNotEmpty);
        expect(tier.perkDescription, isNotEmpty);
      }
    });

    test('UserProgress integrates seamlessly with PubgTier', () {
      const p1 = UserProgress(xp: 350);
      expect(p1.pubgTier, PubgTier.bronze);

      const p2 = UserProgress(xp: 1200);
      expect(p2.pubgTier, PubgTier.gold);

      const p3 = UserProgress(xp: 10500);
      expect(p3.pubgTier, PubgTier.conqueror);
    });
  });

  group('PubgTierBadge Vector Widget Tests', () {
    testWidgets('renders all 8 tier badges in custom metallic glory without emojis', (tester) async {
      for (final tier in PubgTier.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: PubgTierBadge(
                  tier: tier,
                  size: PubgBadgeSize.large,
                  showGlow: true,
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text(tier.title.toUpperCase()), findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);
      }
    });

    testWidgets('renders locked badge state with lock icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: PubgTierBadge(
                tier: PubgTier.crown,
                size: PubgBadgeSize.medium,
                isLocked: true,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('LOCKED'), findsOneWidget);
      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
    });
  });

  group('PubgTierModal Trophy Room Showcase', () {
    testWidgets('renders current rank, progress bar, and all 8 tiers ladder', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const progress = UserProgress(xp: 1250); // Gold Tier (1000 - 1999 XP)

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PubgTierModal(progress: progress),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PUBG Tier Arena Badges'), findsOneWidget);
      expect(find.text('CURRENT BATTLE RANK'), findsOneWidget);
      expect(find.text('GOLD III'), findsOneWidget);
      expect(find.text('ALL 8 PUBG BATTLE TIERS'), findsOneWidget);

      // Verify tiers in ladder
      expect(find.text('Bronze I'), findsOneWidget);
      expect(find.text('Silver II'), findsOneWidget);
      expect(find.text('Gold III'), findsOneWidget);
      expect(find.text('Platinum IV'), findsOneWidget);

      // Scroll to bottom of list to view top apex ranks
      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Crown VI'), findsOneWidget);
      expect(find.text('Ace VII'), findsOneWidget);
      expect(find.text('Conqueror VIII'), findsOneWidget);
    });

    testWidgets('tapping tier badge in ProgressionHub opens PubgTierModal', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProgressionHubScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on the PUBG tier badge tile in ProgressionHubScreen
      expect(find.textContaining('Tap to view 8 PUBG Tier Badges'), findsOneWidget);
      await tester.tap(find.textContaining('Tap to view 8 PUBG Tier Badges'));
      await tester.pumpAndSettle();

      // Trophy Room modal should open
      expect(find.text('PUBG Tier Arena Badges'), findsOneWidget);
      expect(find.text('ALL 8 PUBG BATTLE TIERS'), findsOneWidget);
    });
  });
}
