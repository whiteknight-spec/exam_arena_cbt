import '../../../progression/domain/models/arena_level.dart';
import '../../../progression/domain/models/exam_type.dart';
import '../models/exam_result.dart';
import '../models/question.dart';
import '../models/section.dart';

class CutoffPrediction {
  final double benchmarkCutoffPercent;
  final double benchmarkCutoffMarks;
  final bool isCutoffCleared;
  final double cutoffGap;
  final double estimatedPercentile;

  const CutoffPrediction({
    required this.benchmarkCutoffPercent,
    required this.benchmarkCutoffMarks,
    required this.isCutoffCleared,
    required this.cutoffGap,
    required this.estimatedPercentile,
  });
}

class TopicBreakdown {
  final String topic;
  final int totalCount;
  final int correctCount;
  final int incorrectCount;
  final double accuracy;

  const TopicBreakdown({
    required this.topic,
    required this.totalCount,
    required this.correctCount,
    required this.incorrectCount,
    required this.accuracy,
  });

  bool get isWeak => accuracy < 60.0;
  bool get isStrong => accuracy >= 80.0;
}

class SectionSetup {
  final List<Question> orderedQuestions;
  final List<ExamSection> sections;
  final int totalDurationSeconds;

  const SectionSetup({
    required this.orderedQuestions,
    required this.sections,
    required this.totalDurationSeconds,
  });
}

class ExamAnalyticsService {
  static int durationSecondsFor(ArenaLevel level, ExamType examType) {
    switch (level) {
      case ArenaLevel.level1:
        return 900; // 15-min Topic Speed Sprint
      case ArenaLevel.level2:
        return examType.hasSectionalLock && examType.sectionalLockDurationMinutes > 0
            ? examType.sectionalLockDurationSeconds
            : 900;
      case ArenaLevel.level3:
        return examType.totalDurationSeconds;
      case ArenaLevel.level4:
        return 600; // 10-min AI Gauntlet
    }
  }

  static int durationMinutesFor(ArenaLevel level, ExamType examType) {
    return durationSecondsFor(level, examType) ~/ 60;
  }

  static String negativeMarkingSummary(ExamType examType) {
    if (examType.hasOptionE) {
      return 'Option E protects against wrong answer penalty';
    }
    if (examType.negativeMark <= 0) {
      return 'No negative marking (0.0 penalty)';
    }
    return '-${examType.negativeMark.toStringAsFixed(2)} Marks per wrong response';
  }

  /// Partitions exam questions into authentic timed sections when sectional locking is active.
  static SectionSetup buildSectionsForExam({
    required List<Question> questions,
    required ExamType examType,
    required ArenaLevel level,
    required bool hasSectionLock,
    required int totalDurationSeconds,
    bool preserveOrder = false,
  }) {
    if (questions.isEmpty) {
      return SectionSetup(
        orderedQuestions: const [],
        sections: [
          ExamSection(
            id: 'sec_1',
            name: level.title,
            tamilName: level.tamilTitle,
            questionIndices: const [],
            allottedSeconds: totalDurationSeconds,
            isLocked: false,
          ),
        ],
        totalDurationSeconds: totalDurationSeconds,
      );
    }

    if (!hasSectionLock || questions.length <= 1) {
      return SectionSetup(
        orderedQuestions: questions,
        sections: [
          ExamSection(
            id: 'sec_1',
            name: level.title,
            tamilName: level.tamilTitle,
            questionIndices: List.generate(questions.length, (i) => i),
            allottedSeconds: totalDurationSeconds,
            isLocked: false,
          ),
        ],
        totalDurationSeconds: totalDurationSeconds,
      );
    }

    // Group questions by category preserving first-seen order
    final Map<String, List<Question>> grouped = {};
    for (final q in questions) {
      final cat = q.displayCategory.isNotEmpty ? q.displayCategory : 'General Section';
      grouped.putIfAbsent(cat, () => []).add(q);
    }

    // If only 1 category exists for a non-custom multi-question set, split into balanced sections
    if (grouped.length == 1 && !preserveOrder && questions.length >= 4) {
      final targetSectionCount = examType.category == ExamCategory.banking ? 3 : 2;
      final chunkSize = (questions.length / targetSectionCount).ceil();
      final sections = <ExamSection>[];
      int cursor = 0;
      int secIndex = 0;
      while (cursor < questions.length) {
        final end = (cursor + chunkSize).clamp(0, questions.length);
        final indices = List.generate(end - cursor, (i) => cursor + i);
        sections.add(
          ExamSection(
            id: 'sec_${secIndex + 1}',
            name: 'Section ${secIndex + 1}',
            tamilName: 'பிரிவு ${secIndex + 1}',
            questionIndices: indices,
            allottedSeconds: totalDurationSeconds,
            isLocked: secIndex != 0,
          ),
        );
        cursor = end;
        secIndex++;
      }
      return _assignSectionDurations(
        orderedQuestions: questions,
        rawSections: sections,
        examType: examType,
        level: level,
        fallbackTotalSeconds: totalDurationSeconds,
      );
    }

    // If preserveOrder is true and categories are interleaved, keep exact order if >1 categories
    // by grouping only when categories don't reorder custom test question 0, OR reorder cleanly
    final ordered = <Question>[];
    final sections = <ExamSection>[];

    if (preserveOrder) {
      // Keep original index 0 at position 0, grouped cleanly by category order
      int secNum = 1;
      for (final entry in grouped.entries) {
        final startIdx = ordered.length;
        ordered.addAll(entry.value);
        final indices = List.generate(entry.value.length, (i) => startIdx + i);
        sections.add(
          ExamSection(
            id: 'sec_$secNum',
            name: entry.key,
            tamilName: entry.key,
            questionIndices: indices,
            allottedSeconds: totalDurationSeconds,
            isLocked: secNum != 1,
          ),
        );
        secNum++;
      }
    } else {
      int secNum = 1;
      for (final entry in grouped.entries) {
        final startIdx = ordered.length;
        ordered.addAll(entry.value);
        final indices = List.generate(entry.value.length, (i) => startIdx + i);
        sections.add(
          ExamSection(
            id: 'sec_$secNum',
            name: entry.key,
            tamilName: entry.key,
            questionIndices: indices,
            allottedSeconds: totalDurationSeconds,
            isLocked: secNum != 1,
          ),
        );
        secNum++;
      }
    }

    return _assignSectionDurations(
      orderedQuestions: ordered,
      rawSections: sections,
      examType: examType,
      level: level,
      fallbackTotalSeconds: totalDurationSeconds,
    );
  }

