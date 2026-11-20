import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum QuestionStatus {
  notVisited(
    label: 'Not Visited',
    tamilLabel: 'பார்க்காதவை',
    backgroundColor: AppColors.tcsNotVisited,
    textColor: AppColors.tcsNotVisitedText,
    borderColor: Color(0xFFCBD5E1),
  ),
  notAnswered(
    label: 'Not Answered',
    tamilLabel: 'விடையளிக்காதவை',
    backgroundColor: AppColors.tcsNotAnswered,
    textColor: Colors.white,
    borderColor: AppColors.tcsNotAnswered,
  ),
  answered(
    label: 'Answered',
    tamilLabel: 'விடையளித்தவை',
    backgroundColor: AppColors.tcsAnswered,
    textColor: Colors.white,
    borderColor: AppColors.tcsAnswered,
  ),
  review(
    label: 'Marked for Review',
    tamilLabel: 'மறுபரிசீலனை',
    backgroundColor: AppColors.tcsReview,
    textColor: Colors.white,
    borderColor: AppColors.tcsReview,
  ),
  answeredReview(
    label: 'Answered & Review',
    tamilLabel: 'விடையளித்து மறுபரிசீலனை',
    backgroundColor: AppColors.tcsAnsweredReview,
    textColor: Colors.white,
    borderColor: AppColors.tcsAnsweredReview,
  );

  final String label;
  final String tamilLabel;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const QuestionStatus({
    required this.label,
    required this.tamilLabel,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });
}
