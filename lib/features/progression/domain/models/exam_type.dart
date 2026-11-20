enum ExamType {
  rrbNtpc(
    id: 'rrb_ntpc',
    title: 'RRB NTPC',
    subtitle: 'Railways Non-Technical Popular Categories (CBT 1 & 2)',
    totalQuestions: 100,
    totalDurationMinutes: 90, // 90 mins
    positiveMark: 1.0,
    negativeMark: 0.33, // -0.33 marking
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: false,
    sectionalLockDurationMinutes: 0,
    supportsBilingual: true,
    badgeColorHex: 0xFF2563EB, // Royal Blue
  ),
  sscCgl(
    id: 'ssc_cgl',
    title: 'SSC CGL Tier 1',
    subtitle: 'Staff Selection Commission Combined Graduate Level',
    totalQuestions: 100,
    totalDurationMinutes: 60, // 60 mins
    positiveMark: 2.0,
    negativeMark: 0.50, // -0.50 marking
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: true,
    sectionalLockDurationMinutes: 15, // 15-min auto-locking sections
    supportsBilingual: true,
    badgeColorHex: 0xFF7C3AED, // Violet
  ),
  tnpscGroup2And4(
    id: 'tnpsc_group_2_4',
    title: 'TNPSC Group 2 & Group 4',
    subtitle: 'Tamil Nadu Combined Civil Services Examination',
    totalQuestions: 200,
    totalDurationMinutes: 180, // 180 mins
    positiveMark: 1.5,
    negativeMark: 0.0, // 0 negative marking
    totalOptions: 5,
    hasOptionE: true, // 5 options A–E where E = Answer Not Known / விடை தெரியவில்லை
    hasSectionalLock: false,
    sectionalLockDurationMinutes: 0,
    supportsBilingual: true,
    badgeColorHex: 0xFF059669, // Emerald Green
  ),
  ibpsSbiClerk(
    id: 'ibps_sbi_clerk',
    title: 'IBPS / SBI Clerk',
    subtitle: 'Clerical Cadre Preliminary CBT (English, Quant, Reasoning)',
    totalQuestions: 100,
    totalDurationMinutes: 60, // 60 mins
    positiveMark: 1.0,
    negativeMark: 0.25, // -0.25 marking
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: true,
    sectionalLockDurationMinutes: 20, // 20-min sectional lock
    supportsBilingual: true,
    badgeColorHex: 0xFFD97706, // Amber
  );

  final String id;
  final String title;
  final String subtitle;
  final int totalQuestions;
  final int totalDurationMinutes;
  final double positiveMark;
  final double negativeMark;
  final int totalOptions;
  final bool hasOptionE;
  final bool hasSectionalLock;
  final int sectionalLockDurationMinutes;
  final bool supportsBilingual;
  final int badgeColorHex;

  const ExamType({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.totalQuestions,
    required this.totalDurationMinutes,
    required this.positiveMark,
    required this.negativeMark,
    required this.totalOptions,
    required this.hasOptionE,
    required this.hasSectionalLock,
    required this.sectionalLockDurationMinutes,
    required this.supportsBilingual,
    required this.badgeColorHex,
  });

  int get totalDurationSeconds => totalDurationMinutes * 60;
  int get sectionalLockDurationSeconds => sectionalLockDurationMinutes * 60;
  double get maximumMarks => totalQuestions * positiveMark;
}
