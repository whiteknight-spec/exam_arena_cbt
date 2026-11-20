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

/// Represents individual sub-level badges within PUBG Tiers.
/// - Bronze, Silver, Gold have 3 levels (e.g. Gold 1, Gold 2, Gold 3).
/// - Remaining tiers (Platinum, Diamond, Crown, Ace, Conqueror) have 4 levels each.
/// Badges unlock one-by-one as the candidate earns XP.
class PubgSubTier {
  final String id;
  final PubgTier tier;
  final int level; // 1, 2, 3 or 4
  final int minXp;
  final int maxXp;
  final String title;
  final String badgeSubtitle;
  final String perkDescription;

  const PubgSubTier({
    required this.id,
    required this.tier,
    required this.level,
    required this.minXp,
    required this.maxXp,
    required this.title,
    required this.badgeSubtitle,
    required this.perkDescription,
  });

  bool isUnlocked(int currentXp) => currentXp >= minXp;
  bool isCurrent(int currentXp) => currentXp >= minXp && currentXp <= maxXp;

  static final List<PubgSubTier> allBadges = [
    // Bronze: 3 levels (0 - 499 XP)
    const PubgSubTier(
      id: 'bronze_1',
      tier: PubgTier.bronze,
      level: 1,
      minXp: 0,
      maxXp: 149,
      title: 'Bronze 1',
      badgeSubtitle: 'Aspirant Novice',
      perkDescription: 'Initiation into CBT Mock Drills & Daily Streaks',
    ),
    const PubgSubTier(
      id: 'bronze_2',
      tier: PubgTier.bronze,
      level: 2,
      minXp: 150,
      maxXp: 299,
      title: 'Bronze 2',
      badgeSubtitle: 'Topic Explorer',
      perkDescription: 'Speed practice across Quantitative & Reasoning sections',
    ),
    const PubgSubTier(
      id: 'bronze_3',
      tier: PubgTier.bronze,
      level: 3,
      minXp: 300,
      maxXp: 499,
      title: 'Bronze 3',
      badgeSubtitle: 'Foundation Master',
      perkDescription: 'Mastery of foundational concepts ready for Silver promotion',
    ),

    // Silver: 3 levels (500 - 999 XP)
    const PubgSubTier(
      id: 'silver_1',
      tier: PubgTier.silver,
      level: 1,
      minXp: 500,
      maxXp: 649,
      title: 'Silver 1',
      badgeSubtitle: 'Timed Runner',
      perkDescription: 'Unlocks Sectional Timers with speed-run countdowns',
    ),
    const PubgSubTier(
      id: 'silver_2',
      tier: PubgTier.silver,
      level: 2,
      minXp: 650,
      maxXp: 799,
      title: 'Silver 2',
      badgeSubtitle: 'Accuracy Tactician',
      perkDescription: 'Maintains ≥ 70% accuracy threshold on bilingual drills',
    ),
    const PubgSubTier(
      id: 'silver_3',
      tier: PubgTier.silver,
      level: 3,
      minXp: 800,
      maxXp: 999,
      title: 'Silver 3',
      badgeSubtitle: 'Elite Driller',
      perkDescription: 'Ready to ascend to Gold Battle Arena',
    ),

    // Gold: 3 levels (1000 - 1999 XP)
    const PubgSubTier(
      id: 'gold_1',
      tier: PubgTier.gold,
      level: 1,
      minXp: 1000,
      maxXp: 1299,
      title: 'Gold 1',
      badgeSubtitle: 'Mock Battler',
      perkDescription: 'Full CBT TCS iON Mock Hall with authentic negative marking',
    ),
    const PubgSubTier(
      id: 'gold_2',
      tier: PubgTier.gold,
      level: 2,
      minXp: 1300,
      maxXp: 1599,
      title: 'Gold 2',
      badgeSubtitle: 'Speed Striker',
      perkDescription: 'Sub-45s average answering speed with 80%+ accuracy',
    ),
    const PubgSubTier(
      id: 'gold_3',
      tier: PubgTier.gold,
      level: 3,
      minXp: 1600,
      maxXp: 1999,
      title: 'Gold 3',
      badgeSubtitle: 'Veteran Candidate',
      perkDescription: 'Top tier competitive readiness for Platinum promotions',
    ),

    // Platinum: 4 levels (2000 - 3499 XP)
    const PubgSubTier(
      id: 'platinum_1',
      tier: PubgTier.platinum,
      level: 1,
      minXp: 2000,
      maxXp: 2349,
      title: 'Platinum 1',
      badgeSubtitle: 'Adaptive Challenger',
      perkDescription: 'Unlocks AI Gauntlet dynamic questions calibrated to weak areas',
    ),
    const PubgSubTier(
      id: 'platinum_2',
      tier: PubgTier.platinum,
      level: 2,
      minXp: 2350,
      maxXp: 2699,
      title: 'Platinum 2',
      badgeSubtitle: 'Discipline Specialist',
      perkDescription: 'Zero penalty test runs with pristine stamina management',
    ),
    const PubgSubTier(
      id: 'platinum_3',
      tier: PubgTier.platinum,
      level: 3,
      minXp: 2700,
      maxXp: 3099,
      title: 'Platinum 3',
      badgeSubtitle: 'Pressure Victor',
      perkDescription: 'High score in sectional timer lock pressure simulations',
    ),
    const PubgSubTier(
      id: 'platinum_4',
      tier: PubgTier.platinum,
      level: 4,
      minXp: 3100,
      maxXp: 3499,
      title: 'Platinum 4',
      badgeSubtitle: 'Grand Strategist',
      perkDescription: 'Prime contender for Diamond tier championship',
    ),

    // Diamond: 4 levels (3500 - 4999 XP)
    const PubgSubTier(
      id: 'diamond_1',
      tier: PubgTier.diamond,
      level: 1,
      minXp: 3500,
      maxXp: 3849,
      title: 'Diamond 1',
      badgeSubtitle: 'Diamond Vanguard',
      perkDescription: 'Sub-35s solving tempo on Quantitative Aptitude',
    ),
    const PubgSubTier(
      id: 'diamond_2',
      tier: PubgTier.diamond,
      level: 2,
      minXp: 3850,
      maxXp: 4199,
      title: 'Diamond 2',
      badgeSubtitle: 'Precision Sharpshooter',
      perkDescription: '≥ 85% accuracy on Logical Reasoning and General Awareness',
    ),
    const PubgSubTier(
      id: 'diamond_3',
      tier: PubgTier.diamond,
      level: 3,
      minXp: 4200,
      maxXp: 4599,
      title: 'Diamond 3',
      badgeSubtitle: 'Speed Master',
      perkDescription: 'Flawless question palette navigation and review management',
    ),
    const PubgSubTier(
      id: 'diamond_4',
      tier: PubgTier.diamond,
      level: 4,
      minXp: 4600,
      maxXp: 4999,
      title: 'Diamond 4',
      badgeSubtitle: 'Apex Diamond',
      perkDescription: 'State-level competitive readiness on official syllabus',
    ),

    // Crown: 4 levels (5000 - 7499 XP)
    const PubgSubTier(
      id: 'crown_1',
      tier: PubgTier.crown,
      level: 1,
      minXp: 5000,
      maxXp: 5599,
      title: 'Crown 1',
      badgeSubtitle: 'Crown Aspirant',
      perkDescription: 'Top 5% percentile performance across full-length papers',
    ),
    const PubgSubTier(
      id: 'crown_2',
      tier: PubgTier.crown,
      level: 2,
      minXp: 5600,
      maxXp: 6199,
      title: 'Crown 2',
      badgeSubtitle: 'Imperial Sentinel',
      perkDescription: 'Mastery of TNPSC 5-option format and negative marking',
    ),
    const PubgSubTier(
      id: 'crown_3',
      tier: PubgTier.crown,
      level: 3,
      minXp: 6200,
      maxXp: 6799,
      title: 'Crown 3',
      badgeSubtitle: 'Royal Commander',
      perkDescription: 'Consistent top accuracy scores in Railways & SSC simulations',
    ),
    const PubgSubTier(
      id: 'crown_4',
      tier: PubgTier.crown,
      level: 4,
      minXp: 6800,
      maxXp: 7499,
      title: 'Crown 4',
      badgeSubtitle: 'Crown Sovereign',
      perkDescription: 'Entry gate to the legendary Ace arena',
    ),

    // Ace: 4 levels (7500 - 9999 XP)
    const PubgSubTier(
      id: 'ace_1',
      tier: PubgTier.ace,
      level: 1,
      minXp: 7500,
      maxXp: 8099,
      title: 'Ace 1',
      badgeSubtitle: 'Ace Dominator',
      perkDescription: 'Top 2% candidate with lightning-fast recall and accuracy',
    ),
    const PubgSubTier(
      id: 'ace_2',
      tier: PubgTier.ace,
      level: 2,
      minXp: 8100,
      maxXp: 8699,
      title: 'Ace 2',
      badgeSubtitle: 'Ace Strategist',
      perkDescription: '≥ 90% accuracy in Banking Clerk and PO speed tests',
    ),
    const PubgSubTier(
      id: 'ace_3',
      tier: PubgTier.ace,
      level: 3,
      minXp: 8700,
      maxXp: 9299,
      title: 'Ace 3',
      badgeSubtitle: 'Ace Grandmaster',
      perkDescription: 'Unshakeable exam hall stamina with zero penalties',
    ),
    const PubgSubTier(
      id: 'ace_4',
      tier: PubgTier.ace,
      level: 4,
      minXp: 9300,
      maxXp: 9999,
      title: 'Ace 4',
      badgeSubtitle: 'Supreme Ace',
      perkDescription: 'Final stage before reaching the ultimate Conqueror Apex',
    ),

    // Conqueror: 4 levels (10000+ XP)
    const PubgSubTier(
      id: 'conqueror_1',
      tier: PubgTier.conqueror,
      level: 1,
      minXp: 10000,
      maxXp: 12499,
      title: 'Conqueror 1',
      badgeSubtitle: 'Apex Conqueror',
      perkDescription: 'State Rank 1 caliber in competitive exams',
    ),
    const PubgSubTier(
      id: 'conqueror_2',
      tier: PubgTier.conqueror,
      level: 2,
      minXp: 12500,
      maxXp: 14999,
      title: 'Conqueror 2',
      badgeSubtitle: 'Legendary Conqueror',
      perkDescription: 'Flawless execution under national testing conditions',
    ),
    const PubgSubTier(
      id: 'conqueror_3',
      tier: PubgTier.conqueror,
      level: 3,
      minXp: 15000,
      maxXp: 19999,
      title: 'Conqueror 3',
      badgeSubtitle: 'Mythic Champion',
      perkDescription: 'Top percentile national ranker',
    ),
    const PubgSubTier(
      id: 'conqueror_4',
      tier: PubgTier.conqueror,
      level: 4,
      minXp: 20000,
      maxXp: 999999,
      title: 'Conqueror 4',
      badgeSubtitle: 'Apex Titan',
      perkDescription: 'The pinnacle of competitive excellence, ready for appointment letter',
    ),
  ];

  static PubgSubTier fromXp(int xp) {
    for (final b in allBadges) {
      if (xp >= b.minXp && xp <= b.maxXp) {
        return b;
      }
    }
    return allBadges.last;
  }

  PubgSubTier? get nextBadge {
    final idx = allBadges.indexOf(this);
    if (idx >= 0 && idx < allBadges.length - 1) {
      return allBadges[idx + 1];
    }
    return null;
  }

  int xpNeededForNext(int currentXp) {
    final next = nextBadge;
    if (next == null) return 0;
    return (next.minXp - currentXp).clamp(0, 999999);
  }

  int xpNeeded(int currentXp) => xpNeededForNext(currentXp);

  double progressToNext(int currentXp) {
    final next = nextBadge;
    if (next == null) return 1.0;
    final totalSpan = next.minXp - minXp;
    if (totalSpan <= 0) return 1.0;
    return ((currentXp - minXp) / totalSpan).clamp(0.0, 1.0);
  }
}