  static SectionSetup _assignSectionDurations({
    required List<Question> orderedQuestions,
    required List<ExamSection> rawSections,
    required ExamType examType,
    required ArenaLevel level,
    required int fallbackTotalSeconds,
  }) {
    if (rawSections.length <= 1) {
      final only = rawSections.first.copyWith(
        allottedSeconds: fallbackTotalSeconds,
        isLocked: false,
      );
      return SectionSetup(
        orderedQuestions: orderedQuestions,
        sections: [only],
        totalDurationSeconds: fallbackTotalSeconds,
      );
    }

    // Distribute duration cleanly across sections
    final count = rawSections.length;
    int totalSecs = fallbackTotalSeconds;
    if (level == ArenaLevel.level3 && examType.sectionalLockDurationSeconds > 0) {
      final candidateTotal = count * examType.sectionalLockDurationSeconds;
      totalSecs = candidateTotal <= examType.totalDurationSeconds
          ? candidateTotal
          : examType.totalDurationSeconds;
    }

    final baseSlice = (totalSecs ~/ count).clamp(60, totalSecs);
    final remainder = totalSecs - (baseSlice * count);

    final updatedSections = <ExamSection>[];
    int summedTotal = 0;
    for (int i = 0; i < count; i++) {
      final allotted = baseSlice + (i == count - 1 && remainder > 0 ? remainder : 0);
      summedTotal += allotted;
      updatedSections.add(
        rawSections[i].copyWith(
          allottedSeconds: allotted,
          isLocked: i != 0,
        ),
      );
    }

    return SectionSetup(
      orderedQuestions: orderedQuestions,
      sections: updatedSections,
      totalDurationSeconds: summedTotal,
    );
  }

  static CutoffPrediction calculateCutoffAndPercentile(
    ExamType exam,
    ExamResult result,
  ) {
    double benchmarkCutoffPercent = 60.0;
    if (exam.id.contains('upsc_cse_prelims_gs')) {
      benchmarkCutoffPercent = 44.0;
    } else if (exam.id.contains('upsc_cse_csat')) {
      benchmarkCutoffPercent = 33.33;
    } else if (exam.id.contains('rrb')) {
      benchmarkCutoffPercent = 70.0;
    } else if (exam.id.contains('ssc')) {
      benchmarkCutoffPercent = 67.5;
    } else if (exam.id.contains('tnpsc')) {
      benchmarkCutoffPercent = 55.0;
    }

    final maxScore = result.maximumMarks > 0 ? result.maximumMarks : 1.0;
    final netScorePercent = ((result.netScore / maxScore) * 100).clamp(0.0, 100.0);
    final benchmarkCutoffMarks = (benchmarkCutoffPercent / 100) * maxScore;
    final isCutoffCleared = result.netScore >= benchmarkCutoffMarks;
    final cutoffGap = result.netScore - benchmarkCutoffMarks;

    double estimatedPercentile;
    if (netScorePercent >= benchmarkCutoffPercent) {
      final headroom = 100.0 - benchmarkCutoffPercent;
      final progressInHeadroom =
          headroom > 0 ? (netScorePercent - benchmarkCutoffPercent) / headroom : 1.0;
      estimatedPercentile = (85.0 + progressInHeadroom * 14.8).clamp(85.0, 99.8);
    } else {
      estimatedPercentile = (benchmarkCutoffPercent > 0
              ? (netScorePercent / benchmarkCutoffPercent) * 84.5
              : 50.0)
          .clamp(5.0, 84.9);
    }

    return CutoffPrediction(
      benchmarkCutoffPercent: benchmarkCutoffPercent,
      benchmarkCutoffMarks: benchmarkCutoffMarks,
      isCutoffCleared: isCutoffCleared,
      cutoffGap: cutoffGap,
      estimatedPercentile: estimatedPercentile,
    );
  }

