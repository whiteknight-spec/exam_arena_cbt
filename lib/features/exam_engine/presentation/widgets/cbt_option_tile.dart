import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class CbtOptionTile extends StatelessWidget {
  final int index; // 0..4
  final String text;
  final bool isSelected;
  final bool isOptionE;
  final bool isTamil;
  final double fontScale;
  final VoidCallback onTap;

  const CbtOptionTile({
    super.key,
    required this.index,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isOptionE = false,
    this.isTamil = false,
    this.fontScale = 1.0,
  });

  String get optionLetter {
    switch (index) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return 'C';
      case 3:
        return 'D';
      case 4:
        return 'E';
      default:
        return '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getTileBorderColor() {
      if (isSelected) {
        return isOptionE ? const Color(0xFFD97706) : AppColors.primary;
      }
      return isOptionE ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0);
    }

    Color getTileBgColor() {
      if (isSelected) {
        return isOptionE ? const Color(0xFFFFFBEB) : const Color(0xFFEFF6FF);
      }
      return isOptionE ? const Color(0xFFFAFAF9) : Colors.white;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: getTileBgColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: getTileBorderColor(),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: (isOptionE ? const Color(0xFFD97706) : AppColors.primary)
                      .withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Authentic OMR Radio Bubble
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isOptionE ? const Color(0xFFD97706) : AppColors.primary)
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? (isOptionE ? const Color(0xFFD97706) : AppColors.primary)
                          : const Color(0xFF94A3B8),
                      width: isSelected ? 2.0 : 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      optionLetter,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Option Text Content & Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isOptionE)
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: const Text(
                            'TNPSC Option E: Answer Not Known (விடை தெரியவில்லை)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                      Text(
                        text,
                        style: AppTheme.bilingualTextStyle(
                          isTamil: isTamil,
                          fontSize: 14 * fontScale,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? (isOptionE ? const Color(0xFF92400E) : AppColors.primary)
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkmark indicator when selected
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: isOptionE ? const Color(0xFFD97706) : AppColors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
