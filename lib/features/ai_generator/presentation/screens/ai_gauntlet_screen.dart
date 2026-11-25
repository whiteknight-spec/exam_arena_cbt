import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/ai_generator_provider.dart';
import '../../../progression/domain/models/arena_level.dart';
import '../../../progression/domain/models/exam_type.dart';
import '../../../exam_engine/presentation/screens/cbt_exam_screen.dart';

class AiGauntletScreen extends ConsumerStatefulWidget {
  const AiGauntletScreen({super.key});

  @override
  ConsumerState<AiGauntletScreen> createState() => _AiGauntletScreenState();
}

class _AiGauntletScreenState extends ConsumerState<AiGauntletScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscureApiKey = true;

  final List<String> subjects = [
    'Quantitative Aptitude (Percentages, Ratio, Work)',
    'Logical Reasoning (Series, Syllogisms, Relations)',
    'General Awareness & Indian Polity/History',
    'General Tamil & English (Ilakkanam + Grammar)',
    'General Science (Physics, Chemistry, Biology)',
    'Tamil Society & Thirukkural (TNPSC)',
  ];

  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  final List<int> questionCounts = [5, 10, 20];

  @override
  void initState() {
    super.initState();
    final currentState = ref.read(aiGauntletProvider);
    _apiKeyController.text = currentState.apiKey;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiGauntletProvider);
    final notifier = ref.read(aiGauntletProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF131B2E) : Colors.white;
    final primaryText = isDark ? Colors.white : AppColors.textPrimary;
    final secondaryText = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
    final borderClr = isDark ? const Color(0xFF1E293B) : AppColors.border;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Level 4: AI Gauntlet 🤖',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF701A75), Color(0xFF9D174D), Color(0xFFBE185D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFBE185D).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Gemini 2.5 Flash Bilingual Engine',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Generates fresh, syllabus-aligned bilingual MCQs (Tamil & English) dynamically and persists them into your local SQLite database (exam_arena_cbt.db) for permanent offline practice.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form Section: Target Exam Selector
            Text(
              'Target Competitive Exam',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: primaryText),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderClr),
                color: cardBg,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: cardBg,
                  value: aiState.selectedExamType,
                  items: ExamType.values.map((exam) {
                    return DropdownMenuItem(
                      value: exam.id,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Color(exam.badgeColorHex),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              exam.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: primaryText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) notifier.setExamType(val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Subject / Topic Selector
            Text(
              'Subject & Topic Area',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: primaryText),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderClr),
                color: cardBg,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: cardBg,
                  value: subjects.contains(aiState.selectedSubject)
                      ? aiState.selectedSubject
                      : subjects.first,
                  items: subjects.map((sub) {
                    return DropdownMenuItem(
                      value: sub,
                      child: Text(
                        sub,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: primaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) notifier.setSubject(val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Difficulty Level Selector (Easy, Medium, Hard)
            Text(
              'Difficulty Level',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: primaryText),
            ),
            const SizedBox(height: 8),
            Row(
              children: difficulties.map((diff) {
                final isSelected = aiState.selectedDifficulty == diff;
                Color chipColor;
                if (diff == 'Easy') {
                  chipColor = const Color(0xFF10B981);
                } else if (diff == 'Medium') {
                  chipColor = const Color(0xFFF59E0B);
                } else {
                  chipColor = const Color(0xFFEF4444);
                }

                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => notifier.setDifficulty(diff),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? chipColor.withValues(alpha: 0.15) : cardBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? chipColor : borderClr,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            diff,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected
                                  ? chipColor
                                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Question Count Selector (5, 10, or 20 Questions)
            Text(
              'Number of Questions (5, 10, or 20 Qs)',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: primaryText),
            ),
            const SizedBox(height: 8),
            Row(
              children: questionCounts.map((count) {
                final isSelected = aiState.selectedCount == count;
                final activeColor = isDark ? const Color(0xFF38BDF8) : AppColors.primary;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => notifier.setCount(count),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? const Color(0xFF0C4A6E).withValues(alpha: 0.4) : const Color(0xFFEFF6FF))
                              : cardBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? activeColor : borderClr,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$count Questions',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected
                                  ? activeColor
                                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Gemini API Key Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gemini API Key (gemini-2.5-flash)',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: primaryText,
                  ),
                ),
                Text(
                  aiState.apiKey.isNotEmpty ? '✓ Key Saved' : 'Optional for Offline',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: aiState.apiKey.isNotEmpty
                        ? const Color(0xFF10B981)
                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _apiKeyController,
              obscureText: _obscureApiKey,
              style: TextStyle(color: primaryText),
              decoration: InputDecoration(
                filled: true,
                fillColor: cardBg,
                hintText: 'Enter your Google Gemini API key (AIzaSy...)',
                hintStyle: TextStyle(fontSize: 12, color: secondaryText),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_obscureApiKey ? Icons.visibility_off : Icons.visibility, size: 20),
                      onPressed: () => setState(() => _obscureApiKey = !_obscureApiKey),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Color(0xFF10B981)),
                      onPressed: () {
                        notifier.setApiKey(_apiKeyController.text.trim());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('Gemini API Key saved successfully!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              onChanged: (val) => notifier.setApiKey(val.trim()),
            ),
            const SizedBox(height: 16),

            // Error Message (graceful fallback prompt)
            if (aiState.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF450A0A) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? const Color(0xFF991B1B) : const Color(0xFFFCA5A5),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFFEF4444), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        aiState.errorMessage!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFFFECACA) : const Color(0xFF991B1B),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Primary Generation Action: Generate via Gemini 2.5 Flash
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.level4Gauntlet,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: aiState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.bolt),
                label: Text(
                  aiState.isLoading
                      ? 'Generating via Gemini 2.5 Flash...'
                      : 'Generate ${aiState.selectedCount} AI MCQs (gemini-2.5-flash)',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                onPressed: aiState.isLoading
                    ? null
                    : () {
                        notifier.generateQuestions(
                          examType: aiState.selectedExamType,
                          subject: aiState.selectedSubject,
                          difficulty: aiState.selectedDifficulty,
                          count: aiState.selectedCount,
                        );
                      },
              ),
            ),
            const SizedBox(height: 10),

            // 100% Offline Practice Button (Loads from SQLite Bank without API Key)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(
                  Icons.offline_bolt_rounded,
                  size: 18,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                ),
                label: Text(
                  'Load ${aiState.selectedCount} Questions from SQLite Bank (100% Offline)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                  ),
                ),
                onPressed: aiState.isLoading
                    ? null
                    : () {
                        notifier.loadOfflineQuestions(
                          examType: aiState.selectedExamType,
                          subject: aiState.selectedSubject,
                          difficulty: aiState.selectedDifficulty,
                          count: aiState.selectedCount,
                        );
                      },
              ),
            ),
            const SizedBox(height: 24),

            // Showcase of Generated Questions
            if (aiState.generatedQuestions.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Available MCQs (${aiState.generatedQuestions.length} Questions)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: primaryText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const Text(
                      'Launch CBT',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    onPressed: () {
                      final selectedExam = ExamType.values.firstWhere(
                        (e) => e.id == aiState.selectedExamType,
                        orElse: () => ExamType.rrbNtpc,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CbtExamScreen(
                            level: ArenaLevel.level4,
                            examType: selectedExam,
                            customQuestions: aiState.generatedQuestions,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...aiState.generatedQuestions.asMap().entries.map((entry) {
                final idx = entry.key;
                final q = entry.value;

                return Card(
                  color: cardBg,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: borderClr),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Q${idx + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  color: isDark ? const Color(0xFF38BDF8) : AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  q.subject,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: primaryText,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                q.difficulty.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          q.questionEn,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          q.questionTa,
                          style: TextStyle(fontSize: 13, color: secondaryText),
                        ),
                        const Divider(height: 18),
                        Text(
                          'Correct: Option ${String.fromCharCode(65 + q.correctIndex)} • ${q.safeCorrectOptionEn}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Explanation: ${q.explanationEn}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
