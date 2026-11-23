import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/arena_level.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';
import 'package:exam_arena_cbt/features/progression/presentation/screens/progression_hub_screen.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/exam_arena_logo.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/streak_badge.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/accuracy_badge.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/hearts_badge.dart';
import 'package:exam_arena_cbt/features/progression/presentation/widgets/xp_bar.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/exam_result.dart';
import 'package:exam_arena_cbt/features/exam_engine/domain/models/question.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/screens/cbt_exam_screen.dart';
import 'package:exam_arena_cbt/features/exam_engine/presentation/screens/exam_summary_screen.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await AppDatabase.createInMemoryDatabase();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  const sampleQuestions = [
    Question(
      id: 'q_mob_1',
      subject: 'Quantitative Aptitude',
      category: 'Quantitative Aptitude',
      examType: 'rrb_ntpc',
      questionEn: 'What is 15% of 300?',
      questionTa: '300-ல் 15% எவ்வளவு?',
      optionsEn: ['45', '40', '50', '35'],
      optionsTa: ['45', '40', '50', '35'],
      correctIndex: 0,
      explanationEn: '15% of 300 = 45.',
      explanationTa: '300 * 15 / 100 = 45.',
      hasOptionE: false,
    ),
  ];

  group('Mobile Viewport (360px & 390px) Alignment & Zero-Overflow Audits', () {
    testWidgets('ProgressionHubScreen renders with zero overflow on compact 360x640 Android viewport', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProgressionHubScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no overflow errors were thrown during layout
      expect(tester.takeException(), isNull);

      // Verify brand logo and status badges fit cleanly in AppBar
      expect(find.byType(ExamArenaLogo), findsOneWidget);
      expect(find.byType(StreakBadge), findsOneWidget);
      expect(find.byType(AccuracyBadge), findsOneWidget);
      expect(find.byType(HeartsBadge), findsOneWidget);
      expect(find.byType(XpBar), findsOneWidget);
    });

    testWidgets('ProgressionHubScreen renders with zero overflow on standard 390x844 iPhone viewport', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProgressionHubScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ExamArenaLogo), findsOneWidget);
      expect(find.text('Exam Arena CBT'), findsOneWidget);
    });

    testWidgets('CbtExamScreen console fits 360x640 mobile screen with zero overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const dummyQuestions = <Question>[
        Question(
          id: 'q1',
          subject: 'Polity',
          questionEn: 'Which Article of Indian Constitution guarantees Equality before Law?',
          questionTa: 'சட்டத்தின் முன் அனைவரும் சமம் என்பதை உறுதி செய்யும் இந்திய அரசியலமைப்பு பிரிவு எது?',
          optionsEn: ['Article 14', 'Article 19', 'Article 21', 'Article 32'],
          optionsTa: ['பிரிவு 14', 'பிரிவு 19', 'பிரிவு 21', 'பிரிவு 32'],
          correctIndex: 0,
          explanationEn: 'Article 14 provides equality before the law.',
          explanationTa: 'பிரிவு 14 சட்டத்தின் முன் அனைவரும் சமம் என்பதை கூறுகிறது.',
          examType: 'RRB NTPC CBT',
          difficulty: 'Easy',
        ),
      ];

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CbtExamScreen(
              level: ArenaLevel.level1,
              examType: ExamType.rrbNtpc,
              customQuestions: dummyQuestions,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final err = tester.takeException();
      expect(err, isNull);

      // Verify bottom action bar buttons render
      expect(find.text('Prev'), findsOneWidget);
      expect(find.text('Mark & Next'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
      expect(find.text('Save & Next'), findsOneWidget);
      expect(find.text('Submit Test'), findsOneWidget);
    });

    testWidgets('ExamSummaryScreen analytics cards fit 360x640 mobile screen with zero overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const examResult = ExamResult(
        totalQuestions: 1,
        attempted: 1,
        correct: 1,
        incorrect: 0,
        optionESelected: 0,
        unattempted: 0,
        positiveMarksEarned: 1.0,
        negativeMarksDeducted: 0.0,
        netScore: 1.0,
        maximumMarks: 1.0,
        timeSpentSeconds: 45,
      );

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ExamSummaryScreen(
              result: examResult,
              questions: sampleQuestions,
              userSelections: {0: 0},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('1.00'), findsWidgets);
    });
  });
}
