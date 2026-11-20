import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/database/app_database.dart';
import 'features/ai_generator/data/datasources/local_question_datasource.dart';
import 'features/progression/domain/models/user_progress.dart';
import 'features/progression/presentation/screens/progression_hub_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite database and seed initial 30 offline bilingual questions
  final localDatasource = LocalQuestionDatasource(appDatabase: AppDatabase.instance);
  await localDatasource.seedIfEmpty();

  // Ensure user progress is persisted in SQLite out of the box
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

class ExamArenaApp extends StatelessWidget {
  const ExamArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exam Arena CBT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ProgressionHubScreen(),
    );
  }
}
