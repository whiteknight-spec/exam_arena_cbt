import 'package:flutter/material.dart';

class AppColors {
  // Apple HIG Modern Minimalist Palette
  static const Color primary = Color(0xFF0071E3); // Apple System Blue
  static const Color primaryLight = Color(0xFF47A0FF);
  static const Color accent = Color(0xFFFF9500); // Apple System Amber / Orange
  static const Color background = Color(0xFFF5F5F7); // Apple Signature Clean Surface
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1D1D1F); // Apple Deep Charcoal
  static const Color textSecondary = Color(0xFF86868B); // Apple Subdued Caption
  static const Color border = Color(0xFFE5E5EA); // Apple Smooth Divider Border

  // TCS iON CBT Standard Palette
  static const Color tcsNotVisited = Color(0xFFE2E8F0); // Gray / Silver
  static const Color tcsNotVisitedText = Color(0xFF334155);
  static const Color tcsNotAnswered = Color(0xFFDC2626); // Bright Red
  static const Color tcsAnswered = Color(0xFF16A34A); // Forest Green
  static const Color tcsReview = Color(0xFF7C3AED); // Deep Violet / Purple
  static const Color tcsAnsweredReview = Color(0xFF9333EA); // Purple with green badge

  // Status Indicators
  static const Color timerNormal = Color(0xFF0284C7);
  static const Color timerWarning = Color(0xFFD97706);
  static const Color timerCritical = Color(0xFFDC2626);

  // Level Tiers
  static const Color level1Sprint = Color(0xFF0EA5E9);
  static const Color level2Sectional = Color(0xFF8B5CF6);
  static const Color level3FullCBT = Color(0xFFF97316);
  static const Color level4Gauntlet = Color(0xFFEC4899);
}
