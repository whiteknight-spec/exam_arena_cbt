import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/haptic_feedback_helper.dart';
import '../../../exam_engine/domain/models/question.dart';
import '../../../exam_engine/presentation/screens/cbt_exam_screen.dart';
import '../../domain/models/arena_level.dart';
import '../providers/progression_provider.dart';

final mistakeVaultProvider = FutureProvider.autoDispose<List<Question>>((ref) async {
  return AppDatabase.instance.getActiveMistakes();
});

class MistakeVaultScreen extends ConsumerStatefulWidget {
  const MistakeVaultScreen({super.key});

  @override
  ConsumerState<MistakeVaultScreen> createState() => _MistakeVaultScreenState();
}

class _MistakeVaultScreenState extends ConsumerState<MistakeVaultScreen> {
  @override
  Widget build(BuildContext context) {
    final mistakesAsync = ref.watch(mistakeVaultProvider);
    final userProgress = ref.watch(progressionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Mistake Vault (Error Notebook) 🎯',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Mistakes',
            onPressed: () => ref.invalidate(mistakeVaultProvider),
          ),
        ],
      ),
      body: mistakesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading mistakes: $err')),
        data: (questions) {
          if (questions.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 56),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Weak Questions!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'You have zero unresolved mistakes in your vault. When you miss a question in CBT Mocks, it will automatically appear here for targeted revision.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Banner: Active Revision Drill with Free Life Reward
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF881337), Color(0xFFBE123C)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFBE123C).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_fix_high_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${questions.length} Weak Questions Pending Revision',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Master these failed questions in a rapid drill. Answering them correctly heals +1 Heart (❤️) back to full stamina!',
                      style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF881337),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: const Text(
                          'Launch Mistake Revision Drill',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                        onPressed: () {
                          HapticFeedbackHelper.heavyImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CbtExamScreen(
                                level: ArenaLevel.level1,
                                examType: userProgress.selectedExam,
                                customQuestions: questions,
                              ),
                            ),
                          ).then((_) {
                            ref.invalidate(mistakeVaultProvider);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Failed Question Ledger (${questions.length})',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              const SizedBox(height: 10),

              ...questions.asMap().entries.map((entry) {
                final idx = entry.key;
                final q = entry.value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '#${idx + 1} Failed',
                                style: const TextStyle(
                                  color: Color(0xFFB91C1C),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              q.displayCategory,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 20),
                              tooltip: 'Mark as Mastered',
                              onPressed: () async {
                                HapticFeedbackHelper.lightImpact();
                                await AppDatabase.instance.markMistakeMastered(q.id);
                                ref.invalidate(mistakeVaultProvider);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('✓ Marked question as Mastered!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          q.questionEn,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          q.questionTa,
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const Divider(height: 16),
                        Text(
                          'Correct Answer: Option ${String.fromCharCode(65 + q.correctIndex)} • ${q.optionsEn.isNotEmpty ? q.optionsEn[q.correctIndex] : ""}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF059669),
                          ),
                        ),
                        if (q.explanationEn.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Explanation: ${q.explanationEn}',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
