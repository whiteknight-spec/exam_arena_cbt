import 'package:exam_arena_cbt/features/exam_engine/domain/models/question.dart';

class SeedQuestions {
  static List<Question> getInitialQuestions() {
    return [
      // =========================================================================
      // QUANTITATIVE APTITUDE (Percentages, Ratio, Time & Work, Simplification)
      // =========================================================================

      // 1. Percentages (Price & Consumption)
      const Question(
        id: 'quant_01',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'rrb_ntpc',
        questionEn:
            'If the price of sugar increases by 25%, by what percentage must a family reduce its consumption so that the total expenditure remains unchanged?',
        questionTa:
            'சர்க்கரையின் விலை 25% உயர்ந்தால், செலவு மாறாமல் இருக்க ஒரு குடும்பம் அதன் நுகர்வை எத்தனை சதவீதம் குறைக்க வேண்டும்?',
        optionsEn: ['20%', '25%', '16.66%', '30%'],
        optionsTa: ['20%', '25%', '16.66%', '30%'],
        correctIndex: 0,
        explanationEn:
            'Required reduction = [r / (100 + r)] * 100 = [25 / (100 + 25)] * 100 = (25 / 125) * 100 = 20%.',
        explanationTa:
            'நுகர்வு குறைப்பு = [r / (100 + r)] * 100 = [25 / (100 + 25)] * 100 = (25 / 125) * 100 = 20%.',
        hasOptionE: false,
      ),

      // 2. Percentages (Population Successive Change)
      const Question(
        id: 'quant_02',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'ssc_cgl',
        questionEn:
            'The population of a town increases by 10% in the first year and decreases by 10% in the second year. If the initial population was 50,000, what is the population at the end of 2 years?',
        questionTa:
            'ஒரு நகரத்தின் மக்கள் தொகை முதல் ஆண்டில் 10% அதிகரித்து, இரண்டாம் ஆண்டில் 10% குறைகிறது. ஆரம்ப மக்கள் தொகை 50,000 எனில், 2 ஆண்டுகளின் முடிவில் மக்கள் தொகை என்ன?',
        optionsEn: ['49,500', '50,000', '48,500', '51,000'],
        optionsTa: ['49,500', '50,000', '48,500', '51,000'],
        correctIndex: 0,
        explanationEn:
            'Net change = +10 - 10 - (10 * 10 / 100) = -1%. Population at end = 50,000 * (1 - 0.01) = 49,500.',
        explanationTa:
            'நிகர மாற்றம் = +10 - 10 - (10 * 10 / 100) = -1%. முடிவில் மக்கள் தொகை = 50,000 * 0.99 = 49,500.',
        hasOptionE: false,
      ),

      // 3. Ratio & Proportion (Ages)
      const Question(
        id: 'quant_03',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'ibps_sbi_clerk',
        questionEn:
            'The present ages of A and B are in the ratio 7 : 5. Ten years hence, the ratio of their ages will be 9 : 7. What is the present age of A?',
        questionTa:
            'A மற்றும் B-யின் தற்போதைய வயதுகளின் விகிதம் 7 : 5. பத்து ஆண்டுகளுக்குப் பிறகு, அவர்களின் வயதுகளின் விகிதம் 9 : 7 ஆக மாறுகிறது. A-யின் தற்போதைய வயது என்ன?',
        optionsEn: ['35 years', '25 years', '42 years', '28 years'],
        optionsTa: ['35 ஆண்டுகள்', '25 ஆண்டுகள்', '42 ஆண்டுகள்', '28 ஆண்டுகள்'],
        correctIndex: 0,
        explanationEn:
            'Let ages be 7x and 5x. (7x + 10) / (5x + 10) = 9 / 7 => 49x + 70 = 45x + 90 => 4x = 20 => x = 5. Age of A = 7 * 5 = 35 years.',
        explanationTa:
            'வயதுகள் 7x மற்றும் 5x என்க. (7x + 10) / (5x + 10) = 9 / 7 => 49x + 70 = 45x + 90 => 4x = 20 => x = 5. A-யின் தற்போதைய வயது = 7 * 5 = 35 ஆண்டுகள்.',
        hasOptionE: false,
      ),

      // 4. Ratio & Proportion (Mixtures)
      const Question(
        id: 'quant_04',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'ssc_cgl',
        questionEn:
            'A 60-liter mixture contains milk and water in the ratio 2 : 1. How many liters of water must be added to make the ratio of milk to water 1 : 2?',
        questionTa:
            '60 லிட்டர் கலவையில் பாலும் தண்ணீரும் 2 : 1 என்ற விகிதத்தில் உள்ளன. பாலும் தண்ணீரும் 1 : 2 என்ற விகிதத்தில் அமைய எத்தனை லிட்டர் தண்ணீர் சேர்க்க வேண்டும்?',
        optionsEn: ['60 liters', '40 liters', '30 liters', '50 liters'],
        optionsTa: ['60 லிட்டர்', '40 லிட்டர்', '30 லிட்டர்', '50 லிட்டர்'],
        correctIndex: 0,
        explanationEn:
            'Initial Milk = (2/3) * 60 = 40 L, Water = 20 L. In new ratio 1 : 2, milk remains 40 L. So water must be 40 * 2 = 80 L. Water to add = 80 - 20 = 60 liters.',
        explanationTa:
            'ஆரம்பத்தில் பால் = 40 லிட்டர், தண்ணீர் = 20 லிட்டர். புதிய விகிதம் 1 : 2-ல் பால் 40 லிட்டர் மாறாது. ஆகவே தண்ணீர் = 40 * 2 = 80 லிட்டர். சேர்க்க வேண்டிய தண்ணீர் = 80 - 20 = 60 லிட்டர்.',
        hasOptionE: false,
      ),

      // 5. Time & Work (Together & Remaining)
      const Question(
        id: 'quant_05',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'rrb_ntpc',
        questionEn:
            'A can complete a work in 12 days and B can do it in 18 days. They work together for 4 days. What fraction of the total work is left?',
        questionTa:
            'A ஒரு வேலையை 12 நாட்களிலும், B அதே வேலையை 18 நாட்களிலும் முடிப்பர். இருவரும் சேர்ந்து 4 நாட்கள் வேலை செய்கின்றனர் எனில், மீதமுள்ள வேலையின் பின்னம் என்ன?',
        optionsEn: ['4/9', '5/9', '1/3', '2/9'],
        optionsTa: ['4/9', '5/9', '1/3', '2/9'],
        correctIndex: 0,
        explanationEn:
            "A's 1-day work = 1/12, B's 1-day work = 1/18. Combined 1-day work = (3 + 2)/36 = 5/36. In 4 days = 4 * (5/36) = 5/9. Remaining work = 1 - 5/9 = 4/9.",
        explanationTa:
            'இருவரின் 1 நாள் வேலை = 1/12 + 1/18 = 5/36. 4 நாட்களில் முடிந்த வேலை = 4 * (5/36) = 5/9. மீதமுள்ள வேலை = 1 - 5/9 = 4/9.',
        hasOptionE: false,
      ),

      // 6. Time & Work (Men-Days-Hours Formula)
      const Question(
        id: 'quant_06',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'ibps_sbi_clerk',
        questionEn:
            'If 15 men can complete a project in 20 days working 8 hours a day, how many days will 20 men take to complete the same project working 6 hours a day?',
        questionTa:
            '15 நபர்கள் ஒரு நாளைக்கு 8 மணி நேரம் வேலை செய்து 20 நாட்களில் ஒரு திட்டத்தை முடிக்கிறார்கள் எனில், 20 நபர்கள் ஒரு நாளைக்கு 6 மணி நேரம் வேலை செய்து எத்தனை நாட்களில் அதே பணியை முடிப்பர்?',
        optionsEn: ['20 days', '18 days', '24 days', '15 days'],
        optionsTa: ['20 நாட்கள்', '18 நாட்கள்', '24 நாட்கள்', '15 நாட்கள்'],
        correctIndex: 0,
        explanationEn:
            'Formula: M1 * D1 * H1 = M2 * D2 * H2 => 15 * 20 * 8 = 20 * D2 * 6 => 2400 = 120 * D2 => D2 = 20 days.',
        explanationTa:
            'சூத்திரம்: M1 * D1 * H1 = M2 * D2 * H2 => 15 * 20 * 8 = 20 * D2 * 6 => 2400 = 120 * D2 => D2 = 20 நாட்கள்.',
        hasOptionE: false,
      ),

      // 7. Simplification (Nested Square Roots)
      const Question(
        id: 'quant_07',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'rrb_ntpc',
        questionEn: 'Evaluate the simplified value of: √[176 + √(2401)]',
        questionTa: 'சுருக்குக: √[176 + √(2401)]',
        optionsEn: ['15', '16', '14', '17'],
        optionsTa: ['15', '16', '14', '17'],
        correctIndex: 0,
        explanationEn:
            'Since 49^2 = 2401, √(2401) = 49. Then √[176 + 49] = √(225) = 15.',
        explanationTa:
            '49^2 = 2401 என்பதால், √(2401) = 49. பின்னர் √[176 + 49] = √(225) = 15.',
        hasOptionE: false,
      ),

      // 8. Simplification (Percentages & Arithmetic Operations)
      const Question(
        id: 'quant_08',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'ibps_sbi_clerk',
        questionEn:
            'Find the value of: (25% of 480) + (40% of 350) - (15 × 8)',
        questionTa:
            'மதிப்பு காண்க: (480-ல் 25%) + (350-ல் 40%) - (15 × 8)',
        optionsEn: ['140', '120', '150', '160'],
        optionsTa: ['140', '120', '150', '160'],
        correctIndex: 0,
        explanationEn:
            '25% of 480 = 120. 40% of 350 = 140. 15 × 8 = 120. Result = 120 + 140 - 120 = 140.',
        explanationTa:
            '480-ல் 25% = 120. 350-ல் 40% = 140. 15 × 8 = 120. விடை = 120 + 140 - 120 = 140.',
        hasOptionE: false,
      ),

      // =========================================================================
      // LOGICAL REASONING (Series, Coding-Decoding, Blood Relations, Syllogisms)
      // =========================================================================

      // 9. Series (Number Series Difference of Squares)
      const Question(
        id: 'reason_01',
        subject: 'Logical Reasoning',
        category: 'Logical Reasoning',
        examType: 'ssc_cgl',
        questionEn:
            'Find the missing number in the sequence: 7, 11, 20, 36, 61, ?',
        questionTa:
            'பின்வரும் எண் தொடரில் விடுபட்ட எண்ணைக் காண்க: 7, 11, 20, 36, 61, ?',
        optionsEn: ['97', '95', '98', '102'],
        optionsTa: ['97', '95', '98', '102'],
        correctIndex: 0,
        explanationEn:
            'Differences: +4 (2^2), +9 (3^2), +16 (4^2), +25 (5^2). Next difference = 6^2 = 36. Missing number = 61 + 36 = 97.',
        explanationTa:
            'வித்தியாசம்: +4 (2^2), +9 (3^2), +16 (4^2), +25 (5^2). அடுத்த வித்தியாசம் 6^2 = 36. விடுபட்ட எண் = 61 + 36 = 97.',
        hasOptionE: false,
      ),

      // 10. Series (Alphanumeric Sequence)
      const Question(
        id: 'reason_02',
        subject: 'Logical Reasoning',
        category: 'Logical Reasoning',
        examType: 'ibps_sbi_clerk',
        questionEn:
            'What comes next in the alphanumeric sequence: B2D, E4G, H8J, K16M, ?',
        questionTa:
            'பின்வரும் எழுத்து-எண் தொடரில் அடுத்து வருவது எது: B2D, E4G, H8J, K16M, ?',
        optionsEn: ['N32P', 'N32O', 'M32P', 'O32Q'],
        optionsTa: ['N32P', 'N32O', 'M32P', 'O32Q'],
        correctIndex: 0,
        explanationEn:
            'First letter increases by +3: B->E->H->K->N. Numbers double: 2->4->8->16->32. Last letter increases by +3: D->G->J->M->P. Result is N32P.',
        explanationTa:
            'முதல் எழுத்து +3: B->E->H->K->N. எண்கள் இரட்டிப்பாகின்றன: 2, 4, 8, 16, 32. கடைசி எழுத்து +3: D->G->J->M->P. விடை: N32P.',
        hasOptionE: false,
      ),

      // 11. Coding-Decoding (Letter Shift)
      const Question(
        id: 'reason_03',
        subject: 'Logical Reasoning',
        category: 'Logical Reasoning',
        examType: 'rrb_ntpc',
        questionEn:
            "In a certain code language, 'TEACHER' is written as 'VGCEJGT'. How will 'CHILDREN' be written in that code?",
        questionTa:
            "ஒரு குறிப்பிட்ட குறியீட்டு மொழியில் 'TEACHER' என்பது 'VGCEJGT' என எழுதப்பட்டால், 'CHILDREN' எவ்வாறு எழுதப்படும்?",
        optionsEn: ['EJKNFTGP', 'EJKNFUGP', 'EJKMFTGP', 'EJLNFTGP'],
        optionsTa: ['EJKNFTGP', 'EJKNFUGP', 'EJKMFTGP', 'EJLNFTGP'],
        correctIndex: 0,
        explanationEn:
            'Each letter is shifted by +2: C->E, H->J, I->K, L->N, D->F, R->T, E->G, N->P. Result = EJKNFTGP.',
        explanationTa:
            'ஒவ்வொரு எழுத்தும் 2 இடங்கள் முன்னோக்கி நகர்த்தப்பட்டுள்ளது (+2): C->E, H->J, I->K, L->N, D->F, R->T, E->G, N->P => EJKNFTGP.',
        hasOptionE: false,
      ),

      // 12. Coding-Decoding (Alphabet Positional Values)
      const Question(
        id: 'reason_04',
        subject: 'Logical Reasoning',
        category: 'Logical Reasoning',
        examType: 'ssc_cgl',
        questionEn:
            'If CAT is coded as 24 and DOG is coded as 26, what is the numerical code for TIGER?',
        questionTa:
            'CAT என்பது 24 எனவும் DOG என்பது 26 எனவும் குறிக்கப்பட்டால், TIGER என்பதன் எண் குறியீடு என்ன?',
        optionsEn: ['59', '61', '57', '63'],
        optionsTa: ['59', '61', '57', '63'],
        correctIndex: 0,
        explanationEn:
            'Sum of alphabetical positions: C(3)+A(1)+T(20) = 24. For TIGER: T(20) + I(9) + G(7) + E(5) + R(18) = 59.',
        explanationTa:
            'எழுத்துகளின் அகரவரிசை எண்களின் கூடுதல்: C(3)+A(1)+T(20)=24; TIGER = 20 + 9 + 7 + 5 + 18 = 59.',
        hasOptionE: false,
      ),

      // 13. Blood Relations (Direct Statement)
      const Question(
        id: 'reason_05',
        subject: 'Logical Reasoning',
        category: 'Logical Reasoning',
        examType: 'ssc_cgl',
        questionEn:
            'Pointing to a photograph of a girl, Arun said, "She is the daughter of my grandfather\'s only son." How is the girl related to Arun?',
        questionTa:
            'ஒரு சிறுமியின் புகைப்படத்தைக் காட்டி அருண் கூறினான், "இவள் என் தாத்தாவின் ஒரே மகனின் மகள்." அந்த சிறுமி அருணுக்கு என்ன உறவு?',
        optionsEn: ['Sister', 'Cousin', 'Mother', 'Aunt'],
        optionsTa: ['சகோதரி', 'உடன்பிறவா சகோதரி', 'தாய்', 'அத்தை'],
        correctIndex: 0,
        explanationEn:
            "Grandfather's only son is Arun's father. The daughter of Arun's father is Arun's sister.",
        explanationTa:
            'தாத்தாவின் ஒரே மகன் என்பவர் அருணின் தந்தை ஆவார். தந்தையின் மகள் அருணின் சகோதரி ஆவார்.',
        hasOptionE: false,
      ),

      // 14. Blood Relations (Coded Relationship)
      const Question(
        id: 'reason_06',
        subject: 'Logical Reasoning',
        category: 'Logical Reasoning',
        examType: 'ibps_sbi_clerk',
        questionEn:
            'If "P + Q" means P is the father of Q, "P - Q" means P is the sister of Q, and "P × Q" means P is the brother of Q, which expression indicates that M is the aunt of N?',
        questionTa:
            '"P + Q" என்பது P, Q-வின் தந்தை; "P - Q" என்பது P, Q-வின் சகோதரி; "P × Q" என்பது P, Q-வின் சகோதரன் எனில், M என்பவர் N-க்கு அத்தை/சித்தி என்பதை குறிக்கும் சமன்பாடு எது?',
        optionsEn: ['M - K + N', 'M + K - N', 'M × K + N', 'M - K × N'],
        optionsTa: ['M - K + N', 'M + K - N', 'M × K + N', 'M - K × N'],
        correctIndex: 0,
        explanationEn:
            'In M - K + N: K + N means K is the father of N. M - K means M is the sister of K. Father\'s sister is paternal aunt. So M is the aunt of N.',
        explanationTa:
            'M - K + N என்பதில்: K + N என்பது K, N-ன் தந்தை. M - K என்பது M, K-ன் சகோதரி. தந்தையின் சகோதரி அத்தை ஆவார். ஆகவே M, N-ன் அத்தை ஆவார்.',
        hasOptionE: false,
      ),

      // 15. Syllogisms
      const Question(
        id: 'reason_07',
        subject: 'Logical Reasoning',
        category: 'Logical Reasoning',
        examType: 'rrb_ntpc',
        questionEn:
            'Statements:\n• All roses are flowers.\n• All flowers are plants.\nConclusions:\nI. All roses are plants.\nII. Some plants are roses.',
        questionTa:
            'கூற்றுகள்:\n• அனைத்து ரோஜாக்களும் மலர்கள்.\n• அனைத்து மலர்களும் தாவரங்கள்.\nமுடிவுகள்:\nI. அனைத்து ரோஜாக்களும் தாவரங்கள்.\nII. சில தாவரங்கள் ரோஜாக்கள்.',
        optionsEn: [
          'Both Conclusion I and II follow',
          'Only Conclusion I follows',
          'Only Conclusion II follows',
          'Neither Conclusion I nor II follows',
        ],
        optionsTa: [
          'முடிவுகள் I மற்றும் II ஆகிய இரண்டும் சரி',
          'முடிவு I மட்டுமே சரி',
          'முடிவு II மட்டுமே சரி',
          'இரண்டு முடிவுகளும் தவறானவை',
        ],
        correctIndex: 0,
        explanationEn:
            'Since Roses ⊆ Flowers ⊆ Plants: All roses are plants (Conclusion I is true). Also, the portion of plants containing roses validates that Some plants are roses (Conclusion II is true).',
        explanationTa:
            'ரோஜாக்கள் அனைத்தும் மலர்கள், மலர்கள் அனைத்தும் தாவரங்கள் என்பதால், அனைத்து ரோஜாக்களும் தாவரங்களே (முடிவு I சரி). மேலும் சில தாவரங்கள் ரோஜாக்களாகும் (முடிவு II சரி).',
        hasOptionE: false,
      ),

      // =========================================================================
      // GENERAL AWARENESS & INDIAN POLITY/HISTORY (Constitution, Freedom, Current Affairs, Science)
      // =========================================================================

      // 16. Constitution (42nd Amendment)
      const Question(
        id: 'ga_01',
        subject: 'General Awareness',
        category: 'General Awareness',
        examType: 'ssc_cgl',
        questionEn:
            'By which Constitutional Amendment Act were the words "Socialist, Secular, and Integrity" incorporated into the Preamble of the Indian Constitution?',
        questionTa:
            'இந்திய அரசியலமைப்பின் முகப்புரையில் "சமதர்ம, மதச்சார்பற்ற மற்றும் ஒருமைப்பாடு" என்ற சொற்கள் எந்த அரசியலமைப்பு திருத்தச் சட்டத்தின் மூலம் சேர்க்கப்பட்டன?',
        optionsEn: [
          '42nd Amendment Act, 1976',
          '44th Amendment Act, 1978',
          '73rd Amendment Act, 1992',
          '86th Amendment Act, 2002',
        ],
        optionsTa: [
          '42-வது திருத்தச் சட்டம், 1976',
          '44-வது திருத்தச் சட்டம், 1978',
          '73-வது திருத்தச் சட்டம், 1992',
          '86-வது திருத்தச் சட்டம், 2002',
        ],
        correctIndex: 0,
        explanationEn:
            'The 42nd Constitutional Amendment Act of 1976 (frequently referred to as the "Mini-Constitution") added Socialist, Secular, and Integrity to the Preamble.',
        explanationTa:
            '1976 ஆம் ஆண்டின் 42-வது அரசியலமைப்பு திருத்தச் சட்டம் முகப்புரையில் "சமதர்ம, மதச்சார்பற்ற மற்றும் ஒருமைப்பாடு" ஆகிய மூன்று சொற்களைச் சேர்த்தது. இது "குறு அரசியலமைப்பு" என்றும் அழைக்கப்படுகிறது.',
        hasOptionE: false,
      ),

      // 17. Constitution (Article 32 - Heart & Soul)
      const Question(
        id: 'ga_02',
        subject: 'General Awareness',
        category: 'General Awareness',
        examType: 'rrb_ntpc',
        questionEn:
            'Which Article was described by Dr. B. R. Ambedkar as the "Heart and Soul of the Indian Constitution"?',
        questionTa:
            'டாக்டர் பி. ஆர். அம்பேத்கர் அவர்களால் "இந்திய அரசியலமைப்பின் இதயம் மற்றும் ஆன்மா" என வர்ணிக்கப்பட்ட சட்டப்பிரிவு எது?',
        optionsEn: ['Article 32', 'Article 19', 'Article 21', 'Article 14'],
        optionsTa: ['பிரிவு 32', 'பிரிவு 19', 'பிரிவு 21', 'பிரிவு 14'],
        correctIndex: 0,
        explanationEn:
            'Article 32 guarantees the Right to Constitutional Remedies, empowering citizens to move the Supreme Court directly via constitutional writs for the enforcement of fundamental rights.',
        explanationTa:
            'அரசியலமைப்புக்கு உட்பட்டு தீர்வு காணும் உரிமை (பிரிவு 32) அடிப்படை உரிமைகள் மீறப்படும்போது நீதிப்பேராணைகள் மூலம் உச்ச நீதிமன்றத்தை அணுக வகை செய்கிறது.',
        hasOptionE: false,
      ),

      // 18. Freedom Movement (1857 Revolt Barrackpore)
      const Question(
        id: 'ga_03',
        subject: 'General Awareness',
        category: 'General Awareness',
        examType: 'rrb_ntpc',
        questionEn:
            'Who was the sepoy who spearheaded the revolt at Barrackpore on March 29, 1857, marking the prelude to the Indian Rebellion of 1857?',
        questionTa:
            'மார்ச் 29, 1857 அன்று பாரக்பூரில் ஆங்கிலேய அதிகாரியை எதிர்த்து 1857 பெரும் புரட்சிக்கு வித்திட்ட சிப்பாய் யார்?',
        optionsEn: [
          'Mangal Pandey',
          'Tatya Tope',
          'Kunwar Singh',
          'Bakht Khan',
        ],
        optionsTa: [
          'மங்கள் பாண்டே',
          'தாந்தியா தோபே',
          'கன்வர் சிங்',
          'பக்த் கான்',
        ],
        correctIndex: 0,
        explanationEn:
            'Mangal Pandey of the 34th Bengal Native Infantry revolted against the Enfield rifle greased cartridges at Barrackpore in March 1857.',
        explanationTa:
            '34-வது வங்காள பூர்வீக காலாட்படையின் சிப்பாயான மங்கள் பாண்டே, கொழுப்பு தடவப்பட்ட தோட்டாக்களைப் பயன்படுத்த மறுத்து பாரக்பூரில் முதல் கிளர்ச்சியைத் தொடங்கினார்.',
        hasOptionE: false,
      ),

      // 19. Freedom Movement (1930 Salt March)
      const Question(
        id: 'ga_04',
        subject: 'General Awareness',
        category: 'General Awareness',
        examType: 'ssc_cgl',
        questionEn:
            'In which year did Mahatma Gandhi undertake the historic Dandi March from Sabarmati Ashram to break the British salt laws?',
        questionTa:
            'பிரிட்டிஷ் உப்புச் சட்டங்களை மீறுவதற்காக மகாத்மா காந்தி சபர்மதி ஆசிரமத்திலிருந்து வரலாற்று சிறப்புமிக்க தண்டி யாத்திரையை மேற்கொண்ட ஆண்டு எது?',
        optionsEn: ['1930', '1920', '1942', '1919'],
        optionsTa: ['1930', '1920', '1942', '1919'],
        correctIndex: 0,
        explanationEn:
            'The Dandi March took place from March 12 to April 6, 1930, inaugurating the nationwide Civil Disobedience Movement.',
        explanationTa:
            'மகாத்மா காந்தி மார்ச் 12, 1930 அன்று தண்டி யாத்திரையைத் தொடங்கி ஏப்ரல் 6, 1930-ல் தண்டியை அடைந்து உப்புச் சட்டத்தை முறித்தார். இது சட்டமறுப்பு இயக்கத்தின் தொடக்கமாகும்.',
        hasOptionE: false,
      ),

      // 20. Indian History & Tamil Heritage (Brihadisvara Temple - TNPSC 5 Options)
      const Question(
        id: 'ga_05',
        subject: 'General Awareness',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'Which Chola emperor commissioned the construction of the renowned Brihadisvara Temple (Peruvudaiyar Koyil) in Thanjavur in 1010 CE?',
        questionTa:
            'கி.பி. 1010-ல் தஞ்சாவூர் பிரகதீஸ்வரர் கோயிலைக் (பெருவுடையார் கோயில்) கட்டிய சோழப் பேரரசர் யார்?',
        optionsEn: [
          'Raja Raja Chola I',
          'Rajendra Chola I',
          'Kulothunga Chola I',
          'Parantaka Chola I',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'முதலாம் இராஜராஜ சோழன்',
          'முதலாம் இராஜேந்திர சோழன்',
          'முதலாம் குலோத்துங்க சோழன்',
          'முதலாம் பராந்தக சோழன்',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Raja Raja Chola I constructed the magnificent granite Brihadisvara Temple at Thanjavur, recognized today as a UNESCO World Heritage Site.',
        explanationTa:
            'முதலாம் இராஜராஜ சோழன் கி.பி. 1010-ல் தஞ்சைப் பெருவுடையார் கோயிலைக் கட்டி முடித்தார். இது யுனெஸ்கோ உலக பாரம்பரிய தளமாகும்.',
        hasOptionE: true,
      ),

      // 21. Current Affairs (Space Mission - Aditya-L1)
      const Question(
        id: 'ga_06',
        subject: 'General Awareness',
        category: 'General Awareness',
        examType: 'ssc_cgl',
        questionEn:
            "What is the name of ISRO's maiden dedicated solar observatory mission launched to study the Sun from the Sun-Earth L1 point?",
        questionTa:
            'சூரியனை ஆய்வு செய்வதற்காக சூரியன்-பூமி L1 புள்ளியில் நிலைநிறுத்தப்பட்ட இஸ்ரோவின் (ISRO) முதல் சூரிய ஆய்வு விண்கலத்தின் பெயர் என்ன?',
        optionsEn: ['Aditya-L1', 'Chandrayaan-3', 'XPoSat', 'Gaganyaan'],
        optionsTa: ['ஆதித்யா-L1', 'சந்திரயான்-3', 'எக்ஸ்போசாட் (XPoSat)', 'ககன்யான்'],
        correctIndex: 0,
        explanationEn:
            'Aditya-L1 is ISRO’s first space-based solar mission, successfully stationed in a halo orbit around Lagrange Point 1 (L1) to monitor the solar atmosphere.',
        explanationTa:
            'ஆதித்யா-L1 விண்கலம் இஸ்ரோவின் முதல் சூரிய ஆய்வுத் திட்டமாகும். இது சூரியன்-பூமியின் லாக்ராஞ்சியன் புள்ளி 1 (L1) வட்டப்பாதையில் வெற்றிகரமாக நிலைநிறுத்தப்பட்டுள்ளது.',
        hasOptionE: false,
      ),

      // 22. General Science (Physics - Ohm's Law)
      const Question(
        id: 'ga_07',
        subject: 'General Science',
        category: 'General Awareness',
        examType: 'rrb_ntpc',
        questionEn:
            'Which physical law states that electric current through a conductor between two points is directly proportional to the potential difference across the two points at constant temperature?',
        questionTa:
            'மாறா வெப்பநிலையில் ஒரு கடத்தியின் வழியே பாயும் மின்னோட்டம், அதன் முனைகளுக்கு இடைப்பட்ட மின்னழுத்த வேறுபாட்டிற்கு நேர்தகவில் இருக்கும் என்று கூறும் விதி எது?',
        optionsEn: ["Ohm's Law", "Coulomb's Law", "Faraday's Law", "Joule's Law"],
        optionsTa: ['ஓம் விதி', 'கூலும் விதி', 'ஃபாரடே விதி', 'ஜூல் விதி'],
        correctIndex: 0,
        explanationEn:
            'Ohm\'s Law states that V = IR (Voltage = Current × Resistance), where resistance remains constant under uniform physical conditions.',
        explanationTa:
            'ஓம் விதி (V = IR): மாறா வெப்பநிலையில் கடத்தியில் பாயும் மின்னோட்டம் (I) அதன் முனைகளுக்கு இடைப்பட்ட மின்னழுத்த வேறுபாட்டிற்கு (V) நேர்தகவில் அமையும்.',
        hasOptionE: false,
      ),

      // 23. General Science (Biology - Universal Blood Donor)
      const Question(
        id: 'ga_08',
        subject: 'General Science',
        category: 'General Awareness',
        examType: 'rrb_ntpc',
        questionEn:
            'Which human blood group is termed the "Universal Donor" because its red blood cells lack both A and B antigens as well as the Rh factor?',
        questionTa:
            'சிவப்பணுக்களில் A, B ஆன்டிஜென்கள் மற்றும் Rh காரணி இல்லாததால் "பொதுக் கொடையாளி" (Universal Donor) என்று அழைக்கப்படும் மனித இரத்த வகை எது?',
        optionsEn: ['O Negative (O-)', 'AB Positive (AB+)', 'A Positive (A+)', 'B Negative (B-)'],
        optionsTa: ['O நெகட்டிவ் (O-)', 'AB பாசிட்டிவ் (AB+)', 'A பாசிட்டிவ் (A+)', 'B நெகட்டிவ் (B-)'],
        correctIndex: 0,
        explanationEn:
            'O Negative blood lacks A, B, and Rh surface antigens on RBCs, making it universally compatible for emergency blood transfusions.',
        explanationTa:
            'O- இரத்த வகையின் சிவப்பணுக்களில் A, B மற்றும் Rh ஆன்டிஜென்கள் இல்லாததால், இது எந்த வகை இரத்தப் பிரிவு கொண்டவர்க்கும் பொருந்தக்கூடிய பொதுக் கொடையாளி இரத்தமாகும்.',
        hasOptionE: false,
      ),

      // =========================================================================
      // GENERAL TAMIL & ENGLISH (TNPSC Ilakkanam/Ilakkiyam + SSC/Banking Grammar)
      // =========================================================================

      // 24. TNPSC Tamil Ilakkanam (வல்லினம் மிகும் இடங்கள் - 5 Options)
      const Question(
        id: 'lang_01',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'According to standard Tamil grammatical rules, in which of the following positions does "Vallinam" (வல்லினம்: க், ச், த், ப்) MANDATORILY double (வல்லினம் மிகும்)?',
        questionTa:
            'தமிழ் இலக்கண விதிப்படி, பின்வருவனவற்றுள் வல்லினம் (க், ச், த், ப்) கண்டிப்பாக மிகும் இடம் எது?',
        optionsEn: [
          'After demonstrative adjectives "அந்த", "இந்த" (எ.கா. அந்தப் பையன்)',
          'In second case nominative compound without marker (எ.கா. நாடு கண்டான்)',
          'After the interrogative word "எத்தனை" (எ.கா. எத்தனை புத்தகம்)',
          'In verb root compounds known as Vinaithogai (எ.கா. ஊறுகாய்)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'அகர, இகர சுட்டுப்பெயர்களின் பின் (எ.கா. அந்தப் பையன், இந்தச் சட்டை)',
          'இரண்டாம் வேற்றுமைத் தொகையில் (எ.கா. நாடு கண்டான்)',
          'எத்தனை என்ற வினாச்சொல்லின் பின் (எ.கா. எத்தனை புத்தகம்)',
          'வினைத்தொகையில் (எ.கா. ஊறுகாய்)',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Vallinam always doubles after demonstrative bases "அந்த", "இந்த" and interrogative base "எந்த" (e.g. அந்த + புத்தகம் = அந்தப் புத்தகம்).',
        explanationTa:
            '"அந்த, இந்த" என்ற சுட்டுப் பெயர்களின் பின்னும், "எந்த" என்ற வினாப் பெயரின் பின்னும் வல்லினம் மிகும் (எ.கா: அந்த + புத்தகம் = அந்தப் புத்தகம்).',
        hasOptionE: true,
      ),

      // 25. TNPSC Tamil Ilakkanam (பகுபத உறுப்பிலக்கணம் - 5 Options)
      const Question(
        id: 'lang_02',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'In the grammatical analysis (பகுபத உறுப்பிலக்கணம்) of the word "வந்தனன்" [வா(வ) + த்(ந்) + த் + அன் + அன்], what is the role of the first "அன்"?',
        questionTa:
            '"வந்தனன்" [வா(வ) + த்(ந்) + த் + அன் + அன்] என்ற சொல்லின் பகுபத உறுப்பிலக்கணத்தில் முதலாவதாக வரும் "அன்" என்பது எவ்வகை உறுப்பு?',
        optionsEn: [
          'Saariyai (சாரியை)',
          'Idainilai (இடைநிலை)',
          'Vikruthi (விகுதி)',
          'Sandhi (சந்தி)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'சாரியை',
          'இடைநிலை',
          'விகுதி',
          'சந்தி',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'In "வந்தனன்": வா(வ)=பகுதி, த்(ந்)=சந்தி, த்=இறந்தகால இடைநிலை, அன்=சாரியை (connective particle), அன்=ஆண்பால் வினைமுற்று விகுதி.',
        explanationTa:
            '"வந்தனன்" என்பதில் இறந்தகால இடைநிலையான "த்" என்பதற்கும், விகுதியான "அன்" என்பதற்கும் இடையே வந்துள்ள "அன்" என்பது சாரியை ஆகும்.',
        hasOptionE: true,
      ),

      // 26. TNPSC Tamil Ilakkiyam (திருக்குறள் அணி இலக்கணம் - 5 Options)
      const Question(
        id: 'lang_03',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn:
            '"எப்பொருள் யார்யார்வாய்க் கேட்பினும் அப்பொருள் மெய்ப்பொருள் காண்ப தறிவு" - Which poetic figure of speech (அணி) is employed in this Kural?',
        questionTa:
            '"எப்பொருள் யார்யார்வாய்க் கேட்பினும் அப்பொருள் மெய்ப்பொருள் காண்ப தறிவு" - இக்குறட்பாவில் பயின்று வந்துள்ள அணி எது?',
        optionsEn: [
          'Sol-Porul Pinvarunilai Ani (சொற்பொருள் பின்வருநிலையணி)',
          'Uvamai Ani (உவமையணி)',
          'Vetchorrumai Ani (வேற்றுமையணி)',
          'Pirithumozhithal Ani (பிரிதுமொழிதலணி)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'சொற்பொருள் பின்வருநிலையணி',
          'உவமையணி',
          'வேற்றுமையணி',
          'பிரிதுமொழிதலணி',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'In this Kural, the word "பொருள்" repeats multiple times conveying the identical meaning (essence/truth), exemplifying Sol-Porul Pinvarunilai Ani.',
        explanationTa:
            'இக்குறளில் "பொருள்" என்ற சொல் பலமுறை வந்து உண்மை/உண்மைப்பொருள் என்ற ஒரே பொருளைத் தருவதால் இது சொற்பொருள் பின்வருநிலையணி ஆகும்.',
        hasOptionE: true,
      ),

      // 27. TNPSC Tamil Ilakkiyam (எட்டுத்தொகை புறநானூறு - 5 Options)
      const Question(
        id: 'lang_04',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'From which ancient Sangam Tamil anthology is the universal humanitarian anthem "யாதும் ஊரே யாவரும் கேளிர்" (Every town is my home, all people are my kin) taken?',
        questionTa:
            '"யாதும் ஊரே யாவரும் கேளிர்" என்ற வரலாற்றுப் புகழ்மிக்க உலகளாவிய பொதுமைப் பாடல் வரிகள் இடம்பெற்றுள்ள சங்க நூல் எது?',
        optionsEn: [
          'Purananuru (புறநானூறு)',
          'Agananuru (அகநானூறு)',
          'Natrinai (நற்றிணை)',
          'Kurunthogai (குறுந்தொகை)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'புறநானூறு',
          'அகநானூறு',
          'நற்றிணை',
          'குறுந்தொகை',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Composed by Kaniyan Poongundranar, this immortal verse is Song 192 in the Sangam classic Purananuru.',
        explanationTa:
            'இப்பாடல் புறநானூற்றின் 192-வது பாடலாக கணியன் பூங்குன்றனாரால் இயற்றப்பட்டது. மனித குலத்தின் உலகளாவிய சகோதரத்துவத்தை இது பறைசாற்றுகிறது.',
        hasOptionE: true,
      ),

      // 28. English Grammar (Subject-Verb Agreement - Banking/SSC)
      const Question(
        id: 'lang_05',
        subject: 'General English',
        category: 'General Tamil & English',
        examType: 'ibps_sbi_clerk',
        questionEn:
            'Choose the grammatically correct sentence conforming to standard Subject-Verb Agreement rules:',
        questionTa:
            'சரியான ஆங்கில இலக்கண விதிக்கு (Subject-Verb Agreement) உட்பட்ட வாக்கியத்தைத் தேர்வு செய்க:',
        optionsEn: [
          'Neither the manager nor the team members were present at the meeting.',
          'Neither the manager nor the team members was present at the meeting.',
          'Each of the students have submitted their assignment on time.',
          'A panel of judges are announcing the final results right now.',
        ],
        optionsTa: [
          'Neither the manager nor the team members were present at the meeting.',
          'Neither the manager nor the team members was present at the meeting.',
          'Each of the students have submitted their assignment on time.',
          'A panel of judges are announcing the final results right now.',
        ],
        correctIndex: 0,
        explanationEn:
            'When two subjects are connected by "Neither... nor", the verb agrees with the closer subject ("team members" is plural -> "were"). "Each" requires singular "has", and collective noun "panel" takes singular "is".',
        explanationTa:
            '"Neither... nor" இணைப்பில், வினைச்சொல் தனக்கு மிக அருகில் உள்ள பெயர்ச்சொல்லுடன் உடன்படும் ("team members" பன்மை என்பதால் "were" சரியானது).',
        hasOptionE: false,
      ),

      // 29. English Grammar (Idioms & Phrases - SSC/Banking)
      const Question(
        id: 'lang_06',
        subject: 'General English',
        category: 'General Tamil & English',
        examType: 'ssc_cgl',
        questionEn:
            'What is the precise meaning of the common English idiom "A blessing in disguise"?',
        questionTa:
            '"A blessing in disguise" என்ற புகழ்பெற்ற ஆங்கில மரபுத்தொடரின் (Idiom) சரியான பொருள் என்ன?',
        optionsEn: [
          'An apparent misfortune that eventually results in something good',
          'A secret gift presented by an anonymous benefactor',
          'A spiritual prayer granted during an arduous journey',
          'An unexpected financial calamity that causes distress',
        ],
        optionsTa: [
          'ஆரம்பத்தில் துன்பமாகத் தோன்றி இறுதியில் நன்மையாக முடியும் நிகழ்வு',
          'அடையாளம் தெரியாத நபரால் வழங்கப்படும் ரகசிய அன்பளிப்பு',
          'பயணத்தின் போது பெறப்படும் ஆன்மீக ஆசீர்வாதம்',
          'எதிர்பாராத நிதி இழப்பை ஏற்படுத்தும் நிகழ்வு',
        ],
        correctIndex: 0,
        explanationEn:
            '"A blessing in disguise" denotes a misfortune or problem that at first seems bad, but later brings about advantageous or positive results.',
        explanationTa:
            'துவக்கத்தில் கெடுதலாகத் தெரிந்தாலும், பின்னர் மிகப்பெரிய நன்மையாகவோ வெற்றியாகவோ மாறும் ஒரு சூழ்நிலையை இது குறிக்கும்.',
        hasOptionE: false,
      ),

      // 30. English Grammar (Active to Passive Voice - SSC)
      const Question(
        id: 'lang_07',
        subject: 'General English',
        category: 'General Tamil & English',
        examType: 'ssc_cgl',
        questionEn:
            'Convert the active sentence into the correct passive voice:\n"The chief architect designed the entire stadium in three months."',
        questionTa:
            'கொடுக்கப்பட்டுள்ள செய்வினை வாக்கியத்தைச் சரியான செயப்பாட்டு வினையாக மாற்றுக:\n"The chief architect designed the entire stadium in three months."',
        optionsEn: [
          'The entire stadium was designed by the chief architect in three months.',
          'The entire stadium had been designed by the chief architect in three months.',
          'The entire stadium is designed by the chief architect in three months.',
          'The entire stadium was being designed by the chief architect in three months.',
        ],
        optionsTa: [
          'The entire stadium was designed by the chief architect in three months.',
          'The entire stadium had been designed by the chief architect in three months.',
          'The entire stadium is designed by the chief architect in three months.',
          'The entire stadium was being designed by the chief architect in three months.',
        ],
        correctIndex: 0,
        explanationEn:
            'Simple past tense active ("designed") converts to "was/were + past participle" in passive voice ("was designed").',
        explanationTa:
            'இறந்த காலச் செய்வினை ("designed") செயப்பாட்டு வினையாக மாறும்போது "was designed" என மாறும்.',
        hasOptionE: false,
      ),
    ];
  }

  // =========================================================================
  // AUTHENTIC UPSC CIVIL SERVICES (CSE GS-1 & CSAT) BILINGUAL QUESTION PAPERS
  // =========================================================================
  static List<Question> getUpscQuestions() {
    return const [
      // 1. UPSC CSE GS-1: Indian Polity - Basic Structure Doctrine
      Question(
        id: 'upsc_01',
        subject: 'Indian Polity & Governance',
        category: 'General Awareness',
        examType: 'upsc_cse_prelims_gs',
        questionEn:
            'With reference to the Constitution of India, which of the following statements is correct regarding the "Basic Structure Doctrine"?',
        questionTa:
            'இந்திய அரசியலமைப்பைப் பொறுத்தவரை, "அடிப்படை கட்டமைப்பு கோட்பாடு" (Basic Structure Doctrine) குறித்து பின்வருவனவற்றில் எது சரியானது?',
        optionsEn: [
          'It was propounded by the Supreme Court in the Kesavananda Bharati case (1973).',
          'It is explicitly defined under Article 368 of the Constitution.',
          'Parliament has unchecked constituent power to alter any part of the Constitution.',
          'The President has the sole power to decide the basic structure of the Constitution.',
        ],
        optionsTa: [
          'கேசவானந்த பாரதி வழக்கில் (1973) உச்ச நீதிமன்றத்தால் இது வகுக்கப்பட்டது.',
          'இது அரசியலமைப்பின் 368-வது பிரிவில் வெளிப்படையாக வரையறுக்கப்பட்டுள்ளது.',
          'பாராளுமன்றம் அரசியலமைப்பின் எந்தப் பகுதியையும் மாற்ற வரம்பற்ற அதிகாரம் கொண்டுள்ளது.',
          'அரசியலமைப்பின் அடிப்படை கட்டமைப்பை தீர்மானிக்கும் முழு அதிகாரம் குடியரசுத் தலைவருக்கே உள்ளது.',
        ],
        correctIndex: 0,
        explanationEn:
            'In Kesavananda Bharati v. State of Kerala (1973), a historic 13-judge bench of the Supreme Court ruled that while Parliament can amend any part of the Constitution under Article 368, it cannot alter its basic structure or foundational framework.',
        explanationTa:
            'கேசவானந்த பாரதி எதிர் கேரள அரசு (1973) வழக்கில், அரசியலமைப்பின் 368-வது பிரிவின் கீழ் பாராளுமன்றம் சட்டத்திருத்தம் செய்ய அதிகாரம் பெற்றிருந்தாலும், அதன் அடிப்படை கட்டமைப்பை மாற்ற முடியாது என்று உச்ச நீதிமன்றம் வரலாற்றுச் சிறப்புமிக்க தீர்ப்பை வழங்கியது.',
        hasOptionE: false,
      ),

      // 2. UPSC CSE GS-1: Indian Polity - Money Bill Powers (Art 109/110)
      Question(
        id: 'upsc_02',
        subject: 'Indian Polity & Governance',
        category: 'General Awareness',
        examType: 'upsc_cse_prelims_gs',
        questionEn:
            'Regarding a "Money Bill" in the Indian Parliament, consider which of the following provisions is accurate under the Constitution:',
        questionTa:
            'இந்திய நாடாளுமன்றத்தில் "பண மசோதா" (Money Bill) தொடர்பாக அரசியலமைப்பின் கீழ் பின்வரும் விதிகளில் எது சரியானது?',
        optionsEn: [
          'Rajya Sabha cannot amend or reject a Money Bill; it must return it within 14 days.',
          'A Money Bill can be introduced in either House of Parliament with President approval.',
          'Rajya Sabha has co-equal veto power with Lok Sabha regarding Money Bills.',
          'The President can withhold assent and send a Money Bill back for parliamentary reconsideration.',
        ],
        optionsTa: [
          'மாநிலங்களவை பண மசோதாவை திருத்தவோ நிராகரிக்கவோ முடியாது; 14 நாட்களுக்குள் திருப்பி அனுப்ப வேண்டும்.',
          'குடியரசுத் தலைவர் அனுமதியுடன் பண மசோதாவை நாடாளுமன்றத்தின் எந்த அவையிலும் தாக்கல் செய்யலாம்.',
          'பண மசோதாக்கள் விவகாரத்தில் மாநிலங்களவை மக்களவைக்கு இணையான வீட்டோ அதிகாரத்தைக் கொண்டுள்ளது.',
          'குடியரசுத் தலைவர் பண மசோதாவை மறுபரிசீலனைக்கு நாடாளுமன்றத்திற்கு திருப்பி அனுப்பலாம்.',
        ],
        correctIndex: 0,
        explanationEn:
            'Under Article 109, a Money Bill can only be introduced in the Lok Sabha. Rajya Sabha has 14 days to recommend changes; Lok Sabha may accept or reject them. If not returned in 14 days, it is deemed passed by both Houses.',
        explanationTa:
            'அரசியலமைப்புப் பிரிவு 109-ன் படி, பண மசோதாவை மக்களவையில் மட்டுமே தாக்கல் செய்ய முடியும். மாநிலங்களவை 14 நாட்களுக்குள் பரிந்துரைகளை மட்டுமே வழங்கலாம்; அதை ஏற்கவோ நிராகரிக்கவோ மக்களவைக்கு அதிகாரம் உண்டு.',
        hasOptionE: false,
      ),

      // 3. UPSC CSE GS-1: Ancient Indian History - Dholavira Water Harvesting
      Question(
        id: 'upsc_03',
        subject: 'Indian History & Culture',
        category: 'General Awareness',
        examType: 'upsc_cse_prelims_gs',
        questionEn:
            'Which one of the following Harappan sites is renowned for its elaborate system of water harvesting and management by building a series of dams and channelizing water into interconnected rock-cut reservoirs?',
        questionTa:
            'தொடர்ச்சியான அணைகளைக் கட்டி, இணைக்கப்பட்ட பாறைக்குடைவு நீர்த்தேக்கங்களில் தண்ணீரைத் திருப்பி சேமித்து நிர்வகிக்கும் அதிநவீன நீர் மேலாண்மை முறைக்கு பெயர் பெற்ற புகழ்பெற்ற சிந்து சமவெளி (ஹரப்பா) தளம் எது?',
        optionsEn: [
          'Dholavira (Rann of Kutch, Gujarat)',
          'Kalibangan (Rajasthan)',
          'Rakhigarhi (Haryana)',
          'Banawali (Fatehabad)',
        ],
        optionsTa: [
          'தோலாவிரா (கட்ச் வளைகுடா, குஜராத்)',
          'காலிபங்கன் (ராஜஸ்தான்)',
          'ராகிகர்கி (ஹரியானா)',
          'பனவாலி (ஃபதேஹாபாத்)',
        ],
        correctIndex: 0,
        explanationEn:
            'Dholavira, located in Khadir Bet in Gujarat, is world-famous for its monumental rock-cut water reservoirs, sophisticated rainwater harvesting dams, and storm water drainage engineering (UNESCO World Heritage Site).',
        explanationTa:
            'குஜராத்தின் கட்ச் பகுதியில் உள்ள தோலாவிரா, உலகின் மிகப் பழமையான பாறைக்குடைவு நீர்த்தேக்கங்கள், மழைநீர் சேகரிப்பு அணைகள் மற்றும் விரிவான வடிகால் அமைப்புக்கு பெயர் பெற்றது (யுனெஸ்கோ உலக பாரம்பரிய தளம்).',
        hasOptionE: false,
      ),

      // 4. UPSC CSE GS-1: Modern Indian History - Cripps Mission 1942
      Question(
        id: 'upsc_04',
        subject: 'Modern Indian History',
        category: 'General Awareness',
        examType: 'upsc_cse_prelims_gs',
        questionEn:
            'With reference to the Cripps Mission sent to India in March 1942, what was the constitutional status proposed for India following World War II?',
        questionTa:
            'மார்ச் 1942-ல் இந்தியாவிற்கு வந்த கிரிப்ஸ் தூதுக்குழுவைப் பொறுத்தவரை, இரண்டாம் உலகப் போருக்குப் பின் இந்தியாவிற்கு முன்மொழியப்பட்ட அரசியல் அந்தஸ்து எது?',
        optionsEn: [
          'Dominion status with freedom to secede from the British Commonwealth.',
          'Immediate complete independence with partition into India and Pakistan.',
          'Direct crown colony status under the British War Cabinet.',
          'An executive council with exclusively British military ministers.',
        ],
        optionsTa: [
          'பிரிட்டிஷ் காமன்வெல்த்தில் இருந்து வெளியேறும் சுதந்திரத்துடன் கூடிய டொமினியன் அந்தஸ்து (Dominion Status).',
          'உடனடி முழு சுதந்திரம் மற்றும் இந்தியா-பாகிஸ்தான் பிரிவினை.',
          'பிரிட்டிஷ் போர் அமைச்சரவையின் நேரடி காலனி ஆதிக்க அந்தஸ்து.',
          'முற்றிலும் பிரிட்டிஷ் ராணுவ அமைச்சர்களைக் கொண்ட நிர்வாக சபை.',
        ],
        correctIndex: 0,
        explanationEn:
            'Sir Stafford Cripps proposed Dominion Status for an Indian Union after the war, along with a constituent assembly. Mahatma Gandhi famously criticized it as a "post-dated cheque drawn on a crashing bank".',
        explanationTa:
            'சர் ஸ்டாஃபோர்ட் கிரிப்ஸ் போருக்குப் பின் இந்தியாவுக்கு தன்னாட்சி (டொமினியன்) அந்தஸ்து வழங்கப்படும் என உறுதியளித்தார். இதை மகாத்மா காந்தி "திவாலாகும் வங்கியின் பின்தேதியிட்ட காசோலை" என்று வர்ணித்தார்.',
        hasOptionE: false,
      ),

      // 5. UPSC CSE GS-1: Physical Geography - Mountain Passes of Western Ghats
      Question(
        id: 'upsc_05',
        subject: 'Physical & Indian Geography',
        category: 'General Awareness',
        examType: 'upsc_cse_prelims_gs',
        questionEn:
            'Which natural mountain pass in the Western Ghats connects Palakkad in Kerala with Coimbatore in Tamil Nadu?',
        questionTa:
            'மேற்குத் தொடர்ச்சி மலையில் கேரளாவின் பாலக்காட்டையும் தமிழ்நாட்டின் கோயம்புத்தூரையும் இணைக்கும் இயற்கை கணவாய் எது?',
        optionsEn: [
          'Palghat (Palakkad) Gap',
          'Thal Ghat (Kasara Ghat)',
          'Bhor Ghat',
          'Shencottah Gap',
        ],
        optionsTa: [
          'பாலக்காட்டு கணவாய் (Palghat Gap)',
          'தால் கணவாய் (Thal Ghat)',
          'போர் கணவாய் (Bhor Ghat)',
          'செங்கோட்டை கணவாய் (Shencottah Gap)',
        ],
        correctIndex: 0,
        explanationEn:
            'The Palghat Gap is a significant break (approx. 30 km wide) in the Western Ghats between the Nilgiri Hills to the north and Anaimalai Hills to the south, serving as a primary transportation and monsoon funnel corridor.',
        explanationTa:
            'பாலக்காட்டு கணவாய் என்பது நீலகிரி மற்றும் ஆனைமலை குன்றுகளுக்கு இடையே உள்ள சுமார் 30 கி.மீ அகலமுள்ள முக்கிய இயற்கை கணவாயாகும். இது தென்மேற்கு பருவக்காற்று தமிழகத்திற்குள் நுழையவும் போக்குவரத்துக்கும் பெருமளவு உதவுகிறது.',
        hasOptionE: false,
      ),

      // 6. UPSC CSE GS-1: Environment & Ecology - Ramsar Convention
      Question(
        id: 'upsc_06',
        subject: 'Environment & Ecology',
        category: 'General Awareness',
        examType: 'upsc_cse_prelims_gs',
        questionEn:
            'Consider the following statements regarding the Ramsar Convention on Wetlands (1971): which statement is correct?',
        questionTa:
            'ஈரநிலங்களுக்கான ராம்சார் உடன்படிக்கை (Ramsar Convention 1971) தொடர்பான பின்வரும் கூற்றுகளில் எது சரியானது?',
        optionsEn: [
          'It is an international treaty for the conservation and sustainable "wise use" of wetlands and their resources.',
          'India is not a signatory to the Ramsar Convention.',
          'Ramsar sites can only be located in inland high-altitude freshwater lakes.',
          'The Montreux Record only maintains a registry of newly formed volcanic lakes.',
        ],
        optionsTa: [
          'இது சதுப்பு நிலங்கள் மற்றும் அவற்றின் வளங்களைப் பாதுகாப்பதற்கும் நிலையான "விவேகமான பயன்பாட்டிற்கும்" வழிகாட்டும் சர்வதேச ஒப்பந்தமாகும்.',
          'இந்தியா ராம்சார் உடன்படிக்கையில் கையெழுத்திடாத நாடாகும்.',
          'ராம்சார் தளங்கள் உள்நாட்டு உயரமான நன்னீர் ஏரிகளில் மட்டுமே அமைய முடியும்.',
          'மான்ட்ராக்ஸ் பதிவு புதிதாக உருவான எரிமலை ஏரிகளை மட்டுமே பதிவு செய்கிறது.',
        ],
        correctIndex: 0,
        explanationEn:
            'Adopted in Ramsar, Iran in 1971, the Ramsar Convention is the only global treaty dedicated to wetland conservation and "wise use". India joined in 1982 and boasts over 80 designated Ramsar sites including Sundarbans and Chilika Lake.',
        explanationTa:
            '1971-ல் ஈரானின் ராம்சார் நகரில் கையெழுத்திடப்பட்ட இந்த ஒப்பந்தம், சதுப்பு நிலங்களின் பாதுகாப்பு மற்றும் விவேகமான பயன்பாட்டிற்கு வழிகாட்டுகிறது. இந்தியா 1982-ல் இதில் இணைந்தது.',
        hasOptionE: false,
      ),

      // 7. UPSC CSE GS-1: Indian Economy - Monetary Policy Committee
      Question(
        id: 'upsc_07',
        subject: 'Indian Economy & Banking',
        category: 'General Awareness',
        examType: 'upsc_cse_prelims_gs',
        questionEn:
            'In India, the Policy Repo Rate under the statutory Flexible Inflation Targeting framework is determined by which authority?',
        questionTa:
            'இந்தியாவில் சட்டப்பூர்வ நெகிழ்வான பணவீக்க இலக்கு கட்டமைப்பின் (Inflation Targeting) கீழ் கொள்கை ரெப்போ விகிதத்தை (Repo Rate) நிர்ணயிக்கும் அதிகாரம் கொண்ட அமைப்பு எது?',
        optionsEn: [
          'Monetary Policy Committee (MPC) headed by the RBI Governor',
          'Union Ministry of Finance Department of Economic Affairs',
          'NITI Aayog Governing Council',
          'Financial Stability and Development Council (FSDC)',
        ],
        optionsTa: [
          'ஆர்பிஐ ஆளுநர் தலைமையிலான பணவியல் கொள்கைக் குழு (Monetary Policy Committee - MPC)',
          'மத்திய நிதி அமைச்சகத்தின் பொருளாதார விவகாரங்கள் துறை',
          'நிதி ஆயோக் நிர்வாகக் குழு (NITI Aayog)',
          'நிதி நிலைத்தன்மை மற்றும் மேம்பாட்டு கவுன்சில் (FSDC)',
        ],
        correctIndex: 0,
        explanationEn:
            'Under Section 45ZB of the Reserve Bank of India Act, 1934, the 6-member Monetary Policy Committee (MPC) fixes the benchmark Policy Repo Rate to contain Consumer Price Index (CPI) inflation within the mandated target band of 4% (+/- 2%).',
        explanationTa:
            'ஆர்பிஐ சட்டம் 1934-ன் பிரிவு 45ZB-ன் கீழ் அமைக்கப்பட்ட 6 உறுப்பினர்களைக் கொண்ட பணவியல் கொள்கைக் குழு (MPC), சில்லறை பணவீக்கத்தை 4% (+/- 2%) வரம்பிற்குள் வைத்திருக்க ரெப்போ விகிதத்தை நிர்ணயிக்கிறது.',
        hasOptionE: false,
      ),

      // 8. UPSC CSAT (GS-2): Critical Reading Comprehension & Inference
      Question(
        id: 'upsc_08',
        subject: 'CSAT Comprehension',
        category: 'Logical Reasoning',
        examType: 'upsc_cse_csat',
        questionEn:
            '"Economic growth without social justice creates extreme wealth concentration, structural inequality, and fragile institutions. Genuine national progress requires expanding substantive human capabilities, healthcare access, and quality education." Which of the following is the most logical corollary from the passage?',
        questionTa:
            '"சமூக நீதியற்ற பொருளாதார வளர்ச்சி தீவிர செல்வக் குவிப்பையும், கட்டமைப்பு சமத்துவமின்மையையும் உருவாக்குகிறது. உண்மையான தேசிய வளர்ச்சி என்பது மனித திறன்கள், சுகாதார வசதிகள் மற்றும் தரமான கல்வியை விரிவாக்குவதாகும்." மேற்கண்ட பத்தியிலிருந்து பெறப்படும் மிகவும் தர்க்கரீதியான முடிவு எது?',
        optionsEn: [
          'Gross Domestic Product (GDP) growth alone is an incomplete measure of real human well-being and development.',
          'Industrial investment must be immediately banned to achieve equitable wealth distribution.',
          'Free market competition automatically eliminates structural social inequalities without government intervention.',
          'Developing countries should abandon infrastructure modernization completely.',
        ],
        optionsTa: [
          'மொத்த உள்நாட்டு உற்பத்தி (GDP) வளர்ச்சி மட்டுமே உண்மையான மனித நல்வாழ்வு மற்றும் வளர்ச்சியை அளவிட போதுமானதல்ல.',
          'சமமான செல்வப் பகிர்வை அடைய தொழில்துறை முதலீடுகளை உடனடியாக தடை செய்ய வேண்டும்.',
          'தடையற்ற சந்தை போட்டி அரசின் தலையீடு இன்றியே கட்டமைப்பு ஏற்றத்தாழ்வுகளை தானாகவே நீக்கிவிடும்.',
          'வளரும் நாடுகள் உள்கட்டமைப்பு நவீனமயமாக்கலை முற்றிலும் கைவிட வேண்டும்.',
        ],
        correctIndex: 0,
        explanationEn:
            'The passage underscores that macroeconomic expansion (GDP growth) is fundamentally insufficient without human capability enhancement (Amartya Sen capability approach). Hence, GDP alone cannot gauge true development.',
        explanationTa:
            'பொருளாதார வளர்ச்சி மட்டுமே போதாது, மனித திறன்களின் மேம்பாடே உண்மையான வளர்ச்சி என்ற அமர்த்தியா சென்னின் கோட்பாட்டை இந்த பத்தி விளக்குகிறது. எனவே ஜிடிபி வளர்ச்சி மட்டுமே உண்மையான மனித வளர்ச்சியை அளவிட முடியாது.',
        hasOptionE: false,
      ),

      // 9. UPSC CSAT (GS-2): Logical Deduction & Analytical Reasoning
      Question(
        id: 'upsc_09',
        subject: 'CSAT Logical Reasoning',
        category: 'Logical Reasoning',
        examType: 'upsc_cse_csat',
        questionEn:
            'Statements:\n1. All Civil Servants are ethical administrators.\n2. Some ethical administrators are technology innovators.\n\nConclusions:\nI. Some technology innovators are ethical administrators.\nII. All Civil Servants are technology innovators.\n\nWhich of the conclusion(s) logically follows?',
        questionTa:
            'கூற்றுகள்:\n1. அனைத்து குடிமைப் பணியாளர்களும் நேர்மையான நிர்வாகிகள்.\n2. சில நேர்மையான நிர்வாகிகள் தொழில்நுட்ப கண்டுபிடிப்பாளர்கள்.\n\nமுடிவுகள்:\nI. சில தொழில்நுட்ப கண்டுபிடிப்பாளர்கள் நேர்மையான நிர்வாகிகள்.\nII. அனைத்து குடிமைப் பணியாளர்களும் தொழில்நுட்ப கண்டுபிடிப்பாளர்கள்.\n\nஎந்த முடிவு(கள்) தர்க்கரீதியாக சரியானது?',
        optionsEn: [
          'Only Conclusion I follows.',
          'Only Conclusion II follows.',
          'Both Conclusions I and II follow.',
          'Neither Conclusion I nor II follows.',
        ],
        optionsTa: [
          'முடிவு I மட்டுமே சரியானது.',
          'முடிவு II மட்டுமே சரியானது.',
          'முடிவுகள் I மற்றும் II ஆகிய இரண்டும் சரியானவை.',
          'முடிவு I மற்றும் II இரண்டும் தவறானவை.',
        ],
        correctIndex: 0,
        explanationEn:
            'By rules of immediate categorical inference, Statement 2 ("Some A are B") converts validly to "Some B are A" (Conclusion I follows). There is no distributed link between All Civil Servants and technology innovators (Conclusion II is invalid).',
        explanationTa:
            'தர்க்க விதிகளின்படி, "சில A, B ஆகும்" என்பது "சில B, A ஆகும்" என நேரடியாக மாறும் (முடிவு I சரி). ஆனால் அனைத்து குடிமைப் பணியாளர்களும் கண்டுபிடிப்பாளர்கள் என்று கூற முடியாது (முடிவு II தவறு).',
        hasOptionE: false,
      ),

      // 10. UPSC CSAT (GS-2): Quantitative Aptitude - Negative Marking Equation
      Question(
        id: 'upsc_10',
        subject: 'CSAT Basic Numeracy',
        category: 'Quantitative Aptitude',
        examType: 'upsc_cse_csat',
        questionEn:
            'In a competitive examination consisting of 80 objective questions, each correct answer is awarded 2.5 marks, while 0.833 marks (1/3rd penalty) are deducted for each incorrect answer. A candidate attempts all 80 questions and scores 140 marks. How many questions did the candidate answer correctly?',
        questionTa:
            '80 புறவய வினாக்களைக் கொண்ட ஒரு போட்டித் தேர்வில், ஒவ்வொரு சரியான பதிலுக்கும் 2.5 மதிப்பெண்கள் வழங்கப்படுகின்றன, மேலும் ஒவ்வொரு தவறான பதிலுக்கும் 0.833 மதிப்பெண்கள் (1/3 அபராதம்) கழிக்கப்படுகின்றன. ஒரு தேர்வர் அனைத்து 80 கேள்விகளுக்கும் விடையளித்து 140 மதிப்பெண்கள் பெறுகிறார் எனில், அவர் சரியாக விடையளித்த கேள்விகள் எத்தனை?',
        optionsEn: ['62', '58', '66', '54'],
        optionsTa: ['62', '58', '66', '54'],
        correctIndex: 0,
        explanationEn:
            'Let C = correct answers and W = (80 - C) wrong answers.\nScore = 2.5*C - (2.5/3)*(80 - C) = 140.\nMultiply by 3:\n7.5*C - 2.5*(80 - C) = 420\n7.5*C - 200 + 2.5*C = 420\n10*C = 620 => C = 62 correct answers.',
        explanationTa:
            'சரியான பதில்கள் = C, தவறான பதில்கள் = 80 - C.\n2.5*C - (2.5/3)*(80 - C) = 140.\nஇருபுறமும் 3-ஆல் பெருக்க:\n7.5*C - 2.5*(80 - C) = 420\n10*C - 200 = 420 => 10*C = 620 => C = 62 கேள்விகள் சரி.',
        hasOptionE: false,
      ),

      // 11. UPSC CDS: Defence Technology - LCA Tejas
      Question(
        id: 'upsc_11',
        subject: 'Defence & Security',
        category: 'General Awareness',
        examType: 'upsc_cds',
        questionEn:
            'Which indigenous 4.5 generation, single-engine, delta-wing multirole light fighter aircraft was designed by the Aeronautical Development Agency (ADA) and manufactured by Hindustan Aeronautics Limited (HAL) for the Indian Armed Forces?',
        questionTa:
            'இந்திய ஆயுதப் படைகளுக்காக ஏரோநாட்டிகல் டெவலப்மென்ட் ஏஜென்சியால் (ADA) வடிவமைக்கப்பட்டு, இந்துஸ்தான் ஏரோநாட்டிக்ஸ் லிமிடெட் (HAL) நிறுவனத்தால் தயாரிக்கப்பட்ட உள்நாட்டு 4.5 தலைமுறை, ஒற்றை எஞ்சின் கொண்ட இலகுரக போர் விமானம் எது?',
        optionsEn: [
          'LCA Tejas',
          'Sukhoi Su-30MKI',
          'Mirage 2000',
          'Mikoyan MiG-29UPG',
        ],
        optionsTa: [
          'தேஜஸ் (LCA Tejas)',
          'சுகோய் Su-30MKI',
          'மிராஜ் 2000',
          'மிக்-29UPG',
        ],
        correctIndex: 0,
        explanationEn:
            'LCA Tejas is India\'s indigenous lightweight, multirole supersonic fighter jet with fly-by-wire flight control and advanced avionics, inducted into active squadrons of the Indian Air Force.',
        explanationTa:
            'தேஜஸ் (LCA Tejas) என்பது இந்தியாவின் உள்நாட்டு தயாரிப்பான அதிநவீன இலகுரக போர் விமானமாகும். இது இந்திய விமானப்படையின் முன்னணி படைப்பிரிவுகளில் சேர்க்கப்பட்டு வெற்றிகரமாக செயல்பட்டு வருகிறது.',
        hasOptionE: false,
      ),

      // 12. UPSC CSE GS-1: Science & Technology - Aditya-L1 Solar Mission
      Question(
        id: 'upsc_12',
        subject: 'Science & Technology',
        category: 'General Awareness',
        examType: 'upsc_cse_prelims_gs',
        questionEn:
            'India\'s first dedicated space-based solar observatory, Aditya-L1, was successfully placed into a halo orbit around which gravitational equilibrium point of the Sun-Earth system?',
        questionTa:
            'சூரியனை ஆய்வு செய்வதற்கான இந்தியாவின் முதல் விண்வெளி ஆய்வகமான ஆதித்யா-L1, சூரியன்-பூமி அமைப்பின் எந்த ஈர்ப்பு சமநிலை புள்ளியைச் சுற்றியுள்ள ஹாலோ சுற்றுப்பாதையில் நிலைநிறுத்தப்பட்டது?',
        optionsEn: [
          'Lagrange Point 1 (L1), roughly 1.5 million km from Earth',
          'Lagrange Point 2 (L2), behind the Earth',
          'Lagrange Point 4 (L4), leading Earth\'s orbit',
          'Geostationary Earth Orbit (GEO) at 35,786 km',
        ],
        optionsTa: [
          'பூமியிலிருந்து சுமார் 15 லட்சம் கி.மீ தூரத்திலுள்ள லாக்ராஞ்சியன் புள்ளி 1 (L1)',
          'பூமிக்கு பின்னால் உள்ள லாக்ராஞ்சியன் புள்ளி 2 (L2)',
          'பூமியின் சுற்றுப்பாதைக்கு முன்னால் உள்ள லாக்ராஞ்சியன் புள்ளி 4 (L4)',
          '35,786 கி.மீ உயரத்தில் உள்ள புவிசார் சுற்றுப்பாதை (GEO)',
        ],
        correctIndex: 0,
        explanationEn:
            'ISRO launched Aditya-L1 to the Sun-Earth L1 Lagrange point (1.5 million km from Earth) because a spacecraft placed in this halo orbit can continuously view the Sun without any occultations or eclipses.',
        explanationTa:
            'பூமியிலிருந்து 15 லட்சம் கி.மீ தொலைவில் உள்ள சூரியன்-பூமி L1 புள்ளியில் எவ்வித கிரகணத் தடைகளும் இன்றி சூரியனை 24 மணி நேரமும் தடையின்றி கண்காணிக்க முடியும் என்பதால் இஸ்ரோ ஆதித்யா-L1-ஐ அங்கு நிலைநிறுத்தியது.',
        hasOptionE: false,
      ),
    ];
  }
}
