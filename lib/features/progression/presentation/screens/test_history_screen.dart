import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/timer_formatter.dart';
import '../../../exam_engine/domain/models/test_attempt_analytics.dart';
import '../../domain/models/exam_type.dart';

class TestHistoryScreen extends StatefulWidget {
  final List<TestAttemptAnalytics>? initialAttempts;

  const TestHistoryScreen({super.key, this.initialAttempts});

  @override
  State<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends State<TestHistoryScreen> {
  late Future<List<TestAttemptAnalytics>> _attemptsFuture;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _attemptsFuture = widget.initialAttempts != null
        ? Future.value(widget.initialAttempts)
        : AppDatabase.instance.getTestAttempts();
  }

  ExamType? _findExamType(String examId) {
    for (final exam in ExamType.values) {
      if (exam.id == examId) return exam;
    }
    return null;
  }

  String _formatExamTitle(String examId) {
    if (examId == 'rrb_ntpc') return 'RRB NTPC CBT 1';
    final match = _findExamType(examId);
    if (match != null) return match.title;
    return examId.replaceAll('_', ' ').toUpperCase();
  }

  Color _getExamColor(String examId) {
    final match = _findExamType(examId);
    if (match != null) return Color(match.badgeColorHex);
    return AppColors.primary;
  }

  bool _matchesFilter(TestAttemptAnalytics attempt, String filterKey) {
    final id = attempt.examType.toLowerCase();
    switch (filterKey) {
      case 'All':
        return true;
      case 'banking':
        return id.contains('ibps') || id.contains('rbi');
      case 'tnpsc':
        return id.contains('tnpsc') || id.contains('tnusrb');
      default:
        return id.contains(filterKey.toLowerCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF131B2E) : Colors.white;
    final primaryText = isDark ? Colors.white : AppColors.textPrimary;
    final secondaryText = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
    final borderClr = isDark ? const Color(0xFF1E293B) : AppColors.border;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Test History & Analytics',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: primaryText),
        ),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<TestAttemptAnalytics>>(
        future: _attemptsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allAttempts = snapshot.data ?? [];

          if (allAttempts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.history_toggle_off_rounded,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Test Attempts Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete your first mock test or speed sprint in the Arena to track your analytics and score progress here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start Practicing Now', style: TextStyle(fontWeight: FontWeight.w700)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            );
          }

          // Calculate Aggregated Metrics
          final totalAttempts = allAttempts.length;
          final totalXp = allAttempts.fold<int>(0, (sum, a) => sum + a.earnedXp);
          final avgAccuracy =
              allAttempts.fold<double>(0.0, (sum, a) => sum + a.accuracy) / totalAttempts;
          final bestScore =
              allAttempts.map((a) => a.netScore).reduce((a, b) => a > b ? a : b);

          final filteredAttempts =
              allAttempts.where((a) => _matchesFilter(a, _selectedFilter)).toList();

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _loadHistory();
              });
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Top Summary Dashboard Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.query_stats_rounded, color: Color(0xFF38BDF8), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Cumulative Mock Test Analytics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryMetric('Tests', '$totalAttempts', const Color(0xFF38BDF8)),
                          _buildSummaryMetric(
                            'Avg Accuracy',
                            '${avgAccuracy.toStringAsFixed(1)}%',
                            const Color(0xFF34D399),
                          ),
                          _buildSummaryMetric(
                            'Best Score',
                            '${bestScore >= 0 ? '+' : ''}${bestScore.toStringAsFixed(1)}',
                            const Color(0xFFFBBF24),
                          ),
                          _buildSummaryMetric('Total XP', '+$totalXp', const Color(0xFFA78BFA)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Filter Chips (Covers All 5 Exam Categories)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'All Exams ($totalAttempts)', isDark: isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('upsc', 'UPSC', isDark: isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('tnpsc', 'TNPSC / State', isDark: isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('rrb', 'RRB', isDark: isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('ssc', 'SSC', isDark: isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('banking', 'Banking', isDark: isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Past Sessions (${filteredAttempts.length})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: primaryText,
                      ),
                    ),
                    Text(
                      'Stored Offline in SQLite',
                      style: TextStyle(fontSize: 11, color: secondaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...filteredAttempts.map(
                  (attempt) => _buildAttemptCard(
                    attempt,
                    isDark: isDark,
                    cardBg: cardBg,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    borderClr: borderClr,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String key, String label, {bool isDark = false}) {
    final isSelected = _selectedFilter == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        color: isSelected
            ? Colors.white
            : (isDark ? const Color(0xFFE2E8F0) : AppColors.textPrimary),
      ),
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? const Color(0xFF131B2E) : Colors.white,
      side: BorderSide(
        color: isSelected
            ? AppColors.primary
            : (isDark ? const Color(0xFF1E293B) : AppColors.border),
      ),
      onSelected: (_) => setState(() => _selectedFilter = key),
    );
  }

  Widget _buildAttemptCard(
    TestAttemptAnalytics attempt, {
    required bool isDark,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
    required Color borderClr,
  }) {
    final examColor = _getExamColor(attempt.examType);
    final formattedDate =
        '${attempt.timestamp.day.toString().padLeft(2, '0')}/${attempt.timestamp.month.toString().padLeft(2, '0')}/${attempt.timestamp.year} • ${attempt.timestamp.hour.toString().padLeft(2, '0')}:${attempt.timestamp.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderClr),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Exam Badge + Earned XP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: examColor.withValues(alpha: isDark ? 0.22 : 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _formatExamTitle(attempt.examType),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : examColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '+${attempt.earnedXp} XP',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFFFDE68A) : const Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Core Stats Row: Net Score, Accuracy, Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Net Score', style: TextStyle(fontSize: 11, color: secondaryText)),
                  const SizedBox(height: 2),
                  Text(
                    '${attempt.netScore >= 0 ? '+' : ''}${attempt.netScore.toStringAsFixed(1)} / ${attempt.maxMarks.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: attempt.netScore < 0 ? const Color(0xFFEF4444) : primaryText,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Accuracy', style: TextStyle(fontSize: 11, color: secondaryText)),
                  const SizedBox(height: 2),
                  Text(
                    '${attempt.accuracy.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: attempt.accuracy >= 75
                          ? const Color(0xFF10B981)
                          : attempt.accuracy >= 50
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time Spent', style: TextStyle(fontSize: 11, color: secondaryText)),
                  const SizedBox(height: 2),
                  Text(
                    TimerFormatter.formatSeconds(attempt.timeSpentSeconds),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: primaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Question Counts Pill Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCountTag('Correct: ${attempt.correct}', const Color(0xFF10B981)),
                _buildCountTag('Wrong: ${attempt.incorrect}', const Color(0xFFEF4444)),
                if (attempt.optionESelected > 0)
                  _buildCountTag('Opt-E: ${attempt.optionESelected}', const Color(0xFF94A3B8)),
                _buildCountTag('Skipped: ${attempt.unattempted}', const Color(0xFF94A3B8)),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Date timestamp
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formattedDate,
              style: TextStyle(fontSize: 10, color: secondaryText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountTag(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
