import 'package:flutter/material.dart';
import '../../domain/models/pubg_tier.dart';

enum PubgBadgeSize {
  small(width: 44, height: 52, iconSize: 18, fontSize: 8),
  medium(width: 76, height: 90, iconSize: 30, fontSize: 10),
  large(width: 140, height: 164, iconSize: 56, fontSize: 14);

  final double width;
  final double height;
  final double iconSize;
  final double fontSize;

  const PubgBadgeSize({
    required this.width,
    required this.height,
    required this.iconSize,
    required this.fontSize,
  });
}

class PubgTierBadge extends StatelessWidget {
  final PubgTier tier;
  final PubgBadgeSize size;
  final bool isLocked;
  final bool showGlow;
  final VoidCallback? onTap;

  const PubgTierBadge({
    super.key,
    required this.tier,
    this.size = PubgBadgeSize.medium,
    this.isLocked = false,
    this.showGlow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePrimary = isLocked ? const Color(0xFF64748B) : tier.primaryColor;
    final effectiveSecondary = isLocked ? const Color(0xFF334155) : tier.secondaryColor;
    final effectiveAccent = isLocked ? const Color(0xFF94A3B8) : tier.accentColor;
    final effectiveGlow = isLocked ? Colors.transparent : tier.glowColor;

    Widget badgeContent = SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Custom Painted Metallic Shield with Bevels and Rivets
          CustomPaint(
            size: Size(size.width, size.height),
            painter: _PubgShieldPainter(
              primaryColor: effectivePrimary,
              secondaryColor: effectiveSecondary,
              accentColor: effectiveAccent,
              glowColor: effectiveGlow,
              showGlow: showGlow && !isLocked,
              isLocked: isLocked,
            ),
          ),

          // 2. Custom Distinctive Emblem per Tier
          Positioned(
            top: size.height * 0.18,
            child: _buildTierEmblem(effectiveAccent, effectivePrimary),
          ),

          // 3. Lower Ribbon Plaque with Tier Title
          Positioned(
            bottom: size.height * 0.08,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size == PubgBadgeSize.large ? 10 : 5,
                vertical: size == PubgBadgeSize.large ? 3 : 1.5,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    effectiveSecondary,
                    effectivePrimary,
                    effectiveSecondary,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: effectiveAccent.withValues(alpha: 0.8),
                  width: size == PubgBadgeSize.large ? 1.5 : 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                isLocked ? 'LOCKED' : tier.title.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: size.fontSize,
                  letterSpacing: size == PubgBadgeSize.large ? 1.2 : 0.6,
                ),
              ),
            ),
          ),

          // 4. Lock Overlay Icon if Locked
          if (isLocked)
            Positioned(
              top: size.height * 0.35,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: size.iconSize * 0.7,
                  color: Colors.white70,
                ),
              ),
            ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: badgeContent,
      );
    }
    return badgeContent;
  }

  Widget _buildTierEmblem(Color accent, Color primary) {
    final iconColor = isLocked ? Colors.white54 : accent;
    final iconSize = size.iconSize;

    switch (tier) {
      case PubgTier.bronze:
        return Icon(Icons.shield_outlined, size: iconSize, color: iconColor);
      case PubgTier.silver:
        return Icon(Icons.military_tech_rounded, size: iconSize, color: iconColor);
      case PubgTier.gold:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.star_rate_rounded, size: iconSize * 1.1, color: isLocked ? Colors.white38 : Colors.amber.shade200),
            Icon(Icons.grade_rounded, size: iconSize * 0.7, color: iconColor),
          ],
        );
      case PubgTier.platinum:
        return Icon(Icons.diamond_outlined, size: iconSize, color: iconColor);
      case PubgTier.diamond:
        return Icon(Icons.diamond_rounded, size: iconSize, color: iconColor);
      case PubgTier.crown:
        return Icon(Icons.workspace_premium_rounded, size: iconSize * 1.1, color: iconColor);
      case PubgTier.ace:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.local_fire_department_rounded, size: iconSize * 1.15, color: isLocked ? Colors.white38 : const Color(0xFFFCA5A5)),
            Icon(Icons.military_tech_rounded, size: iconSize * 0.75, color: iconColor),
          ],
        );
      case PubgTier.conqueror:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.flare_rounded, size: iconSize * 1.25, color: isLocked ? Colors.white38 : Colors.amber.shade300),
            Icon(Icons.emoji_events_rounded, size: iconSize * 0.8, color: iconColor),
          ],
        );
    }
  }
}

class _PubgShieldPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color glowColor;
  final bool showGlow;
  final bool isLocked;

  const _PubgShieldPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.glowColor,
    required this.showGlow,
    required this.isLocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Draw Outer Glowing Aura
    if (showGlow) {
      final glowPaint = Paint()
        ..color = glowColor.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      final glowPath = _createShieldPath(w, h, 0);
      canvas.drawPath(glowPath, glowPaint);
    }

    // 2. Outer Shield Rim (Metallic Gradient)
    final outerPath = _createShieldPath(w, h, 0);
    final rimPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          accentColor,
          primaryColor,
          secondaryColor,
          primaryColor,
        ],
        stops: const [0.0, 0.35, 0.75, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;
    canvas.drawPath(outerPath, rimPaint);

    // 3. Inner Recessed Combat Core
    final innerInset = w * 0.08;
    final innerPath = _createShieldPath(w, h, innerInset);
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          secondaryColor.withValues(alpha: 0.95),
          const Color(0xFF0F172A),
        ],
        center: const Alignment(0, -0.2),
        radius: 0.8,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerPath, corePaint);

    // 4. Metallic Bevel Stroke
    final bevelPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.02;
    canvas.drawPath(innerPath, bevelPaint);

    // 5. Beveled Corner Rivets
    final rivetPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    final rivetRadius = w * 0.025;
    canvas.drawCircle(Offset(w * 0.18, h * 0.16), rivetRadius, rivetPaint);
    canvas.drawCircle(Offset(w * 0.82, h * 0.16), rivetRadius, rivetPaint);
  }

  Path _createShieldPath(double w, double h, double inset) {
    final path = Path();
    final top = inset;
    final bottom = h - inset;
    final left = inset;
    final right = w - inset;
    final centerX = w / 2;

    // Angular Combat Shield Profile:
    // Flat top with slight crown dip, angled shoulders, sharp downward taper to tip
    path.moveTo(centerX, top + (h * 0.04));
    path.lineTo(right - (w * 0.12), top);
    path.lineTo(right, top + (h * 0.22));
    path.lineTo(right - (w * 0.05), top + (h * 0.60));
    path.lineTo(centerX, bottom);
    path.lineTo(left + (w * 0.05), top + (h * 0.60));
    path.lineTo(left, top + (h * 0.22));
    path.lineTo(left + (w * 0.12), top);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant _PubgShieldPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.showGlow != showGlow ||
        oldDelegate.isLocked != isLocked;
  }
}
