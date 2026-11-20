import 'package:flutter/material.dart';
import 'package:exam_arena_cbt/core/theme/app_colors.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';

class ExamSelectorSheet extends StatelessWidget {
  final ExamType currentExam;
  final ValueChanged<ExamType> onSelect;

  const ExamSelectorSheet({
    super.key,
    required this.currentExam,
    required this.onSelect,
  });

  static Future<void> show(
    BuildContext context, {
    required ExamType currentExam,
    required ValueChanged<ExamType> onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ExamSelectorSheet(
        currentExam: currentExam,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Target Competitive Exam',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: ExamType.values.map((exam) {
                final isSelected = exam == currentExam;
                final lockText = exam.hasSectionalLock
                    ? ' • 🔒 ${exam.sectionalLockDurationMinutes}-min lock'
                    : '';
                final optionText = exam.hasOptionE ? '5 Options (A–E)' : '4 Options';
                final negText = exam.negativeMark > 0
                    ? '-${exam.negativeMark} neg.'
                    : '0 neg.';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryLight : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(exam.badgeColorHex).withValues(alpha: 0.15),
                        child: Icon(
                          Icons.school,
                          color: Color(exam.badgeColorHex),
                        ),
                      ),
                      title: Text(
                        exam.title,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${exam.totalQuestions} Qs • ${exam.totalDurationMinutes} mins • $optionText • $negText$lockText',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primaryLight)
                          : null,
                      onTap: () {
                        onSelect(exam);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