  static List<TopicBreakdown> computeTopicBreakdown(
    List<Question> questions,
    Map<int, int?> userSelections,
  ) {
    final Map<String, List<int>> topicIndices = {};
    for (int i = 0; i < questions.length; i++) {
      final topic = questions[i].displayCategory;
      topicIndices.putIfAbsent(topic, () => []).add(i);
    }

    return topicIndices.entries.map((entry) {
      int topicCorrect = 0;
      int topicIncorrect = 0;
      for (final idx in entry.value) {
        final sel = userSelections[idx];
        if (sel != null) {
          if (sel == questions[idx].correctIndex) {
            topicCorrect++;
          } else if (!(questions[idx].hasOptionE && sel == 4)) {
            topicIncorrect++;
          }
        }
      }

      final scoredAttempts = topicCorrect + topicIncorrect;
      final topicAccuracy =
          scoredAttempts > 0 ? (topicCorrect / scoredAttempts) * 100 : 0.0;

      return TopicBreakdown(
        topic: entry.key,
        totalCount: entry.value.length,
        correctCount: topicCorrect,
        incorrectCount: topicIncorrect,
        accuracy: topicAccuracy,
      );
    }).toList();
  }

  static (String, String) getMnemonicForQuestion(Question q) {
    final text = '${q.subject} ${q.questionEn} ${q.category}'.toLowerCase();
    if (text.contains('speed') || text.contains('train') || text.contains('distance')) {
      return (
        '⚡ Speed Formula Trick: To convert km/h to m/s, multiply by 5/18 (Big unit to Small -> Small numerator 5).',
        '⚡ வேக குறுக்குவழி: km/h ஐ m/s ஆக மாற்ற 5/18 ஆல் பெருக்கவும். m/s ஐ km/h ஆக மாற்ற 18/5 ஆல் பெருக்கவும்.'
      );
    } else if (text.contains('article') || text.contains('polity') || text.contains('constitution')) {
      return (
        '📜 Constitution Memory Hack: Remember "U-C-F-D" -> Part 1 (Union), Part 2 (Citizenship), Part 3 (Fundamental Rights), Part 4 (DPSP).',
        '📜 அரசியலமைப்பு நினைவூட்டல்: பகுதி 1 (ஒன்றியம்), பகுதி 2 (குடியுரிமை), பகுதி 3 (அடிப்படை உரிமைகள்), பகுதி 4 (வழிகாட்டு நெறிமுறைகள்).'
      );
    } else if (text.contains('indus') ||
        text.contains('harappa') ||
        text.contains('history') ||
        text.contains('dholavira')) {
      return (
        '🏛️ IVC Acronym: Remember "D-G-Water" (Dholavira, Gujarat, advanced stone-cut reservoirs and water harvesting).',
        '🏛️ சிந்து சமவெளி குறிப்பு: தோலவிரா (குஜராத்) = பிரம்மாண்ட நீர் தேக்கங்கள் & மழைநீர் சேகரிப்பு கட்டமைப்பு.'
      );
    } else if (text.contains('ratio') || text.contains('percentage') || text.contains('profit')) {
      return (
        '💡 Quantitative Aptitude Hack: Base value is always CP (Cost Price) for Profit/Loss, and Original Price for Discounts.',
        '💡 கணித குறுக்குவழி: லாபம்/நஷ்ட கணக்குகளுக்கு அடிப்படையாக எப்போதுமே அடக்க விலையை (CP) கொள்ள வேண்டும்.'
      );
    } else if (text.contains('science') ||
        text.contains('cell') ||
        text.contains('energy') ||
        text.contains('work')) {
      return (
        '🔬 Science Recall Key: Work done = Force × Displacement in the direction of force. If angle is 90°, Work Done is 0!',
        '🔬 அறிவியல் குறிப்பு: விசை மற்றும் இடப்பெயர்ச்சிக்கு இடையே 90° கோணம் இருந்தால் செய்யப்பட்ட வேலை = 0.'
      );
    }
    return (
      '🎯 Smart CBT Elimination Trick: Eliminate the 2 extreme outlier options first; then focus on key qualifying keywords in the stem.',
      '🎯 விடை நீக்கல் முறை: பொருந்தாத இரண்டு வாய்ப்புகளை முதலில் நீக்கிவிட்டு, எஞ்சிய வினா முக்கிய சொற்களை ஒப்பிட்டு விடையளிக்கவும்.'
    );
  }
}
