import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/database/app_database.dart';
import 'features/ai_generator/data/datasources/local_question_datasource.dart';
import 'features/progression/domain/models/user_progress.dart';
import 'features/progression/presentation/screens/progression_hub_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enforce bundled offline-first fonts (Inter & NotoSansTamil under assets/google_fonts/)
  GoogleFonts.config.allowRuntimeFetching = false;

  // Initialize SQLite database and seed initial & expanded bilingual question banks
  final localDatasource = LocalQuestionDatasource(appDatabase: AppDatabase.instance);
  await localDatasource.seedIfEmpty();
  await localDatasource.seedAllExpandedQuestionsIfNeeded();

  // Ensure user progress is persisted in SQLite out of the box (clean 0-state for new users)
  final currentProgress = await AppDatabase.instance.getUserProgress();
  if (currentProgress == null) {
    await AppDatabase.instance.saveUserProgress(const UserProgress());
  }

  runApp(
    const ProviderScope(
      child: ExamArenaApp(),
    ),
  );
}

class ExamArenaApp extends ConsumerWidget {
  const ExamArenaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Exam Arena CBT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const ProgressionHubScreen(),
    );
  }
}
