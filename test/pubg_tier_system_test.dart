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
      expect(p1.pubgSubTier.title, 'Bronze 3');

      const p2 = UserProgress(xp: 1200);
      expect(p2.pubgTier, PubgTier.gold);
      expect(p2.pubgSubTier.title, 'Gold 1');

      const p3 = UserProgress(xp: 10500);
      expect(p3.pubgTier, PubgTier.conqueror);
      expect(p3.pubgSubTier.title, 'Conqueror 1');
    });

    test('defines 29 battle badges with Bronze, Silver, Gold (3 levels) and others (4 levels)', () {
      final badges = PubgSubTier.allBadges;
      expect(badges.length, 29);

      // Bronze: 3 levels (1, 2, 3)
      final bronzeBadges = badges.where((b) => b.tier == PubgTier.bronze).toList();
      expect(bronzeBadges.length, 3);
      expect(bronzeBadges.map((b) => b.level).toList(), [1, 2, 3]);

      // Silver: 3 levels (1, 2, 3)
      final silverBadges = badges.where((b) => b.tier == PubgTier.silver).toList();
      expect(silverBadges.length, 3);
      expect(silverBadges.map((b) => b.level).toList(), [1, 2, 3]);

      // Gold: 3 levels (1, 2, 3)
      final goldBadges = badges.where((b) => b.tier == PubgTier.gold).toList();
      expect(goldBadges.length, 3);
      expect(goldBadges.map((b) => b.level).toList(), [1, 2, 3]);

      // Platinum: 4 levels (1, 2, 3, 4)
      final platinumBadges = badges.where((b) => b.tier == PubgTier.platinum).toList();
      expect(platinumBadges.length, 4);
      expect(platinumBadges.map((b) => b.level).toList(), [1, 2, 3, 4]);

      // Diamond: 4 levels (1, 2, 3, 4)
      final diamondBadges = badges.where((b) => b.tier == PubgTier.diamond).toList();
      expect(diamondBadges.length, 4);
      expect(diamondBadges.map((b) => b.level).toList(), [1, 2, 3, 4]);

      // Crown: 4 levels (1, 2, 3, 4)
      final crownBadges = badges.where((b) => b.tier == PubgTier.crown).toList();
      expect(crownBadges.length, 4);
      expect(crownBadges.map((b) => b.level).toList(), [1, 2, 3, 4]);

      // Ace: 4 levels (1, 2, 3, 4)
      final aceBadges = badges.where((b) => b.tier == PubgTier.ace).toList();
      expect(aceBadges.length, 4);
      expect(aceBadges.map((b) => b.level).toList(), [1, 2, 3, 4]);

      // Conqueror: 4 levels (1, 2, 3, 4)
      final conquerorBadges = badges.where((b) => b.tier == PubgTier.conqueror).toList();
      expect(conquerorBadges.length, 4);
      expect(conquerorBadges.map((b) => b.level).toList(), [1, 2, 3, 4]);
    });

    test('unlocks badges sequentially one-by-one based on XP', () {
      // User with 350 XP: Bronze 1, 2, 3 unlocked; Silver 1 locked
      const xp = 350;
      final current = PubgSubTier.fromXp(xp);
      expect(current.title, 'Bronze 3');
      expect(current.isUnlocked(xp), isTrue);

      final bronze1 = PubgSubTier.allBadges[0];
      final bronze2 = PubgSubTier.allBadges[1];
      final bronze3 = PubgSubTier.allBadges[2];
      final silver1 = PubgSubTier.allBadges[3];

      expect(bronze1.isUnlocked(xp), isTrue);
      expect(bronze2.isUnlocked(xp), isTrue);
      expect(bronze3.isUnlocked(xp), isTrue);
      expect(silver1.isUnlocked(xp), isFalse);

      expect(current.nextBadge?.title, 'Silver 1');
      expect(current.xpNeeded(xp), 150);
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

    testWidgets('renders badge with subLevel ribbon label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: PubgTierBadge(
                tier: PubgTier.gold,
                subLevel: 2,
                size: PubgBadgeSize.medium,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('GOLD 2'), findsOneWidget);
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
    testWidgets('renders current rank, progress bar, and all 29 badges ladder', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const progress = UserProgress(xp: 1250); // Gold 1 (1000 - 1299 XP)

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
      expect(find.text('GOLD 1'), findsWidgets);
      expect(find.text('ALL 29 BATTLE BADGES'), findsOneWidget);

      // Verify tiers in ladder near the top
      expect(find.text('Bronze 1'), findsOneWidget);
      expect(find.text('Bronze 2'), findsOneWidget);
      expect(find.text('Bronze 3'), findsOneWidget);
      expect(find.text('Silver 1'), findsOneWidget);

      // Scroll down to view Gold and Platinum
      await tester.drag(find.byType(ListView).first, const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Platinum 1'), findsOneWidget);

      // Scroll further down to view apex ranks
      await tester.scrollUntilVisible(find.text('Conqueror 1'), 400);
      await tester.pumpAndSettle();

      expect(find.text('Conqueror 1'), findsOneWidget);
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

      // Tap on the PUBG tier badge in Candidate Dashboard header
      expect(find.text('BRONZE 3'), findsWidgets);
      await tester.tap(find.text('BRONZE 3').first);
      await tester.pumpAndSettle();

      // Trophy Room modal should open
      expect(find.text('PUBG Tier Arena Badges'), findsOneWidget);
      expect(find.text('ALL 29 BATTLE BADGES'), findsOneWidget);
    });
  });
}
