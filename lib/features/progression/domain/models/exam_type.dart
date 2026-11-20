enum ExamCategory {
  all(title: 'All Exams'),
  tnpsc(title: 'TNPSC & State'),
  railways(title: 'Railways (RRB)'),
  ssc(title: 'Staff Selection (SSC)'),
  banking(title: 'Banking & Insurance');

  final String title;
  const ExamCategory({required this.title});
}

enum ExamType {
  // Flagship 4 Exams (Universal Standards)
  rrbNtpc(
    id: 'rrb_ntpc',
    title: 'RRB NTPC',
    subtitle: 'Railways Non-Technical Popular Categories (CBT 1 & 2)',
    category: ExamCategory.railways,
    totalQuestions: 100,
    totalDurationMinutes: 90,
    positiveMark: 1.0,
    negativeMark: 0.33,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: false,
    sectionalLockDurationMinutes: 0,
    supportsBilingual: true,
    badgeColorHex: 0xFF0284C7,
  ),
  sscCgl(
    id: 'ssc_cgl',
    title: 'SSC CGL Tier 1',
    subtitle: 'Staff Selection Commission Combined Graduate Level',
    category: ExamCategory.ssc,
    totalQuestions: 100,
    totalDurationMinutes: 60,
    positiveMark: 2.0,
    negativeMark: 0.50,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: true,
    sectionalLockDurationMinutes: 15,
    supportsBilingual: true,
    badgeColorHex: 0xFF7C3AED,
  ),
  tnpscGroup2And4(
    id: 'tnpsc_group_2_4',
    title: 'TNPSC Group 2 & Group 4',
    subtitle: 'Tamil Nadu Combined Civil Services Examination',
    category: ExamCategory.tnpsc,
    totalQuestions: 200,
    totalDurationMinutes: 180,
    positiveMark: 1.5,
    negativeMark: 0.0,
    totalOptions: 5,
    hasOptionE: true,
    hasSectionalLock: false,
    sectionalLockDurationMinutes: 0,
    supportsBilingual: true,
    badgeColorHex: 0xFF059669,
  ),
  ibpsSbiClerk(
    id: 'ibps_sbi_clerk',
    title: 'IBPS / SBI Clerk',
    subtitle: 'Clerical Cadre Preliminary CBT (English, Quant, Reasoning)',
    category: ExamCategory.banking,
    totalQuestions: 100,
    totalDurationMinutes: 60,
    positiveMark: 1.0,
    negativeMark: 0.25,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: true,
    sectionalLockDurationMinutes: 20,
    supportsBilingual: true,
    badgeColorHex: 0xFFD97706,
  ),

  // Expanded Railways Exams
  rrbGroupD(
    id: 'rrb_group_d',
    title: 'RRB Group D (Level 1)',
    subtitle: 'Railway Recruitment Cell Trackman & Pointsman CBT',
    category: ExamCategory.railways,
    totalQuestions: 100,
    totalDurationMinutes: 90,
    positiveMark: 1.0,
    negativeMark: 0.33,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: false,
    sectionalLockDurationMinutes: 0,
    supportsBilingual: true,
    badgeColorHex: 0xFF0EA5E9,
  ),
  rrbAlp(
    id: 'rrb_alp',
    title: 'RRB ALP & Technician',
    subtitle: 'Assistant Loco Pilot & Technician First Stage CBT',
    category: ExamCategory.railways,
    totalQuestions: 75,
    totalDurationMinutes: 60,
    positiveMark: 1.0,
    negativeMark: 0.33,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: false,
    sectionalLockDurationMinutes: 0,
    supportsBilingual: true,
    badgeColorHex: 0xFF0369A1,
  ),

  // Expanded SSC Exams
  sscChsl(
    id: 'ssc_chsl',
    title: 'SSC CHSL (10+2)',
    subtitle: 'Combined Higher Secondary Level Tier-1 Examination',
    category: ExamCategory.ssc,
    totalQuestions: 100,
    totalDurationMinutes: 60,
    positiveMark: 2.0,
    negativeMark: 0.50,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: false,
    sectionalLockDurationMinutes: 0,
    supportsBilingual: true,
    badgeColorHex: 0xFF8B5CF6,
  ),
  sscMts(
    id: 'ssc_mts',
    title: 'SSC MTS & Havaldar',
    subtitle: 'Multi-Tasking Non-Technical Staff Computer Based Exam',
    category: ExamCategory.ssc,
    totalQuestions: 90,
    totalDurationMinutes: 90,
    positiveMark: 3.0,
    negativeMark: 1.0,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: true,
    sectionalLockDurationMinutes: 45,
    supportsBilingual: true,
    badgeColorHex: 0xFF6D28D9,
  ),
  sscGd(
    id: 'ssc_gd',
    title: 'SSC GD Constable',
    subtitle: 'Central Armed Police Forces (CAPFs) & SSF Examination',
    category: ExamCategory.ssc,
    totalQuestions: 80,
    totalDurationMinutes: 60,
    positiveMark: 2.0,
    negativeMark: 0.50,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: false,
    sectionalLockDurationMinutes: 0,
    supportsBilingual: true,
    badgeColorHex: 0xFF4C1D95,
  ),

  // Expanded State Exams
  tnpscGroup1(
    id: 'tnpsc_group_1',
    title: 'TNPSC Group 1 Preliminary',
    subtitle: 'Deputy Collector, DSP & Commercial Tax Officer Exam',
    category: ExamCategory.tnpsc,
    totalQuestions: 200,
    totalDurationMinutes: 180,
    positiveMark: 1.5,
    negativeMark: 0.0,
    totalOptions: 5,
    hasOptionE: true,
    hasSectionalLock: false,
    sectionalLockDurationMinutes: 0,
    supportsBilingual: true,
    badgeColorHex: 0xFF047857,
  ),
  tnusrbPolice(
    id: 'tnusrb_police',
    title: 'TNUSRB Police SI & Constable',
    subtitle: 'Tamil Nadu Uniformed Services Recruitment Board Examination',
    category: ExamCategory.tnpsc,
    totalQuestions: 140,
    totalDurationMinutes: 150,
    positiveMark: 1.0,
    negativeMark: 0.0,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: false,
    sectionalLockDurationMinutes: 0,
    supportsBilingual: true,
    badgeColorHex: 0xFF065F46,
  ),

  // Expanded Banking Exams
  ibpsSbiPo(
    id: 'ibps_sbi_po',
    title: 'IBPS / SBI PO Prelims',
    subtitle: 'Probationary Officers Preliminary CBT Examination',
    category: ExamCategory.banking,
    totalQuestions: 100,
    totalDurationMinutes: 60,
    positiveMark: 1.0,
    negativeMark: 0.25,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: true,
    sectionalLockDurationMinutes: 20,
    supportsBilingual: true,
    badgeColorHex: 0xFFB45309,
  ),
  rbiAssistant(
    id: 'rbi_assistant',
    title: 'RBI Assistant Prelims',
    subtitle: 'Reserve Bank of India Assistant Preliminary CBT',
    category: ExamCategory.banking,
    totalQuestions: 100,
    totalDurationMinutes: 60,
    positiveMark: 1.0,
    negativeMark: 0.25,
    totalOptions: 4,
    hasOptionE: false,
    hasSectionalLock: true,
    sectionalLockDurationMinutes: 20,
    supportsBilingual: true,
    badgeColorHex: 0xFF92400E,
  );

  final String id;
  final String title;
  final String subtitle;
  final ExamCategory category;
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
    required this.category,
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
