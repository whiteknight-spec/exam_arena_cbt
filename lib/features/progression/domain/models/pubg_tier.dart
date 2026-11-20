import 'package:flutter/material.dart';

enum PubgTier {
  bronze(
    id: 'bronze',
    title: 'Bronze',
    tamilTitle: 'வெண்கலம்',
    minXp: 0,
    maxXp: 499,
    tierRoman: 'I',
    primaryColor: Color(0xFFCD7F32),
    secondaryColor: Color(0xFF8C531B),
    accentColor: Color(0xFFFED7AA),
    glowColor: Color(0xFF9A3412),
    badgeSubtitle: 'Rookie Aspirant',
    tamilSubtitle: 'தொடக்க நிலை ஆர்வலர்',
    perkDescription: 'Access to Level 1: Topic Speed Sprints & Offline Practice',
  ),
  silver(
    id: 'silver',
    title: 'Silver',
    tamilTitle: 'வெள்ளி',
    minXp: 500,
    maxXp: 999,
    tierRoman: 'II',
    primaryColor: Color(0xFF94A3B8),
    secondaryColor: Color(0xFF475569),
    accentColor: Color(0xFFF1F5F9),
    glowColor: Color(0xFF64748B),
    badgeSubtitle: 'Drill Specialist',
    tamilSubtitle: 'பிரிவு பயிற்சியாளர்',
    perkDescription: 'Unlocks Level 2: Sectional Timed Drills with Auto-Locking Timers',
  ),
  gold(
    id: 'gold',
    title: 'Gold',
    tamilTitle: 'தங்கம்',
    minXp: 1000,
    maxXp: 1999,
    tierRoman: 'III',
    primaryColor: Color(0xFFF59E0B),
    secondaryColor: Color(0xFFB45309),
    accentColor: Color(0xFFFEF3C7),
    glowColor: Color(0xFFD97706),
    badgeSubtitle: 'Mock Battler',
    tamilSubtitle: 'முழு மாதிரித் தேர்வு வீரர்',
    perkDescription: 'Unlocks Level 3: Full TCS iON CBT Mock Arena with Real Marking',
  ),
  platinum(
    id: 'platinum',
    title: 'Platinum',
    tamilTitle: 'பிளாட்டினம்',
    minXp: 2000,
    maxXp: 3499,
    tierRoman: 'IV',
    primaryColor: Color(0xFF06B6D4),
    secondaryColor: Color(0xFF0E7490),
    accentColor: Color(0xFFCFFAFE),
    glowColor: Color(0xFF0891B2),
    badgeSubtitle: 'Elite Challenger',
    tamilSubtitle: 'முன்னணி சவாலாளர்',
    perkDescription: 'Unlocks Level 4: Gemini AI Adaptive Boss Gauntlet & Weak Topic Drills',
  ),
  diamond(
    id: 'diamond',
    title: 'Diamond',
    tamilTitle: 'வைரம்',
    minXp: 3500,
    maxXp: 4999,
    tierRoman: 'V',
    primaryColor: Color(0xFF38BDF8),
    secondaryColor: Color(0xFF0369A1),
    accentColor: Color(0xFFE0F2FE),
    glowColor: Color(0xFF0284C7),
    badgeSubtitle: 'Master Tactician',
    tamilSubtitle: 'துல்லிய மாஸ்டர்',
    perkDescription: 'Achieves high-speed question solving with sub-45s per MCQ accuracy',
  ),
  crown(
    id: 'crown',
    title: 'Crown',
    tamilTitle: 'கிரீடம்',
    minXp: 5000,
    maxXp: 7499,
    tierRoman: 'VI',
    primaryColor: Color(0xFFA855F7),
    secondaryColor: Color(0xFF6B21A8),
    accentColor: Color(0xFFF3E8FF),
    glowColor: Color(0xFF9333EA),
    badgeSubtitle: 'Imperial Legend',
    tamilSubtitle: 'முடிசூடா மன்னன்',
    perkDescription: 'Top 5% percentile candidate with flawless time-management',
  ),
  ace(
    id: 'ace',
    title: 'Ace',
    tamilTitle: 'ஏஸ்',
    minXp: 7500,
    maxXp: 9999,
    tierRoman: 'VII',
    primaryColor: Color(0xFFEF4444),
    secondaryColor: Color(0xFF991B1B),
    accentColor: Color(0xFFFEE2E2),
    glowColor: Color(0xFFDC2626),
    badgeSubtitle: 'Ace Dominator',
    tamilSubtitle: 'ஏஸ் வெற்றியாளர்',
    perkDescription: 'Consistent 85%+ score across SSC, RRB, and TNPSC mock simulations',
  ),
  conqueror(
    id: 'conqueror',
    title: 'Conqueror',
    tamilTitle: 'வெற்றியாளர்',
    minXp: 10000,
    maxXp: 999999,
    tierRoman: 'VIII',
    primaryColor: Color(0xFFFBBF24),
    secondaryColor: Color(0xFF78350F),
    accentColor: Color(0xFFFFFBEB),
    glowColor: Color(0xFFF59E0B),
    badgeSubtitle: 'State Rank 1 Apex',
    tamilSubtitle: 'மாநில முதலிடம் சாதனையாளர்',
    perkDescription: 'The pinnacle of competitive excellence ready for appointment letter',
  );

  final String id;
  final String title;
  final String tamilTitle;
  final int minXp;
  final int maxXp;
  final String tierRoman;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color glowColor;
  final String badgeSubtitle;
  final String tamilSubtitle;
  final String perkDescription;

  const PubgTier({
    required this.id,
    required this.title,
    required this.tamilTitle,
    required this.minXp,
    required this.maxXp,
    required this.tierRoman,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.glowColor,
    required this.badgeSubtitle,
    required this.tamilSubtitle,
    required this.perkDescription,
  });

  static PubgTier fromXp(int xp) {
    if (xp >= conqueror.minXp) return conqueror;
    if (xp >= ace.minXp) return ace;
    if (xp >= crown.minXp) return crown;
    if (xp >= diamond.minXp) return diamond;
    if (xp >= platinum.minXp) return platinum;
    if (xp >= gold.minXp) return gold;
    if (xp >= silver.minXp) return silver;
    return bronze;
  }

  PubgTier? get nextTier {
    final values = PubgTier.values;
    final currentIndex = values.indexOf(this);
    if (currentIndex < values.length - 1) {
      return values[currentIndex + 1];
    }
    return null;
  }

  int xpNeededForNextTier(int currentXp) {
    final next = nextTier;
    if (next == null) return 0;
    return (next.minXp - currentXp).clamp(0, 999999);
  }

  double progressToNextTier(int currentXp) {
    final next = nextTier;
    if (next == null) return 1.0;
    final totalSpan = next.minXp - minXp;
    if (totalSpan <= 0) return 1.0;
    final progress = (currentXp - minXp) / totalSpan;
    return progress.clamp(0.0, 1.0);
  }

  bool isUnlocked(int currentXp) => currentXp >= minXp;
}
