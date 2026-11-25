import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/question_status.dart';
import '../../domain/models/section.dart';

class TcsQuestionPalette extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Map<int, QuestionStatus> statuses;
  final ValueChanged<int> onQuestionSelected;
  final VoidCallback? onSubmit;
  final bool isDrawer;
  final List<ExamSection> sections;
  final int currentSectionIndex;
  final bool hasSectionalLock;

  const TcsQuestionPalette({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.statuses,
    required this.onQuestionSelected,
    this.onSubmit,
    this.isDrawer = false,
    this.sections = const [],
    this.currentSectionIndex = 0,
    this.hasSectionalLock = false,
  });

  bool _isAccessible(int index) {
    if (!hasSectionalLock || sections.length <= 1) return true;
    if (currentSectionIndex < 0 || currentSectionIndex >= sections.length) {
      return true;
    }
    return sections[currentSectionIndex].questionIndices.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceBg = isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final borderClr = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final primaryText = isDark ? Colors.white : AppColors.textPrimary;

    // Live counts for all 5 official TCS iON statuses
    int answeredCount = 0;
    int notAnsweredCount = 0;
    int reviewCount = 0;
    int answeredReviewCount = 0;
    int notVisitedCount = 0;

    for (int i = 0; i < totalQuestions; i++) {
      final st = statuses[i] ?? QuestionStatus.notVisited;
      switch (st) {
        case QuestionStatus.answered:
          answeredCount++;
          break;
        case QuestionStatus.notAnswered:
          notAnsweredCount++;
          break;
        case QuestionStatus.review:
          reviewCount++;
          break;
        case QuestionStatus.answeredReview:
          answeredReviewCount++;
          break;
        case QuestionStatus.notVisited:
          notVisitedCount++;
          break;
      }
    }

    final isMultiSectionLocked = hasSectionalLock && sections.length > 1;
    final activeSection = isMultiSectionLocked &&
            currentSectionIndex >= 0 &&
            currentSectionIndex < sections.length
        ? sections[currentSectionIndex]
        : null;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF334155),
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Candidate: Aspirant #8492',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'TCS iON CBT Terminal C-04',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isDrawer)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question Palette Legend',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 10),

                // TCS iON 5-State Legend Grid
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderClr),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildLegendTile(
                              count: answeredCount,
                              label: 'Answered',
                              color: AppColors.tcsAnswered,
                              shape: BoxShape.rectangle,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildLegendTile(
                              count: notAnsweredCount,
                              label: 'Not Answered',
                              color: AppColors.tcsNotAnswered,
                              shape: BoxShape.rectangle,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildLegendTile(
                              count: reviewCount,
                              label: 'Marked Review',
                              color: AppColors.tcsReview,
                              shape: BoxShape.circle,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildLegendTile(
                              count: answeredReviewCount,
                              label: 'Ans & Marked*',
                              color: AppColors.tcsAnsweredReview,
                              shape: BoxShape.circle,
                              isEvaluated: true,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildLegendTile(
                        count: notVisitedCount,
                        label: 'Not Visited',
                        color: AppColors.tcsNotVisited,
                        textColor: Colors.black87,
                        shape: BoxShape.rectangle,
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (activeSection != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF78350F).withValues(alpha: 0.3)
                          : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFFD97706).withValues(alpha: 0.5)
                            : const Color(0xFFFDE68A),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_clock, size: 15, color: Color(0xFFD97706)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Active Section (${currentSectionIndex + 1}/${sections.length}): ${activeSection.name}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Section Label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose a Question',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: primaryText,
                      ),
                    ),
                    Text(
                      '$answeredCount / $totalQuestions Attempted',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF38BDF8) : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Question Number Grid (Responsive Grid)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: totalQuestions,
                  itemBuilder: (context, index) {
                    final status = statuses[index] ?? QuestionStatus.notVisited;
                    final isCurrent = index == currentIndex;
                    final accessible = _isAccessible(index);

                    return InkWell(
                      onTap: accessible
                          ? () {
                              onQuestionSelected(index);
                              Navigator.pop(context);
                            }
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Opacity(
                        opacity: accessible ? 1.0 : 0.42,
                        child: Container(
                          decoration: BoxDecoration(
                            color: status.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCurrent ? const Color(0xFFFBBF24) : status.borderColor,
                              width: isCurrent ? 2.5 : 1.0,
                            ),
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFFFBBF24).withValues(alpha: 0.5),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: status.textColor,
                                ),
                              ),
                              if (!accessible)
                                const Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Icon(
                                    Icons.lock_rounded,
                                    size: 9,
                                    color: Color(0xFF475569),
                                  ),
                                )
                              else if (status == QuestionStatus.answeredReview)
                                const Positioned(
                                  top: 2,
                                  right: 3,
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 10,
                                    color: Color(0xFF4ADE80),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Evaluation Note
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF78350F).withValues(alpha: 0.25)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFFD97706).withValues(alpha: 0.4)
                          : const Color(0xFFFDE68A),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Color(0xFFB45309)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '*Questions marked "Ans & Marked" WILL be evaluated in standard TCS iON scoring.',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Submit Button Footer
        if (onSubmit != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceBg,
              border: Border(top: BorderSide(color: borderClr)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text(
                  'Final Submit Examination',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                onPressed: () {
                  if (isDrawer) Navigator.pop(context);
                  onSubmit!();
                },
              ),
            ),
          ),
      ],
    );

    if (isDrawer) {
      return Drawer(
        width: 320,
        backgroundColor: surfaceBg,
        child: SafeArea(child: content),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: surfaceBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: content,
    );
  }

  Widget _buildLegendTile({
    required int count,
    required String label,
    required Color color,
    Color textColor = Colors.white,
    BoxShape shape = BoxShape.rectangle,
    BoxBorder? border,
    bool isEvaluated = false,
    bool isDark = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: color,
              shape: shape,
              borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(4) : null,
              border: border,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                if (isEvaluated)
                  const Positioned(
                    top: 1,
                    right: 1,
                    child: Icon(Icons.check, size: 8, color: Color(0xFF4ADE80)),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFE2E8F0) : AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
