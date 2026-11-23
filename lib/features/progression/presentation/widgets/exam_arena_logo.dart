import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Official Exam Arena CBT Brand Logo Widget.
///
/// Implements "Concept 2: Prismatic Target & Golden Stylus" on a pure white ceramic squircle base:
/// - Pure White ceramic squircle canvas with subtle platinum border and soft drop shadow.
/// - Concentric frosted precision target rings in vibrant electric violet and cyan.
/// - Dead-center razor-sharp champagne gold digital stylus / quill nib locking the bullseye.
class ExamArenaLogo extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;
  final bool showText;
  final String? subtitle;

  const ExamArenaLogo({
    super.key,
    this.size = 32.0,
    this.onTap,
    this.showText = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final logoSquircle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: math.max(1.0, size * 0.035),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.06),
          ),
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
            blurRadius: size * 0.35,
            spreadRadius: -size * 0.05,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.26),
        child: CustomPaint(
          size: Size(size, size),
          painter: const PrismaticTargetPainter(),
        ),
      ),
    );

    final interactiveLogo = onTap != null
        ? Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(size * 0.28),
              child: logoSquircle,
            ),
          )
        : logoSquircle;

    if (!showText) {
      return interactiveLogo;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        interactiveLogo,
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exam Arena',
              style: TextStyle(
                fontSize: size * 0.46,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                letterSpacing: -0.3,
                height: 1.1,
              ),
            ),
            Text(
              subtitle ?? 'CBT Mock Suite',
              style: TextStyle(
                fontSize: size * 0.3,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// CustomPainter rendering the official Prismatic Target & Golden Stylus vector glyph.
class PrismaticTargetPainter extends CustomPainter {
  const PrismaticTargetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    // 1. Outer Precision Calibration Ring (Electric Violet / Purple)
    final outerPaint = Paint()
      ..color = const Color(0xFF7C3AED).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, size.width * 0.035);

    final outerRadius = maxRadius * 0.82;
    canvas.drawCircle(center, outerRadius, outerPaint);

    // 2. Calibration Crosshair Reticle Ticks
    final tickPaint = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..strokeWidth = math.max(1.0, size.width * 0.04)
      ..strokeCap = StrokeCap.round;

    final tickLength = size.width * 0.09;
    // Top, Bottom, Left, Right Ticks
    canvas.drawLine(
      Offset(center.dx, center.dy - outerRadius - tickLength * 0.4),
      Offset(center.dx, center.dy - outerRadius + tickLength * 0.6),
      tickPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + outerRadius - tickLength * 0.6),
      Offset(center.dx, center.dy + outerRadius + tickLength * 0.4),
      tickPaint,
    );
    canvas.drawLine(
      Offset(center.dx - outerRadius - tickLength * 0.4, center.dy),
      Offset(center.dx - outerRadius + tickLength * 0.6, center.dy),
      tickPaint,
    );
    canvas.drawLine(
      Offset(center.dx + outerRadius - tickLength * 0.6, center.dy),
      Offset(center.dx + outerRadius + tickLength * 0.4, center.dy),
      tickPaint,
    );

    // 3. Middle Frosted Glass Ring (Electric Cyan / Azure with gradient feel)
    final middlePaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          Color(0xFF06B6D4),
          Color(0xFF38BDF8),
          Color(0xFF0EA5E9),
          Color(0xFF06B6D4),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius * 0.58))
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, size.width * 0.065);

    canvas.drawCircle(center, maxRadius * 0.56, middlePaint);

    // 4. Inner Golden Bullseye Focus Ring (Champagne Gold / Amber)
    final innerPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, size.width * 0.05);

    canvas.drawCircle(center, maxRadius * 0.32, innerPaint);

    // 5. Razor-Sharp Champagne Gold Digital Stylus / Quill Nib locked dead-center
    final quillPath = Path();
    final nibScale = size.width * 0.01;

    // Aerodynamic stylus nib pointing upward with razor-sharp tip
    final tipY = center.dy - 12 * nibScale;
    final baseY = center.dy + 8 * nibScale;
    final leftX = center.dx - 6 * nibScale;
    final rightX = center.dx + 6 * nibScale;

    quillPath.moveTo(center.dx, tipY);
    quillPath.lineTo(rightX, baseY);
    quillPath.lineTo(center.dx, baseY - 3 * nibScale);
    quillPath.lineTo(leftX, baseY);
    quillPath.close();

    final quillFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFBBF24), // Bright Amber / Gold Tip
          Color(0xFFD97706), // Rich Champagne Gold Body
        ],
      ).createShader(Rect.fromLTRB(leftX, tipY, rightX, baseY))
      ..style = PaintingStyle.fill;

    canvas.drawPath(quillPath, quillFill);

    // Ink slit / core line down the center of the stylus
    final slitPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..strokeWidth = math.max(0.7, size.width * 0.02)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx, tipY + 3 * nibScale),
      Offset(center.dx, baseY - 4 * nibScale),
      slitPaint,
    );

    // Bullseye center micro-dot (Gold & Violet)
    final dotPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx, baseY - 4 * nibScale), 1.2 * nibScale, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
