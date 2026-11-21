import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/core/theme/app_theme.dart';
import 'package:exam_arena_cbt/core/theme/theme_provider.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/question.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/widgets/virtual_hall_ticket_sheet.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/arena_level.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';
import 'package:exam_arena_cbt/features/progression/presentation/screens/mistake_vault_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Modern Upgrades - SQLite Mistake Vault & Error Notebook', () {
    late AppDatabase appDb;

    setUp(() async {
      appDb = AppDatabase.instance;
      await AppDatabase.createInMemoryDatabase();
    });

    tearDown(() async {
      await appDb.close();
    });

    final testMistakeQuestion = const Question(
      id: 'q_failed_101',
      subject: 'Quantitative Aptitude',
      category: 'Time & Work',
      examType: 'rrb_ntpc',
      questionEn: 'A can do a work in 10 days, B in 15 days. Together in how many days?',
      questionTa: 'A ஒரு வேலையை 10 நாட்களில், B 15 நாட்களில் செய்தால், இருவரும் சேர்ந்து எத்தனை நாட்களில் முடிப்பார்கள்?',
      optionsEn: ['6 days', '8 days', '5 days', '7 days'],
      optionsTa: ['6 நாட்கள்', '8 நாட்கள்', '5 நாட்கள்', '7 நாட்கள்'],
      correctIndex: 0,
      explanationEn: '1/10 + 1/15 = 5/30 = 1/6 -> 6 days',
      explanationTa: '1/10 + 1/15 = 5/30 = 1/6 -> 6 நாட்கள்',
    );

    test('Records mistake and updates failed count', () async {
      expect(await appDb.getActiveMistakeCount(), 0);

      await appDb.recordMistake(testMistakeQuestion);
      expect(await appDb.getActiveMistakeCount(), 1);

      final active = await appDb.getActiveMistakes();
      expect(active.length, 1);
      expect(active.first.id, 'q_failed_101');
      expect(active.first.questionEn, contains('A can do a work in 10 days'));

      // If failed again, increment count rather than duplicate row
      await appDb.recordMistake(testMistakeQuestion);
      expect(await appDb.getActiveMistakeCount(), 1);
    });

    test('Marks mistake as mastered and removes from active ledger', () async {
      await appDb.recordMistake(testMistakeQuestion);
      expect(await appDb.getActiveMistakeCount(), 1);

      await appDb.markMistakeMastered('q_failed_101');
      expect(await appDb.getActiveMistakeCount(), 0);

      final active = await appDb.getActiveMistakes();
      expect(active.isEmpty, isTrue);
    });
  });

  group('Modern Upgrades - Theme System & OLED Midnight Mode', () {
    test('AppTheme.darkTheme has OLED dark background and Dark brightness', () {
      final dark = AppTheme.darkTheme;
      expect(dark.brightness, Brightness.dark);
      expect(dark.scaffoldBackgroundColor, const Color(0xFF090D16));
      expect(dark.colorScheme.surface, const Color(0xFF131B2E));
    });

    test('ThemeModeNotifier toggles between light and dark themes', () {
      final container = ProviderContainer();
      expect(container.read(themeModeProvider), ThemeMode.light);

      container.read(themeModeProvider.notifier).toggleTheme();
      expect(container.read(themeModeProvider), ThemeMode.dark);

      container.read(themeModeProvider.notifier).toggleTheme();
      expect(container.read(themeModeProvider), ThemeMode.light);
    });
  });

  group('Modern Upgrades - Virtual TCS Hall Ticket Widget', () {
    testWidgets('renders Roll No, Exam title, duration and enter button', (tester) async {
      bool entered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualHallTicketSheet(
              level: ArenaLevel.level3,
              examType: ExamType.rrbNtpc,
              onEnter: () {
                entered = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('OFFICIAL CBT E-ADMIT CARD'), findsOneWidget);
      expect(find.text('2026-TN-98124'), findsOneWidget);
      expect(find.text('RRB NTPC'), findsOneWidget);
      expect(find.textContaining('Negative Marking'), findsOneWidget);

      final enterBtn = find.text('Verify & Enter CBT Exam Hall');
      expect(enterBtn, findsOneWidget);
      await tester.tap(enterBtn);
      await tester.pumpAndSettle();

      expect(entered, isTrue);
    });
  });

  group('Modern Upgrades - Mistake Vault Screen UI', () {
    testWidgets('renders empty state when zero mistakes exist', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mistakeVaultProvider.overrideWith((ref) => Future.value([])),
          ],
          child: const MaterialApp(
            home: MistakeVaultScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Mistake Vault (Error Notebook) 🎯'), findsOneWidget);
      expect(find.text('No Weak Questions!'), findsOneWidget);
    });
  });
}
