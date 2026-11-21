import 'package:flutter/services.dart';

/// Centralized haptic feedback service to deliver crisp tactile interactions across the app.
class HapticFeedbackHelper {
  /// Subtle click for OMR bubble selection and chip toggles
  static void selectionClick() {
    try {
      HapticFeedback.selectionClick();
    } catch (_) {}
  }

  /// Gentle bump when moving between questions or closing scratchpad
  static void lightImpact() {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
  }

  /// Medium pulse for countdown timer warning (5-min remaining) and life deductions
  static void mediumImpact() {
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  /// Celebratory heavy vibration for leveling up, closing milestone, or healing hearts
  static void heavyImpact() {
    try {
      HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  /// Warning vibration on exit guard dialog or critical stamina depletion
  static void errorVibrate() {
    try {
      HapticFeedback.vibrate();
    } catch (_) {}
  }
}
