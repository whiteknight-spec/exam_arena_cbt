import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/theme/app_theme.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/arena_level.dart';
import 'package:exam_arena_cbt/features/progression/presentation/screens/progression_hub_screen.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/streak_badge.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/question.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/screens/cbt_exam_screen.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/widgets/cbt_option_tile.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/widgets/countdown_timer_badge.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/widgets/language_toggle_chip.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/widgets/exit_guard_dialog.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  final testQuestions4Opts = [
    const Question(
      id: 'q_test_1',
      subject: 'Quantitative Aptitude',
      category: 'Quantitative Aptitude',
      examType: 'rrb_ntpc',
      questionEn: 'What is 20% of 250?',
      questionTa: '250-ல் 20% எவ்வளவு?',
      optionsEn: ['50', '40', '60', '45'],
      optionsTa: ['50', '40', '60', '45'],
      correctIndex: 0,
      explanationEn: '20% of 250 = (20/100) * 250 = 50.',
      explanationTa: '250 * 20 / 100 = 50.',
      hasOptionE: false,
    ),
    const Question(
      id: 'q_test_2',
      subject: 'General Awareness',
      category: 'General Awareness',
      examType: 'rrb_ntpc',
      questionEn: 'What is the capital of Tamil Nadu?',
      questionTa: 'தமிழ்நாட்டின் தலைநகரம் எது?',
      optionsEn: ['Chennai', 'Madurai', 'Coimbatore', 'Trichy'],
      optionsTa: ['சென்னை', 'மதுரை', 'கோயம்புத்தூர்', 'திருச்சி'],
      correctIndex: 0,
      explanationEn: 'Chennai is the capital of Tamil Nadu.',
      explanationTa: 'சென்னை தமிழ்நாட்டின் தலைநகரமாகும்.',
      hasOptionE: false,
    ),
  ];

  final testQuestionsTnpsc5Opts = [
    const Question(
      id: 'q_tnpsc_1',
      subject: 'General Tamil',
      category: 'General Tamil & English',
      examType: 'tnpsc_group_2_4',
      questionEn: 'Which is the oldest Tamil Sangam grammar text?',
      questionTa: 'பழமையான தமிழ் சங்க இலக்கண நூல் எது?',
      optionsEn: [
        'Tolkappiyam',
        'Nannool',
        'Silappathikaram',
        'Manimekalai',
        'Option E: Answer Not Known (விடை தெரியவில்லை)',
      ],
      optionsTa: [
        'தொல்காப்பியம்',
        'நன்னூல்',
        'சிலப்பதிகாரம்',
        'மணிமேகலை',
        'Option E: விடை தெரியவில்லை',
      ],
      correctIndex: 0,
      explanationEn: 'Tolkappiyam is the earliest extant work of Tamil literature and grammar.',
      explanationTa: 'தொல்காப்பியம் மிகப்பழமையான தமிழ் இலக்கண நூல் ஆகும்.',
      hasOptionE: true,
    ),
  ];

  group('ProgressionHubScreen Gamified UI', () {
    testWidgets('renders Level badge, animated XP bar, streak counter, and 4-tier ladder', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProgressionHubScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header and Streak Counter
      expect(find.text('Exam Arena CBT'), findsOneWidget);
      expect(find.byType(StreakBadge), findsOneWidget);
      expect(find.text('7'), findsWidgets);

      // Level Badge & XP Bar
      expect(find.textContaining('LVL'), findsWidgets);
      expect(find.textContaining('XP'), findsWidgets);
      expect(find.textContaining('TARGET COMPETITIVE EXAM'), findsOneWidget);

      // 4-Tier Level Unlock Ladder Nodes
      expect(find.text('4-Tier Level Unlock Ladder'), findsOneWidget);
      expect(find.text('Level 1: 15-min Topic Speed Sprints'), findsNothing); // title without Level 1 prefix
      expect(find.text('15-min Topic Speed Sprints'), findsOneWidget);
      expect(find.text('Sectional Timed Drills'), findsOneWidget);
      expect(find.text('Full-Length CBT Mocks'), findsOneWidget);
      expect(find.text('AI Adaptive Boss Gauntlet'), findsOneWidget);

      // Level labels
      expect(find.text('LEVEL 1'), findsOneWidget);
      expect(find.text('LEVEL 2'), findsOneWidget);
      expect(find.text('LEVEL 3'), findsOneWidget);
      expect(find.text('LEVEL 4'), findsOneWidget);
    });

    testWidgets('opens ExamSelectorSheet with RRB, SSC, TNPSC, and IBPS Clerk options', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProgressionHubScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on Change / Target exam card
      await tester.tap(find.text('Change').first);
      await tester.pumpAndSettle();

      // Verify sheet title and all 4 universal exams
      expect(find.text('Target Competitive Exam'), findsOneWidget);
      expect(find.text('RRB NTPC'), findsWidgets);
      expect(find.text('SSC CGL Tier 1'), findsOneWidget);
      expect(find.text('TNPSC Group 2 & Group 4'), findsOneWidget);
      expect(find.text('IBPS / SBI Clerk'), findsOneWidget);
    });
  });

  group('CbtExamScreen Real TCS iON CBT Exam Hall UI', () {
    testWidgets('renders live countdown timer, language switch, and question palette', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: CbtExamScreen(
              level: ArenaLevel.level1,
              examType: ExamType.rrbNtpc,
              customQuestions: testQuestions4Opts,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Terminal & Exam Title Header
      expect(find.text('RRB NTPC'), findsOneWidget);
      expect(find.textContaining('Terminal C-04'), findsOneWidget);

      // Live Countdown Timer Badge
      expect(find.byType(CountdownTimerBadge), findsOneWidget);

      // Instant Language Switch Chip
      expect(find.byType(LanguageToggleChip), findsOneWidget);
      expect(find.text('English (EN)'), findsOneWidget);

      // Initial English question text
      expect(find.text('What is 20% of 250?'), findsOneWidget);

      // 4 Options A-D
      expect(find.byType(CbtOptionTile), findsNWidgets(4));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
      expect(find.text('E'), findsNothing);

      // Instant Language Toggle
      await tester.tap(find.byType(LanguageToggleChip));
      await tester.pumpAndSettle();

      // Language should now show Tamil
      expect(find.text('தமிழ் (TA)'), findsOneWidget);
      expect(find.text('250-ல் 20% எவ்வளவு?'), findsOneWidget);

      // Bottom TCS iON Buttons
      expect(find.text('Mark & Next'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
      expect(find.text('Save & Next'), findsOneWidget);
      expect(find.textContaining('Submit Test'), findsOneWidget);
    });

    testWidgets('renders 5-option OMR tiles for TNPSC with Option E', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: CbtExamScreen(
              level: ArenaLevel.level3,
              examType: ExamType.tnpscGroup2And4,
              customQuestions: testQuestionsTnpsc5Opts,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Title & 5 Options
      expect(find.text('TNPSC Group 2 & Group 4'), findsOneWidget);
      expect(find.byType(CbtOptionTile), findsNWidgets(5));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
      expect(find.text('E'), findsOneWidget);

      // Option E banner for TNPSC
      expect(find.textContaining('TNPSC Option E'), findsOneWidget);
      expect(find.textContaining('Answer Not Known'), findsWidgets);
    });

    testWidgets('renders automatic Sectional Lock banner for SSC CGL', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: CbtExamScreen(
              level: ArenaLevel.level2,
              examType: ExamType.sscCgl,
              customQuestions: testQuestions4Opts,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Sectional Lock Banner
      expect(find.textContaining('Automatic Sectional Lock Active'), findsOneWidget);
      expect(find.textContaining('SSC CGL Tier 1'), findsWidgets);
    });

    testWidgets('PopScope triggers ExitGuardDialog on back button attempt', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: CbtExamScreen(
              level: ArenaLevel.level1,
              examType: ExamType.rrbNtpc,
              customQuestions: testQuestions4Opts,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the back arrow on top app bar
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Exit Guard Dialog appears
      expect(find.byType(ExitGuardDialog), findsOneWidget);
      expect(find.text('Exit CBT Exam Hall?'), findsOneWidget);
      expect(find.textContaining('Exiting this session will terminate your exam'), findsOneWidget);
      expect(find.text('Resume Test'), findsOneWidget);
      expect(find.text('Exit & Forfeit Test'), findsOneWidget);

      // Tap Resume Test closes dialog and keeps exam running
      await tester.tap(find.text('Resume Test'));
      await tester.pumpAndSettle();
      expect(find.byType(ExitGuardDialog), findsNothing);
      expect(find.byType(CbtExamScreen), findsOneWidget);
    });
  });
}
