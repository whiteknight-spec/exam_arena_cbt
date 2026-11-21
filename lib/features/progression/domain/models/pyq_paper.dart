import 'exam_type.dart';

/// Authentic Previous Year Question (PYQ) Paper Model.
/// Represents official historical question papers (UPSC, TNPSC, RRB, SSC)
/// with official exam year, shift details, and scoring rules.
class PyqPaper {
  final String id;
  final String examId;
  final String title;
  final String subtitle;
  final int year;
  final String shiftOrPaper;
  final int totalQuestions;
  final int durationMinutes;
  final ExamType examType;

  const PyqPaper({
    required this.id,
    required this.examId,
    required this.title,
    required this.subtitle,
    required this.year,
    required this.shiftOrPaper,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.examType,
  });

  static const List<PyqPaper> standardPapers = [
    PyqPaper(
      id: 'pyq_upsc_2024_gs1',
      examId: 'upsc_cse_prelims_gs',
      title: 'UPSC CSE 2024 Prelims GS Paper 1',
      subtitle: 'Official Civil Services IAS/IPS/IFS Prelims Paper 1',
      year: 2024,
      shiftOrPaper: 'Morning Session (GS-1)',
      totalQuestions: 100,
      durationMinutes: 120,
      examType: ExamType.upscCsePrelimsGs,
    ),
    PyqPaper(
      id: 'pyq_upsc_2024_csat',
      examId: 'upsc_cse_csat',
      title: 'UPSC CSE 2024 Prelims CSAT Paper 2',
      subtitle: 'Official CSAT Reading Comprehension, Reasoning & Numeracy',
      year: 2024,
      shiftOrPaper: 'Afternoon Session (CSAT)',
      totalQuestions: 80,
      durationMinutes: 120,
      examType: ExamType.upscCseCsat,
    ),
    PyqPaper(
      id: 'pyq_upsc_2023_gs1',
      examId: 'upsc_cse_prelims_gs',
      title: 'UPSC CSE 2023 Prelims GS Paper 1',
      subtitle: 'Official Indian Polity, Economy, Environment & History Paper',
      year: 2023,
      shiftOrPaper: 'Morning Session (GS-1)',
      totalQuestions: 100,
      durationMinutes: 120,
      examType: ExamType.upscCsePrelimsGs,
    ),
    PyqPaper(
      id: 'pyq_tnpsc_2024_grp4',
      examId: 'tnpsc_group_2_4',
      title: 'TNPSC Group 4 2024 Official Paper',
      subtitle: 'Combined Civil Services Examination IV (General Tamil + GS)',
      year: 2024,
      shiftOrPaper: 'Single Session (3 Hours)',
      totalQuestions: 200,
      durationMinutes: 180,
      examType: ExamType.tnpscGroup2And4,
    ),
    PyqPaper(
      id: 'pyq_rrb_ntpc_cbt1',
      examId: 'rrb_ntpc',
      title: 'RRB NTPC Previous Year CBT-1 Shift 1',
      subtitle: 'Railways Non-Technical Popular Categories Benchmark Shift',
      year: 2021,
      shiftOrPaper: 'Phase-1 CBT Shift 1',
      totalQuestions: 100,
      durationMinutes: 90,
      examType: ExamType.rrbNtpc,
    ),
    PyqPaper(
      id: 'pyq_ssc_cgl_2024_tier1',
      examId: 'ssc_cgl',
      title: 'SSC CGL 2024 Tier 1 Official Shift',
      subtitle: 'Staff Selection Commission Combined Graduate Level CBT',
      year: 2024,
      shiftOrPaper: 'Tier-1 Shift 2',
      totalQuestions: 100,
      durationMinutes: 60,
      examType: ExamType.sscCgl,
    ),
  ];
}
