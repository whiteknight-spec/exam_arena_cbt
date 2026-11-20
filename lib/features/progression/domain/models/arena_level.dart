enum ArenaLevel {
  level1(
    levelNumber: 1,
    title: '15-min Topic Speed Sprints',
    tamilTitle: '15 நிமிட தலைப்பு வேகத் தேர்வுகள்',
    description: 'Rapid 10-Question timed sprints to build speed, accuracy, and foundational concepts.',
    requiredXp: 0,
    icon: '⚡',
  ),
  level2(
    levelNumber: 2,
    title: 'Sectional Timed Drills',
    tamilTitle: 'பிரிவு வாரியான நேரக் கட்டுப்பாடு தேர்வுகள்',
    description: 'Auto-locking sectional deep-dives with exam-specific timers (Math, GK, Reasoning, English).',
    requiredXp: 500, // 500-XP progression tier
    icon: '🎯',
  ),
  level3(
    levelNumber: 3,
    title: 'Full-Length CBT Mocks',
    tamilTitle: 'முழுமையான CBT மாதிரி தேர்வு',
    description: 'Full-length CBT simulator matching official TCS iON interface, timer bars & marking rules.',
    requiredXp: 1000, // 500-XP progression tier
    icon: '🏆',
  ),
  level4(
    levelNumber: 4,
    title: 'AI Adaptive Boss Gauntlet',
    tamilTitle: 'AI ஜெமினி அடாப்டிவ் பாஸ் சவால்',
    description: 'Adaptive bilingual questions generated dynamically by Gemini 2.5 Flash for high-level mastery.',
    requiredXp: 1500, // 500-XP progression tier
    icon: '🤖',
  );

  final int levelNumber;
  final String title;
  final String tamilTitle;
  final String description;
  final int requiredXp;
  final String icon;

  const ArenaLevel({
    required this.levelNumber,
    required this.title,
    required this.tamilTitle,
    required this.description,
    required this.requiredXp,
    required this.icon,
  });

  bool isUnlocked(int currentXp) => currentXp >= requiredXp;
}
