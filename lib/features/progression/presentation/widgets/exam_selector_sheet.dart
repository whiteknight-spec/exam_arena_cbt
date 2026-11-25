import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/exam_type.dart';
import '../../domain/models/pyq_paper.dart';

class ExamSelectorSheet extends StatefulWidget {
  final ExamType currentExam;
  final String? currentPyqId;
  final ValueChanged<ExamType> onSelect;
  final ValueChanged<PyqPaper>? onSelectPyq;

  const ExamSelectorSheet({
    super.key,
    required this.currentExam,
    this.currentPyqId,
    required this.onSelect,
    this.onSelectPyq,
  });

  static Future<void> show(
    BuildContext context, {
    required ExamType currentExam,
    String? currentPyqId,
    required ValueChanged<ExamType> onSelect,
    ValueChanged<PyqPaper>? onSelectPyq,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExamSelectorSheet(
        currentExam: currentExam,
        currentPyqId: currentPyqId,
        onSelect: onSelect,
        onSelectPyq: onSelectPyq,
      ),
    );
  }

  @override
  State<ExamSelectorSheet> createState() => _ExamSelectorSheetState();
}

class _ExamSelectorSheetState extends State<ExamSelectorSheet> {
  ExamCategory _selectedCategory = ExamCategory.all;
  bool _isPyqMode = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryText = isDark ? Colors.white : AppColors.textPrimary;
    final secondaryText = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
    final activeBlue = isDark ? const Color(0xFF38BDF8) : AppColors.primary;

    final filteredExams = _selectedCategory == ExamCategory.all
        ? ExamType.values
        : ExamType.values.where((e) => e.category == _selectedCategory).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target Competitive Exam',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Select exam syllabus or official previous year papers',
                      style: TextStyle(fontSize: 12, color: secondaryText),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 20, color: primaryText),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dual Mode Toggle: Exam Blueprints vs Previous Year Papers (PYQ)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isPyqMode = false),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        color: !_isPyqMode ? cardBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: !_isPyqMode
                            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Exam Blueprints',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: !_isPyqMode ? FontWeight.w800 : FontWeight.w600,
                          color: !_isPyqMode ? activeBlue : secondaryText,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isPyqMode = true),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        color: _isPyqMode ? cardBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: _isPyqMode
                            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '🏛️ Previous Year Papers (PYQ)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: _isPyqMode ? FontWeight.w800 : FontWeight.w600,
                          color: _isPyqMode
                              ? (isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A))
                              : secondaryText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // PYQ Mode List
          if (_isPyqMode) ...[
            Expanded(
              child: ListView(
                children: PyqPaper.standardPapers.map((paper) {
                  final isSelected = widget.currentPyqId != null
                      ? widget.currentPyqId == paper.id
                      : paper.examType == widget.currentExam;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        if (widget.onSelectPyq != null) {
                          widget.onSelectPyq!(paper);
                        } else {
                          widget.onSelect(paper.examType);
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Target set to PYQ: ${paper.title}!'),
                            backgroundColor: const Color(0xFF1E3A8A),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.35) : const Color(0xFFEFF6FF))
                              : cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? (isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A))
                                : (isDark ? const Color(0xFF334155) : const Color(0x14000000)),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Year & Shift Pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E3A8A).withValues(alpha: isDark ? 0.45 : 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${paper.year}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A),
                                    ),
                                  ),
                                  Text(
                                    'PYQ',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          paper.title,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                            color: primaryText,
                                          ),
                                        ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1E3A8A),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'ACTIVE',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    paper.shiftOrPaper,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${paper.totalQuestions} Questions • ${paper.durationMinutes} Minutes • Official Historical Paper',
                                    style: TextStyle(fontSize: 10, color: secondaryText),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: secondaryText),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ] else ...[
            // Category Filter Tabs (Apple Pill Segmented Bar)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ExamCategory.values.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  final count = cat == ExamCategory.all
                      ? ExamType.values.length
                      : ExamType.values.where((e) => e.category == cat).length;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      showCheckmark: false,
                      label: Text('${cat.title} ($count)'),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : primaryText,
                      ),
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      selectedColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                      ),
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Filtered Exams List
            Expanded(
              child: ListView(
                children: filteredExams.map((exam) {
                  final isSelected = exam == widget.currentExam && widget.currentPyqId == null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        widget.onSelect(exam);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Target set to ${exam.title}! Mock tests calibrated.'),
                            backgroundColor: const Color(0xFF0071E3),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? const Color(0xFF0C4A6E).withValues(alpha: 0.35) : const Color(0xFFF8F9FF))
                              : cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? activeBlue
                                : (isDark ? const Color(0xFF334155) : const Color(0x14000000)),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Left: Icon Avatar
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Color(exam.badgeColorHex).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getCategoryIcon(exam.category),
                                color: Color(exam.badgeColorHex),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Middle: Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          exam.title,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                            color: primaryText,
                                          ),
                                        ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'ACTIVE',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${exam.totalQuestions} Qs • ${exam.totalDurationMinutes} mins • ${exam.hasOptionE ? "5 Options (A–E)" : "4 Options"}${exam.negativeMark > 0 ? " • -${exam.negativeMark} neg" : " • 0 neg"}${exam.hasSectionalLock ? " • 🔒 ${exam.sectionalLockDurationMinutes}m lock" : ""}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Right: Radio Check
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Icon(
                                isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                                color: isSelected ? activeBlue : Colors.grey.shade400,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getCategoryIcon(ExamCategory category) {
    switch (category) {
      case ExamCategory.upsc:
        return Icons.policy_rounded;
      case ExamCategory.tnpsc:
        return Icons.account_balance_rounded;
      case ExamCategory.railways:
        return Icons.train_rounded;
      case ExamCategory.ssc:
        return Icons.badge_rounded;
      case ExamCategory.banking:
        return Icons.account_balance_wallet_rounded;
      case ExamCategory.all:
        return Icons.school_rounded;
    }
  }
}
