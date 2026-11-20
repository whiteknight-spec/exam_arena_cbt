import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/user_progress.dart';
import '../providers/progression_provider.dart';

class HeartsRefillModal extends ConsumerWidget {
  const HeartsRefillModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const HeartsRefillModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressionProvider);
    final notifier = ref.read(progressionProvider.notifier);
    final hearts = progress.currentHearts;
    final timeRemaining = progress.timeUntilNextHeart;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Drag handle
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_rounded, color: Color(0xFFE11D48), size: 24),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Exam Lives & Stamina',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'ExamArena CBT uses a 5-Life Discipline System to keep candidates serious and prevent casual guesswork.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
              ),
              const SizedBox(height: 20),

              // 5 Hearts Visual Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(UserProgress.maxHearts, (index) {
                  final isFilled = index < hearts;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isFilled ? const Color(0xFFFFF1F2) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isFilled ? const Color(0xFFFDA4AF) : const Color(0xFFCBD5E1),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isFilled ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFilled ? const Color(0xFFE11D48) : const Color(0xFF94A3B8),
                      size: 26,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),

              // Current Status Text & Auto-Regen Timer
              if (hearts < UserProgress.maxHearts) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFE11D48)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Next Life (+1 ❤️) in ${timeRemaining.inMinutes}m ${(timeRemaining.inSeconds % 60).toString().padLeft(2, '0')}s',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFBE123C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF059669)),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Full Stamina (5/5 Lives) • Ready for Mock Exam!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF065F46),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

          // Rules Explanatory Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              children: [
                _RuleRow(
                  icon: Icons.exit_to_app_rounded,
                  color: Color(0xFFDC2626),
                  title: 'Quitting active exam midway',
                  sub: 'Loses 1 Life (-1 ❤️)',
                ),
                SizedBox(height: 8),
                _RuleRow(
                  icon: Icons.dangerous_outlined,
                  color: Color(0xFFD97706),
                  title: 'Heavy negative marking (<40% accuracy)',
                  sub: 'Loses 1 Life (-1 ❤️)',
                ),
                SizedBox(height: 8),
                _RuleRow(
                  icon: Icons.shield_rounded,
                  color: Color(0xFF059669),
                  title: 'Scoring ≥ 70% accuracy',
                  sub: 'Zero Lives lost + Full XP',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action 1: Instant Refill with XP (Cost: 50 XP)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE11D48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.bolt, color: Colors.white),
              label: Text(
                'Instant Full Refill (Cost: 50 XP • Balance: ${progress.xp} XP)',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
              onPressed: hearts >= UserProgress.maxHearts
                  ? null
                  : () async {
                      if (progress.xp >= 50) {
                        await notifier.refillHeartsWithXp(costXp: 50);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('❤️❤️❤️❤️❤️ Full Stamina Restored! Ready for battle.'),
                              backgroundColor: Color(0xFF059669),
                            ),
                          );
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Not enough XP! Complete drills to earn XP or wait for auto-refill.'),
                            backgroundColor: Color(0xFFDC2626),
                          ),
                        );
                      }
                    },
            ),
          ),
          const SizedBox(height: 10),

          // Action 2: Practice Revision to Heal (+1 Heart)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE11D48)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.healing_rounded, color: Color(0xFFE11D48), size: 18),
              label: const Text(
                'Mistake Revision Drill (+1 Heart Heal)',
                style: TextStyle(
                  color: Color(0xFFE11D48),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              onPressed: hearts >= UserProgress.maxHearts
                  ? null
                  : () async {
                      await notifier.healOneHeart();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('+1 Life Restored! ❤️ Practice makes perfect.'),
                            backgroundColor: Color(0xFFE11D48),
                          ),
                        );
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      }
                    },
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String sub;

  const _RuleRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
        Text(
          sub,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color),
        ),
      ],
    );
  }
}
