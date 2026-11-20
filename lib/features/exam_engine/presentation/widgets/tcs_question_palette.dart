import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/question_status.dart';

class TcsQuestionPalette extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Map<int, QuestionStatus> statuses;
  final ValueChanged<int> onQuestionSelected;
  final VoidCallback? onSubmit;
  final bool isDrawer;

  const TcsQuestionPalette({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.statuses,
    required this.onQuestionSelected,
    this.onSubmit,
    this.isDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  'Question Palette Legend',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                // TCS iON 5-State Legend Grid
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
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
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildLegendTile(
                              count: notAnsweredCount,
                              label: 'Not Answered',
                              color: AppColors.tcsNotAnswered,
                              shape: BoxShape.rectangle,
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Section Label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose a Question',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '$answeredCount / $totalQuestions Attempted',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
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

                    return InkWell(
                      onTap: () {
                        onQuestionSelected(index);
                        if (isDrawer) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
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
                            if (status == QuestionStatus.answeredReview)
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
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Evaluation Note
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Color(0xFFB45309)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '*Questions marked "Ans & Marked" WILL be evaluated in standard TCS iON scoring.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF92400E),
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
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
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
        backgroundColor: Colors.white,
        child: SafeArea(child: content),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
