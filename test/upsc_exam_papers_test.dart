import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exam_arena_cbt/core/database/app_database.dart';
import 'package:exam_arena_cbt/features/ai_generator/data/datasources/local_question_datasource.dart';
import 'package:exam_arena_cbt/features/ai_generator/data/seed/seed_questions.dart';
import 'package:exam_arena_cbt/features/progression/domain/models/exam_type.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('UPSC Civil Services & Defence Exam Papers & Specifications', () {
    test('ExamCategory.upsc exists with title "UPSC Civil Services"', () {
      expect(ExamCategory.upsc.title, 'UPSC Civil Services');
      expect(ExamCategory.values.contains(ExamCategory.upsc), isTrue);
    });

    test('UPSC CSE Prelims GS-1 specifications (100 Qs, 120 mins, +2.0 / -0.67, 4 options)', () {
      const exam = ExamType.upscCsePrelimsGs;
      expect(exam.id, 'upsc_cse_prelims_gs');
      expect(exam.title, 'UPSC CSE Prelims (GS-1)');
      expect(exam.category, ExamCategory.upsc);
      expect(exam.totalQuestions, 100);
      expect(exam.totalDurationMinutes, 120);
      expect(exam.totalDurationSeconds, 7200);
      expect(exam.positiveMark, 2.0);
      expect(exam.negativeMark, 0.67);
      expect(exam.totalOptions, 4);
      expect(exam.hasOptionE, isFalse);
      expect(exam.hasSectionalLock, isFalse);
      expect(exam.supportsBilingual, isTrue);
      expect(exam.maximumMarks, 200.0);
    });

    test('UPSC CSAT Prelims GS-2 specifications (80 Qs, 120 mins, +2.5 / -0.83, 4 options)', () {
      const exam = ExamType.upscCseCsat;
      expect(exam.id, 'upsc_cse_csat');
      expect(exam.title, 'UPSC CSAT Prelims (GS-2)');
      expect(exam.category, ExamCategory.upsc);
      expect(exam.totalQuestions, 80);
      expect(exam.totalDurationMinutes, 120);
      expect(exam.totalDurationSeconds, 7200);
      expect(exam.positiveMark, 2.5);
      expect(exam.negativeMark, 0.83);
      expect(exam.totalOptions, 4);
      expect(exam.hasOptionE, isFalse);
      expect(exam.hasSectionalLock, isFalse);
      expect(exam.supportsBilingual, isTrue);
      expect(exam.maximumMarks, 200.0);
    });

    test('UPSC CDS examination specifications (100 Qs, 120 mins, +1.0 / -0.33)', () {
      const exam = ExamType.upscCds;
      expect(exam.id, 'upsc_cds');
      expect(exam.category, ExamCategory.upsc);
      expect(exam.totalQuestions, 100);
      expect(exam.totalDurationMinutes, 120);
      expect(exam.positiveMark, 1.0);
      expect(exam.negativeMark, 0.33);
      expect(exam.maximumMarks, 100.0);
    });

    test('UPSC NDA examination specifications (150 Qs, 150 mins, +2.5 / -0.83)', () {
      const exam = ExamType.upscNda;
      expect(exam.id, 'upsc_nda');
      expect(exam.category, ExamCategory.upsc);
      expect(exam.totalQuestions, 150);
      expect(exam.totalDurationMinutes, 150);
      expect(exam.positiveMark, 2.5);
      expect(exam.negativeMark, 0.83);
      expect(exam.maximumMarks, 375.0);
    });
  });

  group('UPSC Authentic Bilingual Question Papers Bank', () {
    final upscQuestions = SeedQuestions.getUpscQuestions();

    test('Total UPSC seeded questions is exactly 12', () {
      expect(upscQuestions.length, 12);
    });

    test('All UPSC questions have 100% complete bilingual texts and explanations', () {
      for (final q in upscQuestions) {
        expect(q.id.startsWith('upsc_'), isTrue);
        expect(q.questionEn.trim().isNotEmpty, isTrue);
        expect(q.questionTa.trim().isNotEmpty, isTrue);
        expect(q.optionsEn.length, 4);
        expect(q.optionsTa.length, 4);
        expect(q.explanationEn.trim().isNotEmpty, isTrue);
        expect(q.explanationTa.trim().isNotEmpty, isTrue);
        expect(q.correctIndex, inInclusiveRange(0, 3));
      }
    });

    test('Covers UPSC GS-1 Indian Polity (Kesavananda Bharati & Money Bill)', () {
      final polity = upscQuestions.where((q) => q.subject.contains('Polity')).toList();
      expect(polity.length, 2);

      // Kesavananda Bharati Basic Structure Doctrine
      expect(polity.any((q) => q.id == 'upsc_01' && q.questionEn.contains('Basic Structure Doctrine')), isTrue);
      expect(polity.any((q) => q.id == 'upsc_01' && q.questionTa.contains('அடிப்படை கட்டமைப்பு')), isTrue);

      // Money Bill
      expect(polity.any((q) => q.id == 'upsc_02' && q.questionEn.contains('Money Bill')), isTrue);
      expect(polity.any((q) => q.id == 'upsc_02' && q.questionTa.contains('பண மசோதா')), isTrue);
    });

    test('Covers UPSC GS-1 History & Heritage (Dholavira Water System & Cripps Mission)', () {
      // Ancient Indian History: Dholavira
      expect(
        upscQuestions.any((q) => q.id == 'upsc_03' && q.questionEn.contains('Harappan sites') && q.optionsEn.any((opt) => opt.contains('Dholavira'))),
        isTrue,
      );

      // Modern Indian History: Cripps Mission 1942
      expect(
        upscQuestions.any((q) => q.id == 'upsc_04' && q.questionEn.contains('Cripps Mission') && q.questionTa.contains('கிரிப்ஸ்')),
        isTrue,
      );
    });

    test('Covers UPSC GS-1 Geography & Environment (Palghat Gap & Ramsar Convention)', () {
      // Western Ghats Pass: Palghat Gap
      expect(
        upscQuestions.any((q) => q.id == 'upsc_05' && q.questionEn.contains('Western Ghats') && q.optionsEn.any((opt) => opt.contains('Palghat'))),
        isTrue,
      );

      // Environment: Ramsar Convention on Wetlands
      expect(
        upscQuestions.any((q) => q.id == 'upsc_06' && q.questionEn.contains('Ramsar Convention') && q.questionTa.contains('ராம்சார்')),
        isTrue,
      );
    });

    test('Covers UPSC GS-1 Indian Economy (Monetary Policy Committee)', () {
      expect(
        upscQuestions.any((q) => q.id == 'upsc_07' && q.questionEn.contains('Policy Repo Rate') && q.optionsEn.any((opt) => opt.contains('Monetary Policy Committee'))),
        isTrue,
      );
    });

    test('Covers UPSC CSAT GS-2 (Comprehension, Syllogisms & Numeracy)', () {
      final csat = upscQuestions.where((q) => q.examType == 'upsc_cse_csat').toList();
      expect(csat.length, 3);

      // Reading Comprehension & Capability Approach
      expect(csat.any((q) => q.id == 'upsc_08' && q.questionEn.contains('Economic growth without social justice')), isTrue);

      // Logical Deduction & Syllogism
      expect(csat.any((q) => q.id == 'upsc_09' && q.questionEn.contains('Civil Servants are ethical administrators')), isTrue);

      // Quantitative Aptitude
      expect(csat.any((q) => q.id == 'upsc_10' && q.questionEn.contains('80 objective questions')), isTrue);
    });

    test('Covers Defence & Space Technology (LCA Tejas & Aditya-L1)', () {
      // CDS Defence: LCA Tejas
      expect(
        upscQuestions.any((q) => q.id == 'upsc_11' && q.optionsEn.any((opt) => opt.contains('LCA Tejas')) && q.optionsTa.any((opt) => opt.contains('தேஜஸ்'))),
        isTrue,
      );

      // Space Science: Aditya-L1
      expect(
        upscQuestions.any((q) => q.id == 'upsc_12' && q.questionEn.contains('Aditya-L1') && q.questionTa.contains('ஆதித்யா-L1')),
        isTrue,
      );
    });
  });

  group('LocalQuestionDatasource UPSC SQLite Seeding & Querying', () {
    test('seeds UPSC questions and retrieves them via getQuestionsByExamType', () async {
      final appDatabase = AppDatabase.instance;
      final datasource = LocalQuestionDatasource(appDatabase: appDatabase);

      await datasource.seedIfEmpty();

      // Retrieve UPSC CSE Prelims questions
      final questions = await datasource.getQuestionsByExamType('upsc_cse_prelims_gs');
      expect(questions.isNotEmpty, isTrue);
      expect(questions.any((q) => q.id == 'upsc_01'), isTrue);

      // Query CSAT questions
      final csatQuestions = await datasource.getQuestionsByExamType('upsc_cse_csat');
      expect(csatQuestions.isNotEmpty, isTrue);
      expect(csatQuestions.any((q) => q.id == 'upsc_08'), isTrue);
    });
  });
}
