import 'package:exam_arena_cbt/features/exam_engine/domain/models/question.dart';

/// Comprehensive, authentic bilingual question repository for all exam categories:
/// - TNPSC Group 2 & Group 4 (5 options with Option E: Answer Not Known)
/// - Railways RRB NTPC & Group D (4 options)
/// - Staff Selection Commission SSC CGL & CHSL (4 options)
/// - Banking & Insurance IBPS / SBI Clerk (4 options)
class ExpandedExamQuestions {
  static List<Question> getAllExpandedQuestions() {
    return [
      ...getTnpscQuestions(),
      ...getRrbQuestions(),
      ...getSscQuestions(),
      ...getBankingQuestions(),
    ];
  }

  // =========================================================================
  // 1. TNPSC GROUP 2 & GROUP 4 (Authentic Bilingual with 5-Option OMR)
  // =========================================================================
  static List<Question> getTnpscQuestions() {
    return const [
      // 1. Thirukkural - Ani Ilakkanam
      Question(
        id: 'tnpsc_exp_01',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'Which figure of speech (அணி) is employed in the Thirukkural: "அகர முதல எழுத்தெல்லாம் ஆதி பகவன் முதற்றே உலகு"?',
        questionTa:
            '"அகர முதல எழுத்தெல்லாம் ஆதி பகவன் முதற்றே உலகு" - இக்குறட்பாவில் பயின்று வந்துள்ள அணி யாது?',
        optionsEn: [
          'எடுத்துக்காட்டு உவமையணி (Illustrative Simile)',
          'உவமையணி (Simile)',
          'இல்பொருள் உவமையணி (Imaginary Simile)',
          'சொற்பொருள் பின்வருநிலையணி',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'எடுத்துக்காட்டு உவமையணி',
          'உவமையணி',
          'இல்பொருள் உவமையணி',
          'சொற்பொருள் பின்வருநிலையணி',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'In this Kural, letters beginning with "A" is compared to the world beginning with God, with the simile marker (உவம உருபு) implied rather than explicitly stated, making it an Illustrative Simile (எடுத்துக்காட்டு உவமையணி).',
        explanationTa:
            'எழுத்துகளுக்கு அகரம் முதன்மையாக இருப்பது போல உலகிற்கு இறைவன் முதன்மையாக இருக்கிறான் என உவம உருபு மறைந்து வந்துள்ளதால் இது எடுத்துக்காட்டு உவமையணி ஆகும்.',
        hasOptionE: true,
      ),

      // 2. Tamil Grammar - Noun Classification
      Question(
        id: 'tnpsc_exp_02',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn: 'In Tamil grammar, which type of noun (பெயர்ச்சொல்) is the word "கண்" (Eye)?',
        questionTa: 'தமிழ் இலக்கணத்தில் "கண்" என்பது எவ்வகை பெயர்ச்சொல் ஆகும்?',
        optionsEn: [
          'சினைப்பெயர் (Part / Organ Name)',
          'பொருட்பெயர் (Object Name)',
          'குணப்பெயர் (Quality / Attribute Name)',
          'தொழிற்பெயர் (Verbal / Action Noun)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'சினைப்பெயர்',
          'பொருட்பெயர்',
          'குணப்பெயர்',
          'தொழிற்பெயர்',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Nouns referring to limbs, parts, or organs of a living body (such as கண், கை, கால், இலை, கிளை) are categorized as சினைப்பெயர்.',
        explanationTa:
            'உயிரினங்கள் மற்றும் தாவரங்களின் உறுப்புகளைக் குறிக்கும் சொற்கள் (கண், கை, கிளை, இலை) சினைப்பெயர் எனப்படும்.',
        hasOptionE: true,
      ),

      // 3. Tamil Literature - Bharathidasan
      Question(
        id: 'tnpsc_exp_03',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'Who composed the famous immortal line: "தமிழுக்கும் அமுதென்று பேர் - அந்தத் தமிழ் இன்பத் தமிழ் எங்கள் உயிருக்கு நேர்"?',
        questionTa:
            '"தமிழுக்கும் அமுதென்று பேர் - அந்தத் தமிழ் இன்பத் தமிழ் எங்கள் உயிருக்கு நேர்" - என்ற தேனினும் இனிய பாடலை இயற்றிய புரட்சிக் கவிஞர் யார்?',
        optionsEn: [
          'பாரதிதாசன் (Bharathidasan)',
          'சுப்பிரமணிய பாரதியார் (Bharathiyar)',
          'நாமக்கல் கவிஞர் வெ. இராமலிங்கம் பிள்ளை',
          'கவிமணி தேசிக விநாயகம் பிள்ளை',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'பாரதிதாசன்',
          'சுப்பிரமணிய பாரதியார்',
          'நாமக்கல் கவிஞர் வெ. இராமலிங்கம் பிள்ளை',
          'கவிமணி தேசிக விநாயகம் பிள்ளை',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'This celebrated song on Tamil pride was composed by the Revolutionary Poet (புரட்சிக்கவிஞர்) Bharathidasan in his Tamil Ilakkiyam collection.',
        explanationTa:
            'தமிழ்மொழியின் மேன்மையை விளக்கும் இப்பாடல் புரட்சிக்கவிஞர் பாரதிதாசனால் இயற்றப்பட்டது.',
        hasOptionE: true,
      ),

      // 4. Sangam Literature - Ettuthogai First Work
      Question(
        id: 'tnpsc_exp_04',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'Which Sangam poetic anthology is traditionally placed first among the "Ettuthogai" (Eight Anthologies)?',
        questionTa:
            'பழந்தமிழின் எட்டுத்தொகை நூல்களுள் முதலாவதாக வைத்துப் போற்றப்படும் சங்க இலக்கிய நூல் எது?',
        optionsEn: [
          'நற்றிணை (Natrinai)',
          'குறுந்தொகை (Kurunthogai)',
          'ஐங்குறுநூறு (Ainkurunooru)',
          'பதிற்றுப்பத்து (Pathitrupathu)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'நற்றிணை',
          'குறுந்தொகை',
          'ஐங்குறுநூறு',
          'பதிற்றுப்பத்து',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'The traditional mnemonic verse states: "நற்றிணை நல்ல குறுந்தொகை ஐங்குறுநூறு ஒத்த பதிற்றுப்பத்து...", establishing Natrinai as the first among the Eight Anthologies.',
        explanationTa:
            '"நற்றிணை நல்ல குறுந்தொகை ஐங்குறுநூறு ஒத்த பதிற்றுப்பத்து..." என்ற பழம்பாடல் நற்றிணையை முதன்மையாகக் குறிப்பிடுகிறது.',
        hasOptionE: true,
      ),

      // 5. Tamil Scholars - U. Ve. Swaminatha Iyer
      Question(
        id: 'tnpsc_exp_05',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'Which revered scholar retrieved ancient palm-leaf manuscripts from oblivion and earned the affectionate title "Thamizh Thatha"?',
        questionTa:
            'பழந்தமிழ் ஓலைச்சுவடிகளை ஊர் ஊராகச் சென்று தேடித் தொகுத்து அச்சேற்றி "தமிழ்த் தாத்தா" என்று உலகத் தமிழர்களால் போற்றப்பட்டவர் யார்?',
        optionsEn: [
          'உ. வே. சாமிநாதையர் (U. Ve. Swaminatha Iyer)',
          'சி. வை. தாமோதரம்பிள்ளை',
          'மறைமலையடிகள்',
          'பரிதிமாற்கலைஞர்',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'உ. வே. சாமிநாதையர்',
          'சி. வை. தாமோதரம்பிள்ளை',
          'மறைமலையடிகள்',
          'பரிதிமாற்கலைஞர்',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Mahamahopadhyaya Dr. U. Ve. Swaminatha Iyer painstakingly collected, edited, and printed classical Tamil Sangam texts including Seevaga Chinthamani, Silappathikaram, and Purananooru, earning the title "Thamizh Thatha".',
        explanationTa:
            'ஓலைச்சுவடிகளில் மறைந்து கிடந்த சங்க இலக்கியங்களை தன் வாழ்நாளெல்லாம் உழைத்து அச்சேற்றிப் பதிப்பித்த உ.வே.சா அவர்கள் தமிழ்த் தாத்தா எனப் போற்றப்படுகிறார்.',
        hasOptionE: true,
      ),

      // 6. Unit 8: History & Culture - Justice Party Founding 1916
      Question(
        id: 'tnpsc_exp_06',
        subject: 'History & Culture of Tamil Nadu',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'In which year was the historic South Indian Liberal Federation (popularly known as the Justice Party) established in Madras?',
        questionTa:
            'மதராசில் சமூக நீதிக்கான "தென்னிந்திய நல உரிமைச் சங்கம்" (நீதிக்கட்சி) தொடங்கப்பட்ட வரலாற்றுச் சிறப்புமிக்க ஆண்டு எது?',
        optionsEn: [
          '1916 (20 November 1916 at Victoria Hall, Madras)',
          '1920 (First elections under Montagu-Chelmsford)',
          '1925 (Kanchipuram Congress Conference)',
          '1937 (Rajaji Ministry formation)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          '1916 (நவம்பர் 20, விக்டோரியா பொது அரங்கம், சென்னை)',
          '1920',
          '1925',
          '1937',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'On 20 November 1916, non-Brahmin leaders Dr. C. Natesan, Sir P. Theagaraya Chetty, and Dr. T. M. Nair gathered at Victoria Public Hall in Madras to form the South Indian Liberal Federation (SILF), which published the "Justice" newspaper.',
        explanationTa:
            '1916 நவம்பர் 20 அன்று டாக்டர் நடேசனார், சர் பி. தியாகராயர், டாக்டர் டி.எம். நாயர் ஆகியோரால் தென்னிந்திய நல உரிமைச் சங்கம் தொடங்கப்பட்டு நீதிக்கட்சி என அழைக்கப்பட்டது.',
        hasOptionE: true,
      ),

      // 7. Unit 8: Socio-Political Movements - Periyar Self Respect Movement
      Question(
        id: 'tnpsc_exp_07',
        subject: 'History & Culture of Tamil Nadu',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'The Self-Respect Movement (சுயமரியாதை இயக்கம்) was founded in Tamil Nadu in 1925 by which revolutionary social reformer?',
        questionTa:
            '1925-ல் தமிழ்நாட்டில் தீண்டாமை ஒழிப்பு மற்றும் பெண் விடுதலைக்காக "சுயமரியாதை இயக்கத்தை"த் தோற்றுவித்தவர் யார்?',
        optionsEn: [
          'தந்தை பெரியார் (Thanthai Periyar E. V. Ramasamy)',
          'பேரறிஞர் அண்ணா (Arignar Anna)',
          'இரட்டைமலை சீனிவாசன் (Rettamalai Srinivasan)',
          'பண்டிதர் அயோத்திதாசர் (Pandithar Iyothee Thass)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'தந்தை பெரியார் (ஈ. வெ. இராமசாமி)',
          'பேரறிஞர் அண்ணா',
          'இரட்டைமலை சீனிவாசன்',
          'பண்டிதர் அயோத்திதாசர்',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Periyar E. V. Ramasamy launched the Self-Respect Movement in 1925 after parting ways with the Indian National Congress to fight for social equality, anti-caste dignity, and rationalism.',
        explanationTa:
            'காங்கிரசிலிருந்து வெளியேறிய தந்தை பெரியார் 1925-ல் சுயமரியாதை இயக்கத்தைத் தொடங்கி சுயமரியாதைத் திருமணங்கள் மற்றும் பெண் விடுதலைக்கு வழிகாட்டினார்.',
        hasOptionE: true,
      ),

      // 8. Unit 8: Freedom Struggle - Rani Velu Nachiyar
      Question(
        id: 'tnpsc_exp_08',
        subject: 'History & Culture of Tamil Nadu',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'Which valiant queen fought the British East India Company and successfully recaptured her kingdom of Sivagangai in 1780 with the aid of Hyder Ali and the Maruthu Pandiyars?',
        questionTa:
            'ஹைதர் அலி மற்றும் மருது சகோதரர்களின் படை உதவியுடன் ஆங்கிலேயக் கிழக்கிந்திய கம்பெனியை வீழ்த்தி 1780-ல் சிவகங்கையை மீட்டெடுத்த வீரமங்கை யார்?',
        optionsEn: [
          'வீரமங்கை வேலு நாச்சியார் (Rani Velu Nachiyar)',
          'ராணி மங்கம்மாள் (Rani Mangammal)',
          'குயிலி (Commander Kuyili)',
          'ஜான்சி ராணி லக்ஷ்மி பாய்',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'வீரமங்கை வேலு நாச்சியார்',
          'ராணி மங்கம்மாள்',
          'குயிலி',
          'ஜான்சி ராணி லக்ஷ்மி பாய்',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Rani Velu Nachiyar of Sivagangai was the first Indian queen to wage armed resistance against the British East India Company, recapturing her kingdom in 1780.',
        explanationTa:
            'ஆங்கிலேயரை எதிர்த்து ஆயுதம் ஏந்திப் போராடி தன் நாட்டை மீட்டெடுத்த முதல் இந்தியப் பெண் விடுதலைப் போராட்ட வீராங்கனை வீரமங்கை வேலு நாச்சியார் ஆவார்.',
        hasOptionE: true,
      ),

      // 9. Indian Polity - Governor Ordinance Power (Article 213)
      Question(
        id: 'tnpsc_exp_09',
        subject: 'Indian Polity',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'Under which Article of the Constitution of India does the Governor of a State possess the power to promulgate Ordinances during the recess of the State Legislature?',
        questionTa:
            'இந்திய அரசியலமைப்பின் எந்த விதியின்படி, மாநில சட்டமன்றம் கூடாத காலங்களில் மாநில ஆளுநர் அவசரச் சட்டம் (Ordinance) பிறப்பிக்க அதிகாரம் கொண்டுள்ளார்?',
        optionsEn: [
          'Article 213 (Governor Ordinance Making Power)',
          'Article 123 (President Ordinance Making Power)',
          'Article 161 (Pardoning Power of Governor)',
          'Article 153 (Office of the Governor)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'சரத்து 213 (ஆளுநரின் அவசரச் சட்ட அதிகாரம்)',
          'சரத்து 123 (குடியரசுத் தலைவர் அவசரச் சட்டம்)',
          'சரத்து 161 (மன்னிப்பளிக்கும் அதிகாரம்)',
          'சரத்து 153',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Article 213 empowers the Governor to promulgate ordinances when the state legislature is not in session, analogous to Article 123 for the President of India.',
        explanationTa:
            'இந்திய அரசியலமைப்பு சரத்து 213 மாநில ஆளுநருக்கும், சரத்து 123 குடியரசுத் தலைவருக்கும் அவசரச் சட்டம் பிறப்பிக்கும் அதிகாரத்தை வழங்குகிறது.',
        hasOptionE: true,
      ),

      // 10. Indian Polity - 73rd Amendment Panchayati Raj
      Question(
        id: 'tnpsc_exp_10',
        subject: 'Indian Polity',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'The 73rd Constitutional Amendment Act of 1992 added which Schedule to the Constitution of India concerning the 29 functional items of Panchayati Raj?',
        questionTa:
            '1992-ஆம் ஆண்டின் 73-வது அரசியலமைப்பு திருத்தச் சட்டம், பஞ்சாயத்து ராஜ் அமைப்புகளின் 29 அதிகாரப் பணிகளுக்காக அரசியலமைப்பில் சேர்த்த அட்டவணை எது?',
        optionsEn: [
          '11th Schedule (பதினோராவது அட்டவணை - 29 Subjects)',
          '12th Schedule (பன்னிரண்டாவது அட்டவணை - Municipalities)',
          '9th Schedule (ஒன்பதாவது அட்டவணை)',
          '7th Schedule (ஏழாவது அட்டவணை)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          '11-வது அட்டவணை (29 பணிகள்)',
          '12-வது அட்டவணை (நகராட்சிகள்)',
          '9-வது அட்டவணை',
          '7-வது அட்டவணை',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'The 73rd Amendment added Part IX and the 11th Schedule containing 29 functional responsibilities for rural Panchayati Raj institutions.',
        explanationTa:
            '73-வது அரசியலமைப்பு திருத்தம் பகுதி IX மற்றும் 29 பணிகளைக் கொண்ட 11-வது அட்டவணையைப் பஞ்சாயத்துகளுக்காகச் சேர்த்தது.',
        hasOptionE: true,
      ),

      // 11. Indian Economy - GST Implementation Date
      Question(
        id: 'tnpsc_exp_11',
        subject: 'Indian Economy',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'Goods and Services Tax (GST) was officially implemented across India on which date via the 101st Constitutional Amendment?',
        questionTa:
            '101-வது அரசியலமைப்பு திருத்தச் சட்டத்தின் மூலம் இந்தியாவில் சரக்கு மற்றும் சேவை வரி (GST) அதிகாரப்பூர்வமாக நடைமுறைக்கு வந்த நாள் எது?',
        optionsEn: [
          '1 July 2017 (Midnight Joint Session of Parliament)',
          '1 April 2017',
          '8 November 2016',
          '1 January 2018',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          '1 ஜூலை 2017',
          '1 ஏப்ரல் 2017',
          '8 நவம்பர் 2016',
          '1 ஜனவரி 2018',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'GST came into effect on 1 July 2017 subsuming multiple central and state indirect taxes under the "One Nation, One Tax" framework.',
        explanationTa:
            '101-வது திருத்தச் சட்டத்தின் வாயிலாக "ஒரே நாடு, ஒரே வரி" என்ற அடிப்படையில் 2017 ஜூலை 1 முதல் GST நாடு முழுவதும் அமலுக்கு வந்தது.',
        hasOptionE: true,
      ),

      // 12. Aptitude & Mental Ability - HCF and LCM Product
      Question(
        id: 'tnpsc_exp_12',
        subject: 'Aptitude & Mental Ability',
        category: 'Quantitative Aptitude',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'The HCF of two numbers is 12 and their LCM is 144. If one of the numbers is 36, what is the other number?',
        questionTa:
            'இரு எண்களின் மீ.பொ.வ (HCF) 12 மற்றும் அவற்றின் மீ.சி.ம (LCM) 144. அவ்விரு எண்களுள் ஒரு எண் 36 எனில், மற்றொரு எண் எது?',
        optionsEn: [
          '48',
          '42',
          '54',
          '60',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          '48',
          '42',
          '54',
          '60',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Formula: Product of two numbers = HCF × LCM => 36 × y = 12 × 144 => y = (12 × 144) / 36 = 144 / 3 = 48.',
        explanationTa:
            'இரு எண்களின் பெருக்கற்பலன் = மீ.பொ.வ × மீ.சி.ம => 36 × y = 12 × 144 => y = (12 × 144) / 36 = 48.',
        hasOptionE: true,
      ),

      // 13. Aptitude & Mental Ability - Simple Interest
      Question(
        id: 'tnpsc_exp_13',
        subject: 'Aptitude & Mental Ability',
        category: 'Quantitative Aptitude',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'What is the Simple Interest earned on a principal of ₹5,000 for 2 years at an annual interest rate of 10%?',
        questionTa:
            'அசல் ரூ. 5,000-க்கு 10% ஆண்டு வட்டி வீதத்தில் 2 ஆண்டுகளுக்கு கிடைக்கும் தனிவட்டி (Simple Interest) எவ்வளவு?',
        optionsEn: [
          '₹1,000',
          '₹500',
          '₹1,050',
          '₹1,200',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'ரூ. 1,000',
          'ரூ. 500',
          'ரூ. 1,050',
          'ரூ. 1,200',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Simple Interest SI = (P × N × R) / 100 = (5000 × 2 × 10) / 100 = ₹1,000.',
        explanationTa:
            'தனிவட்டி = (P × N × R) / 100 = (5000 × 2 × 10) / 100 = ரூ. 1,000.',
        hasOptionE: true,
      ),

      // 14. Aptitude & Mental Ability - Doubling Principal
      Question(
        id: 'tnpsc_exp_14',
        subject: 'Aptitude & Mental Ability',
        category: 'Quantitative Aptitude',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'A sum of money doubles itself in 5 years at simple interest. What is the rate of interest per annum?',
        questionTa:
            'ஒரு குறிப்பிட்ட தொகையானது தனிவட்டி முறையில் 5 ஆண்டுகளில் இரட்டிப்பாகிறது எனில், அதன் ஆண்டு வட்டி வீதம் என்ன?',
        optionsEn: [
          '20%',
          '15%',
          '25%',
          '10%',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          '20%',
          '15%',
          '25%',
          '10%',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'For principal to double, SI = P. Formula: R = (100 × (n - 1)) / T = (100 × (2 - 1)) / 5 = 100 / 5 = 20%.',
        explanationTa:
            'தொகை இரட்டிப்பாக: R = (100 × (n - 1)) / T = (100 × 1) / 5 = 20%.',
        hasOptionE: true,
      ),

      // 15. Freedom Fighters - V. O. Chidambaram Pillai
      Question(
        id: 'tnpsc_exp_15',
        subject: 'History & Culture of Tamil Nadu',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'Which valiant freedom fighter pioneered Indian indigenous maritime enterprise by establishing the Swadeshi Steam Navigation Company between Tuticorin and Colombo in 1906?',
        questionTa:
            'ஆங்கிலேயரின் ஏகபோக கப்பல் வணிகத்திற்கு எதிராக 1906-ல் தூத்துக்குடி - கொழும்பு இடையே "சுதேசி நீராவி கப்பல் நிறுவனத்தை"த் தொடங்கிய "செக்கிழுத்த செம்மல்" யார்?',
        optionsEn: [
          'வ. உ. சிதம்பரனார் (V. O. Chidambaram Pillai)',
          'சுப்பிரமணிய சிவா (Subramania Siva)',
          'திருப்பூர் குமரன் (Tiruppur Kumaran)',
          'வீரபாண்டிய கட்டபொம்மன்',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'வ. உ. சிதம்பரனார்',
          'சுப்பிரமணிய சிவா',
          'திருப்பூர் குமரன்',
          'வீரபாண்டிய கட்டபொம்மன்',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'V. O. Chidambaram Pillai founded the Swadeshi Steam Navigation Company in 1906 with the steamships S.S. Galia and S.S. Lawoe to challenge the British India Steam Navigation monopoly.',
        explanationTa:
            '1906-ல் காலியா, லாவோ என்ற இரு கப்பல்களை வாங்கி ஆங்கிலேயருக்கு எதிராக சுதேசி கப்பல் நிறுவனத்தை நடத்தி சிறைத்தண்டனை அனுபவித்தவர் வ.உ.சி ஆவார்.',
        hasOptionE: true,
      ),

      // 16. Unit 9: Development Administration - HDI Rank
      Question(
        id: 'tnpsc_exp_16',
        subject: 'Development Administration in Tamil Nadu',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'According to Tamil Nadu State Human Development Reports, which district consistently records the highest Human Development Index (HDI) and literacy rate in the State?',
        questionTa:
            'தமிழ்நாடு மாநில மனிதவள மேம்பாட்டு அறிக்கையின்படி, தொடர்ந்து அதிக மனித மேம்பாட்டுக் குறியீடும் (HDI) எழுத்தறிவு விகிதமும் கொண்ட மாவட்டம் எது?',
        optionsEn: [
          'கன்னியாகுமரி (Kanyakumari)',
          'சென்னை (Chennai)',
          'கோயம்புத்தூர் (Coimbatore)',
          'மதுரை (Madurai)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'கன்னியாகுமரி',
          'சென்னை',
          'கோயம்புத்தூர்',
          'மதுரை',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Kanyakumari district leads Tamil Nadu in literacy rate (>91%) and overall Human Development Index (HDI) due to robust health and educational access.',
        explanationTa:
            'சிறந்த கல்வி மற்றும் சுகாதாரக் குறியீடுகளின் அடிப்படையில் கன்னியாகுமரி மாவட்டம் மனித மேம்பாட்டுக் குறியீட்டில் தமிழகத்தில் முதலிடம் வகிக்கிறது.',
        hasOptionE: true,
      ),

      // 17. Unit 9: Welfare Schemes - Pudhumai Penn
      Question(
        id: 'tnpsc_exp_17',
        subject: 'Development Administration in Tamil Nadu',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'Under which flagship scheme does the Government of Tamil Nadu provide ₹1,000 per month to girl students who completed classes 6 to 12 in government schools to pursue higher education?',
        questionTa:
            'அரசுப் பள்ளிகளில் 6 முதல் 12-ஆம் வகுப்பு வரை படித்து உயர்கல்வி சேரும் மாணவிகளுக்கு மாதம் ரூ. 1,000 உதவித்தொகை வழங்கும் தமிழக அரசின் திட்டம் எது?',
        optionsEn: [
          'மூவலூர் இராமாமிர்தம் அம்மையார் புதுமைப் பெண் திட்டம்',
          'முதலமைச்சரின் பெண் குழந்தைகள் பாதுகாப்பு திட்டம்',
          'டாக்டர் முத்துலட்சுமி ரெட்டி மகப்பேறு உதவி திட்டம்',
          'இன்னுயிர் காப்போம் - நம்மை காக்கும் 48',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'மூவலூர் இராமாமிர்தம் அம்மையார் புதுமைப் பெண் திட்டம்',
          'முதலமைச்சரின் பெண் குழந்தைகள் பாதுகாப்பு திட்டம்',
          'டாக்டர் முத்துலட்சுமி ரெட்டி மகப்பேறு உதவி திட்டம்',
          'இன்னுயிர் காப்போம் - நம்மை காக்கும் 48',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'The Moovalur Ramamirtham Ammaiyar Pudhumai Penn Scheme deposits ₹1,000 monthly directly into the bank accounts of female undergraduate/diploma students to prevent dropout and promote female enrollment.',
        explanationTa:
            'அரசுப் பள்ளி மாணவிகளின் உயர்கல்வி சேர்க்கையை அதிகரிக்க மூவலூர் இராமாமிர்தம் அம்மையார் புதுமைப் பெண் திட்டம் செயல்படுத்தப்பட்டு வருகிறது.',
        hasOptionE: true,
      ),

      // 18. Tamil Grammar - Case Markers (Vettruumai)
      Question(
        id: 'tnpsc_exp_18',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'In classical Tamil grammar, which set of suffixes constitutes the case markers for the Third Case (மூன்றாம் வேற்றுமை உருபுகள்)?',
        questionTa:
            'தமிழ் இலக்கணத்தில் மூன்றாம் வேற்றுமைக்குரிய சொல்லுருபுகளும் வேற்றுமை உருபுகளும் எவை?',
        optionsEn: [
          'ஆல், ஆன், ஒடு, ஓடு (3rd Case)',
          'ஐ (2nd Case)',
          'கு (4th Case)',
          'இல், இன் (5th Case)',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          'ஆல், ஆன், ஒடு, ஓடு',
          'ஐ',
          'கு',
          'இல், இன்',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Tamil Cases: 1st (எழுவாய் - No marker), 2nd (ஐ), 3rd (ஆல், ஆன், ஒடு, ஓடு), 4th (கு), 5th (இல், இன்), 6th (அது, ஆது, அ), 7th (கண்), 8th (விளி).',
        explanationTa:
            'மூன்றாம் வேற்றுமையின் உருபுகள்: ஆல், ஆன், ஒடு, ஓடு (எ.கா: கண்ணனால் செய்யப்பட்டது, தந்தையோடு சென்றான்).',
        hasOptionE: true,
      ),

      // 19. Tamil Literature - Kamba Ramayanam Cantos
      Question(
        id: 'tnpsc_exp_19',
        subject: 'General Tamil',
        category: 'General Tamil & English',
        examType: 'tnpsc_group_2_4',
        questionEn: 'How many Kandams (காண்டங்கள் - Cantos) are contained in Kambar\'s epic masterpiece Kamba Ramayanam?',
        questionTa: 'கவிச்சக்கரவர்த்தி கம்பர் இயற்றிய கம்பராமாயணத்தில் உள்ள காண்டங்கள் எத்தனை?',
        optionsEn: [
          '6 காண்டங்கள் (Bala, Ayodhya, Aranya, Kishkindha, Sundara, Yuddha)',
          '7 காண்டங்கள் (Including Uttara Kandam written by Ottakoothar)',
          '5 காண்டங்கள்',
          '4 காண்டங்கள்',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          '6 காண்டங்கள் (பால, அயோத்திய, ஆரணிய, கிட்கிந்தா, சுந்தர, யுத்த காண்டங்கள்)',
          '7 காண்டங்கள்',
          '5 காண்டங்கள்',
          '4 காண்டங்கள்',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'Kambar authored 6 Kandams. The 7th Kandam (Uttara Kandam) was composed by his contemporary Ottakoothar.',
        explanationTa:
            'கம்பர் பாடியது 6 காண்டங்கள் மட்டுமே. ஏழாவது காண்டமான உத்தர காண்டத்தை இயற்றியவர் ஒட்டக்கூத்தர் ஆவார்.',
        hasOptionE: true,
      ),

      // 20. History - First Anti-Hindi Agitation
      Question(
        id: 'tnpsc_exp_20',
        subject: 'History & Culture of Tamil Nadu',
        category: 'General Awareness',
        examType: 'tnpsc_group_2_4',
        questionEn:
            'The first historic Anti-Hindi Imposition agitation in Madras Presidency occurred during which years when Rajaji\'s Congress ministry made Hindi compulsory in secondary schools?',
        questionTa:
            'ராஜாஜி தலைமையிலான காங்கிரஸ் அமைச்சரவை பள்ளிகளில் இந்தியை கட்டாயமாக்கியதை எதிர்த்து தமிழகத்தில் முதல் இந்தி எதிர்ப்புப் போராட்டம் வெடித்த ஆண்டு எது?',
        optionsEn: [
          '1937 - 1939 (Thalamuthu & Natarajan martyrdom)',
          '1965 (Official Languages Act agitation)',
          '1950',
          '1947',
          'Option E: Answer Not Known (விடை தெரியவில்லை)',
        ],
        optionsTa: [
          '1937 - 1939 (தாளமுத்து, நடராசன் தியாகம்)',
          '1965',
          '1950',
          '1947',
          'Option E: விடை தெரியவில்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'The first Anti-Hindi agitation occurred between 1937 and 1939 led by Periyar and Justice Party leaders. Thalamuthu and Natarajan sacrificed their lives in prison during this protest.',
        explanationTa:
            '1937 முதல் 1939 வரை நடைபெற்ற முதல் இந்தி எதிர்ப்புப் போராட்டத்தில் தாளமுத்து மற்றும் நடராசன் ஆகியோர் சிறையில் உயிர்நீத்து மொழிப்போர் தியாகிகளாயினர்.',
        hasOptionE: true,
      ),
    ];
  }

  // =========================================================================
  // 2. RAILWAYS RRB NTPC & GROUP D (Science, Quant, Reasoning, Railway GK)
  // =========================================================================
  static List<Question> getRrbQuestions() {
    return const [
      // 1. Indian Railways History - 1853
      Question(
        id: 'rrb_exp_01',
        subject: 'General Awareness',
        category: 'General Awareness',
        examType: 'rrb_ntpc',
        questionEn:
            'On 16 April 1853, India\'s first passenger train operated over a distance of 34 kilometers between which two stations?',
        questionTa:
            '1853 ஏப்ரல் 16 அன்று இந்தியாவின் முதல் பயணிகள் ரயில் 34 கி.மீ தூரம் எந்த இரு நிலையங்களுக்கு இடையே இயக்கப்பட்டது?',
        optionsEn: [
          'Bori Bunder (Bombay) and Thane',
          'Howrah and Hooghly',
          'Royapuram (Madras) and Walajah Road',
          'Delhi and Agra',
        ],
        optionsTa: [
          'போரி பந்தர் (மும்பை) மற்றும் தானே',
          'ஹவுரா மற்றும் ஹூக்ளி',
          'ராயபுரம் மற்றும் வாலாஜா ரோடு',
          'டெல்லி மற்றும் ஆக்ரா',
        ],
        correctIndex: 0,
        explanationEn:
            'India\'s first passenger train ran on 16 April 1853 hauled by three locomotives (Sahib, Sindh, Sultan) carrying 400 passengers over 34 km from Bori Bunder to Thane.',
        explanationTa:
            '1853 ஏப்ரல் 16-ல் போரி பந்தர் - தானே இடையே 34 கி.மீ தூரத்திற்கு சாஹிப், சிந்து, சுல்தான் என்ற 3 என்ஜின்களுடன் முதல் பயணிகள் ரயில் இயக்கப்பட்டது.',
        hasOptionE: false,
      ),

      // 2. General Science - Chemistry Washing Soda
      Question(
        id: 'rrb_exp_02',
        subject: 'General Science',
        category: 'General Awareness',
        examType: 'rrb_group_d',
        questionEn: 'What is the chemical name and molecular formula of Washing Soda?',
        questionTa: 'சலவைச் சோடாவின் வேதியியல் பெயர் மற்றும் மூலக்கூறு வாய்பாடு என்ன?',
        optionsEn: [
          'Sodium carbonate decahydrate (Na₂CO₃·10H₂O)',
          'Sodium hydrogen carbonate (NaHCO₃)',
          'Calcium oxychloride (CaOCl₂)',
          'Sodium hydroxide (NaOH)',
        ],
        optionsTa: [
          'சோடியம் கார்பனேட் டெகாஹைட்ரேட் (Na₂CO₃·10H₂O)',
          'சோடியம் பைகார்பனேட் (NaHCO₃)',
          'கால்சியம் ஆக்ஸிகுளோரைடு (CaOCl₂)',
          'சோடியம் ஹைட்ராக்சைடு (NaOH)',
        ],
        correctIndex: 0,
        explanationEn:
            'Washing soda is Sodium carbonate decahydrate (Na₂CO₃·10H₂O). Baking soda is Sodium hydrogen carbonate (NaHCO₃).',
        explanationTa:
            'சலவைச் சோடா என்பது சோடியம் கார்பனேட் டெகாஹைட்ரேட் (Na₂CO₃·10H₂O) ஆகும். சமையல் சோடா NaHCO₃ எனப்படும்.',
        hasOptionE: false,
      ),

      // 3. General Science - Physics Instruments
      Question(
        id: 'rrb_exp_03',
        subject: 'General Science',
        category: 'General Awareness',
        examType: 'rrb_ntpc',
        questionEn: 'Which device is used to measure electric current in an electrical circuit and how is it connected?',
        questionTa: 'ஒரு மின்சுற்றில் பாயும் மின்னோட்டத்தை (Current) அளவிட பயன்படும் கருவி எது? அது எவ்வாறு இணைக்கப்படுகிறது?',
        optionsEn: [
          'Ammeter, connected in Series',
          'Voltmeter, connected in Parallel',
          'Galvanometer, connected in Parallel',
          'Rheostat, connected in Series',
        ],
        optionsTa: [
          'அம்மீட்டர் (Ammeter), தொடரிணைப்பில் இணைக்கப்படும்',
          'வோல்ட்மீட்டர், பக்க இணைப்பில் இணைக்கப்படும்',
          'கால்வனாமீட்டர்',
          'மின்தடை மாற்றி',
        ],
        correctIndex: 0,
        explanationEn:
            'An Ammeter has very low resistance and must always be connected in series with the circuit to measure the total current flowing through it.',
        explanationTa:
            'மின்னோட்டத்தை அளவிட அம்மீட்டர் எப்போதும் மின்சுற்றில் தொடரிணைப்பில் (Series) மட்டுமே இணைக்கப்பட வேண்டும்.',
        hasOptionE: false,
      ),

      // 4. Mathematics - Train Speed Distance
      Question(
        id: 'rrb_exp_04',
        subject: 'Mathematics',
        category: 'Quantitative Aptitude',
        examType: 'rrb_ntpc',
        questionEn:
            'A train 150 meters long crosses an electric telegraph post in 15 seconds. What is the speed of the train in km/h?',
        questionTa:
            '150 மீட்டர் நீளமுள்ள ஒரு ரயில் ஒரு மின் கம்பத்தை 15 வினாடிகளில் கடக்கிறது எனில், ரயிலின் வேகம் மணிக்கு எத்தனை கி.மீ (km/h)?',
        optionsEn: [
          '36 km/h',
          '45 km/h',
          '30 km/h',
          '54 km/h',
        ],
        optionsTa: [
          '36 கி.மீ/மணி',
          '45 கி.மீ/மணி',
          '30 கி.மீ/மணி',
          '54 கி.மீ/மணி',
        ],
        correctIndex: 0,
        explanationEn:
            'Speed = Distance / Time = 150 m / 15 s = 10 m/s. Convert to km/h: 10 × (18 / 5) = 2 × 18 = 36 km/h.',
        explanationTa:
            'வேகம் = தூரம் / நேரம் = 150 / 15 = 10 மீ/விநாடி. km/h ஆக மாற்ற: 10 × (18 / 5) = 36 கி.மீ/மணி.',
        hasOptionE: false,
      ),

      // 5. Mathematics - Pipes and Cisterns
      Question(
        id: 'rrb_exp_05',
        subject: 'Mathematics',
        category: 'Quantitative Aptitude',
        examType: 'rrb_group_d',
        questionEn:
            'Pipe A can fill a tank in 20 minutes and Pipe B can fill it in 30 minutes. If both pipes are opened simultaneously, in how many minutes will the tank be full?',
        questionTa:
            'குழாய் A ஒரு தொட்டியை 20 நிமிடங்களிலும், குழாய் B அதே தொட்டியை 30 நிமிடங்களிலும் நிரப்புகின்றன. இரு குழாய்களும் ஒரே நேரத்தில் திறக்கப்பட்டால், தொட்டி எத்தனை நிமிடங்களில் நிரம்பும்?',
        optionsEn: [
          '12 minutes',
          '15 minutes',
          '10 minutes',
          '25 minutes',
        ],
        optionsTa: [
          '12 நிமிடங்கள்',
          '15 நிமிடங்கள்',
          '10 நிமிடங்கள்',
          '25 நிமிடங்கள்',
        ],
        correctIndex: 0,
        explanationEn:
            'Combined 1 minute work = 1/20 + 1/30 = (3 + 2)/60 = 5/60 = 1/12. Therefore, both pipes take 12 minutes to fill the tank.',
        explanationTa:
            '1 நிமிடத்தில் நிரம்பும் அளவு = 1/20 + 1/30 = 5/60 = 1/12. ஆகவே தொட்டி 12 நிமிடங்களில் முழுமையாக நிரம்பும்.',
        hasOptionE: false,
      ),

      // 6. Reasoning - Number Series
      Question(
        id: 'rrb_exp_06',
        subject: 'General Intelligence & Reasoning',
        category: 'Logical Reasoning',
        examType: 'rrb_ntpc',
        questionEn: 'Identify the next number in the given series: 3, 7, 15, 31, 63, ?',
        questionTa: 'கொடுக்கப்பட்டுள்ள எண் தொடரில் அடுத்த எண்ணைக் கண்டறிக: 3, 7, 15, 31, 63, ?',
        optionsEn: [
          '127',
          '125',
          '120',
          '129',
        ],
        optionsTa: [
          '127',
          '125',
          '120',
          '129',
        ],
        correctIndex: 0,
        explanationEn:
            'Pattern: (3 × 2) + 1 = 7; (7 × 2) + 1 = 15; (15 × 2) + 1 = 31; (31 × 2) + 1 = 63; (63 × 2) + 1 = 127.',
        explanationTa:
            'அமைப்பு: முந்தைய எண் × 2 + 1 => (63 × 2) + 1 = 126 + 1 = 127.',
        hasOptionE: false,
      ),

      // 7. General Science - Biology Excretory Unit
      Question(
        id: 'rrb_exp_07',
        subject: 'General Science',
        category: 'General Awareness',
        examType: 'rrb_group_d',
        questionEn: 'What is the microscopic structural and functional filtration unit of the human kidney?',
        questionTa: 'மனித சிறுநீரகத்தின் நுண்ணிய அமைப்பு மற்றும் செயல் அலகு (Filtration Unit) எது?',
        optionsEn: [
          'Nephron (நெப்ரான்)',
          'Neuron (நியூரான் - Nervous System)',
          'Alveoli (நுரையீரல் காற்று நுண்ணறை)',
          'Villi (குடலுறிஞ்சி)',
        ],
        optionsTa: [
          'நெப்ரான்',
          'நியூரான்',
          'ஆல்வியோலி',
          'வில்லி',
        ],
        correctIndex: 0,
        explanationEn:
            'The nephron is the basic microscopic functional unit of the kidney responsible for filtering blood and forming urine. Millions of nephrons exist in each kidney.',
        explanationTa:
            'சிறுநீரகத்தின் செயல் அலகு நெப்ரான் ஆகும். நியூரான்கள் நரம்பு மண்டலத்தின் அலகுகள்.',
        hasOptionE: false,
      ),

      // 8. Railway GK - Southern Railway Headquarters
      Question(
        id: 'rrb_exp_08',
        subject: 'General Awareness',
        category: 'General Awareness',
        examType: 'rrb_ntpc',
        questionEn: 'Where is the headquarters of the Southern Railway Zone of Indian Railways located?',
        questionTa: 'இந்திய ரயில்வேயின் தெற்கு ரயில்வே (Southern Railway) மண்டலத்தின் தலைமையகம் எங்கு அமைந்துள்ளது?',
        optionsEn: [
          'Chennai (சென்னை)',
          'Hubli (ஹூப்ளி)',
          'Secunderabad (செகந்திராபாத்)',
          'Bengaluru (பெங்களூரு)',
        ],
        optionsTa: [
          'சென்னை',
          'ஹூப்ளி',
          'செகந்திராபாத்',
          'பெங்களூரு',
        ],
        correctIndex: 0,
        explanationEn:
            'Southern Railway was created on 14 April 1951 with its headquarters located at Chennai Central, Tamil Nadu.',
        explanationTa:
            'தெற்கு ரயில்வே 1951 ஏப்ரல் 14 அன்று உருவாக்கப்பட்டது. இதன் தலைமையகம் சென்னையில் அமைந்துள்ளது.',
        hasOptionE: false,
      ),
    ];
  }

  // =========================================================================
  // 3. STAFF SELECTION COMMISSION SSC CGL & CHSL (Quant, English, Reasoning)
  // =========================================================================
  static List<Question> getSscQuestions() {
    return const [
      // 1. English - Idioms & Phrases
      Question(
        id: 'ssc_exp_01',
        subject: 'English Comprehension',
        category: 'General Tamil & English',
        examType: 'ssc_cgl',
        questionEn:
            'Select the most appropriate meaning of the given idiom: "Bite the bullet"',
        questionTa:
            '"Bite the bullet" என்ற ஆங்கில மரபுத்தொடரின் (Idiom) சரியான பொருள் யாது?',
        optionsEn: [
          'To face a difficult or unpleasant situation with courage',
          'To show fear and retreat from danger',
          'To waste time doing unnecessary arguments',
          'To accept a defeat without trying',
        ],
        optionsTa: [
          'கடினமான சூழலை துணிச்சலோடு எதிர்கொள்ளுதல்',
          'பயந்து பின்வாங்குதல்',
          'நேரத்தை வீணடித்தல்',
          'முயற்சியின்றி தோல்வியை ஒப்புக்கொள்ளுதல்',
        ],
        correctIndex: 0,
        explanationEn:
            '"Bite the bullet" means to bravely endure a grim, unavoidable situation without flinching.',
        explanationTa:
            '"Bite the bullet" என்பது தவிர்க்க முடியாத ஒரு கடினமான நிலையைத் தைரியமாக எதிர்கொள்வதைக் குறிக்கும்.',
        hasOptionE: false,
      ),

      // 2. English - One Word Substitution
      Question(
        id: 'ssc_exp_02',
        subject: 'English Comprehension',
        category: 'General Tamil & English',
        examType: 'ssc_cgl',
        questionEn:
            'Select the one-word substitute for: "A person who loves, collects, and reads books voraciously"',
        questionTa:
            '"புத்தகங்களை விரும்பிப் படித்து சேகரிக்கும் நபர்" - என்பதற்கான ஆங்கில ஒரு சொல் (One Word Substitution) எது?',
        optionsEn: [
          'Bibliophile',
          'Philanthropist (Lover of mankind)',
          'Polyglot (Knows many languages)',
          'Misogynist',
        ],
        optionsTa: [
          'Bibliophile (நூல் விரும்பி)',
          'Philanthropist',
          'Polyglot',
          'Misogynist',
        ],
        correctIndex: 0,
        explanationEn:
            'Bibliophile (from Greek biblion "book" + philos "loving") refers to someone who admires, collects, and reads books.',
        explanationTa:
            'Bibliophile என்பது புத்தகங்களை விரும்பிப் படிப்பவரையும் சேகரிப்பவரையும் குறிக்கும் சொல்.',
        hasOptionE: false,
      ),

      // 3. Quantitative Aptitude - Algebra Identity
      Question(
        id: 'ssc_exp_03',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'ssc_cgl',
        questionEn: 'If x + 1/x = 4, find the numerical value of x² + 1/x².',
        questionTa: 'x + 1/x = 4 எனில், x² + 1/x²-ன் மதிப்பு காண்க.',
        optionsEn: [
          '14',
          '16',
          '18',
          '12',
        ],
        optionsTa: [
          '14',
          '16',
          '18',
          '12',
        ],
        correctIndex: 0,
        explanationEn:
            'Formula: (x + 1/x)² = x² + 2 + 1/x² => 4² = x² + 1/x² + 2 => 16 - 2 = 14.',
        explanationTa:
            '(x + 1/x)² = x² + 2 + 1/x² => 4² = x² + 1/x² + 2 => x² + 1/x² = 16 - 2 = 14.',
        hasOptionE: false,
      ),

      // 4. Quantitative Aptitude - Successive Discount
      Question(
        id: 'ssc_exp_04',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'ssc_cgl',
        questionEn:
            'The marked price of an article is ₹800. A shopkeeper offers two successive discounts of 10% and 10%. What is the net selling price?',
        questionTa:
            'ஒரு பொருளின் குறித்த விலை ரூ. 800. ஒரு கடைக்காரர் 10% மற்றும் 10% என இரு தொடர் தள்ளுபடிகளை அளிக்கிறார் எனில், அதன் விற்பனை விலை என்ன?',
        optionsEn: [
          '₹648',
          '₹640',
          '₹650',
          '₹660',
        ],
        optionsTa: [
          'ரூ. 648',
          'ரூ. 640',
          'ரூ. 650',
          'ரூ. 660',
        ],
        correctIndex: 0,
        explanationEn:
            'Single equivalent discount = 10 + 10 - (10 × 10 / 100) = 19%. Selling Price = ₹800 × (100 - 19)% = ₹800 × 0.81 = ₹648.',
        explanationTa:
            'நிகர தள்ளுபடி = 10 + 10 - 1 = 19%. விற்பனை விலை = 800 × 0.81 = ரூ. 648.',
        hasOptionE: false,
      ),

      // 5. General Awareness - Fundamental Rights Emergency
      Question(
        id: 'ssc_exp_05',
        subject: 'General Awareness',
        category: 'General Awareness',
        examType: 'ssc_cgl',
        questionEn:
            'Which Fundamental Rights under the Indian Constitution cannot be suspended even during the proclamation of a National Emergency under Article 352?',
        questionTa:
            'இந்திய அரசியலமைப்பு சரத்து 352-ன் கீழ் தேசிய அவசரநிலை அமலில் இருக்கும் போது கூட எந்த அடிப்படை உரிமைகளை ரத்து செய்ய முடியாது?',
        optionsEn: [
          'Article 20 and Article 21 (Right to life & protection in convictions)',
          'Article 19 (Six freedoms)',
          'Article 14 (Equality before law)',
          'Article 32 (Right to constitutional remedies)',
        ],
        optionsTa: [
          'சரத்து 20 மற்றும் 21 (வாழ்வுரிமை & குற்றங்களிலிருந்து பாதுகாப்பு)',
          'சரத்து 19',
          'சரத்து 14',
          'சரத்து 32',
        ],
        correctIndex: 0,
        explanationEn:
            'By the 44th Constitutional Amendment Act (1978), Articles 20 (protection in respect of conviction for offences) and 21 (protection of life and personal liberty) cannot be suspended during an Emergency.',
        explanationTa:
            '44-வது அரசியலமைப்பு திருத்தத்தின்படி தேசிய அவசரநிலையின் போதும் சரத்து 20 மற்றும் 21-ஐ நிறுத்தி வைக்க முடியாது.',
        hasOptionE: false,
      ),

      // 6. General Intelligence - Ranking & Order
      Question(
        id: 'ssc_exp_06',
        subject: 'General Intelligence & Reasoning',
        category: 'Logical Reasoning',
        examType: 'ssc_cgl',
        questionEn:
            'In a classroom row of 40 students, Priya ranks 15th from the left end. What is her rank from the right end of the row?',
        questionTa:
            '40 மாணவிகள் உள்ள ஒரு வரிசையில், பிரியா இடது முனையிலிருந்து 15-வது இடத்தில் உள்ளார் எனில், வலது முனையிலிருந்து அவரது இடம் என்ன?',
        optionsEn: [
          '26th',
          '25th',
          '27th',
          '24th',
        ],
        optionsTa: [
          '26-வது இடம்',
          '25-வது இடம்',
          '27-வது இடம்',
          '24-வது இடம்',
        ],
        correctIndex: 0,
        explanationEn:
            'Formula: Total = Left + Right - 1 => 40 = 15 + Right - 1 => Right = 40 - 14 = 26th.',
        explanationTa:
            'மொத்தம் = இடது + வலது - 1 => 40 = 15 + வலது - 1 => வலது = 26-வது இடம்.',
        hasOptionE: false,
      ),
    ];
  }

  // =========================================================================
  // 4. BANKING IBPS & SBI CLERK (Aptitude, Banking Awareness, Reasoning)
  // =========================================================================
  static List<Question> getBankingQuestions() {
    return const [
      // 1. Banking Awareness - RTGS System
      Question(
        id: 'bank_exp_01',
        subject: 'Banking Awareness',
        category: 'General Awareness',
        examType: 'ibps_sbi_clerk',
        questionEn:
            'What is the minimum transaction amount required for processing funds through the Real Time Gross Settlement (RTGS) system in India?',
        questionTa:
            'இந்தியாவில் RTGS (Real Time Gross Settlement) பணப் பரிவர்த்தனை முறையின் கீழ் அனுப்பக்கூடிய குறைந்தபட்ச தொகை என்ன?',
        optionsEn: [
          '₹2,00,000 (Two Lakh Rupees)',
          '₹1,00,000',
          '₹50,000',
          'No minimum limit (like NEFT)',
        ],
        optionsTa: [
          'ரூ. 2,00,000 (இரண்டு லட்சம் ரூபாய்)',
          'ரூ. 1,00,000',
          'ரூ. 50,000',
          'குறைந்தபட்ச வரம்பு இல்லை',
        ],
        correctIndex: 0,
        explanationEn:
            'RTGS is meant for high-value immediate fund transfers with a statutory minimum transaction limit of ₹2,00,000. NEFT has no minimum limit.',
        explanationTa:
            'RTGS மூலம் பணம் அனுப்ப குறைந்தபட்ச வரம்பு ரூ. 2 லட்சம் ஆகும். NEFT-க்கு குறைந்தபட்ச வரம்பு இல்லை.',
        hasOptionE: false,
      ),

      // 2. Banking Awareness - Monetary Policy CRR
      Question(
        id: 'bank_exp_02',
        subject: 'Banking Awareness',
        category: 'General Awareness',
        examType: 'ibps_sbi_clerk',
        questionEn:
            'What is the portion of Net Demand and Time Liabilities (NDTL) that commercial banks must maintain as liquid cash balances with the Reserve Bank of India called?',
        questionTa:
            'வணிக வங்கிகள் தங்களின் மொத்த வைப்புத் தொகையில் ஒரு குறிப்பிட்ட பகுதியை ரிசர்வ் வங்கியிடம் பணமாக வைத்திருக்க வேண்டிய விகிதம் எவ்வாறு அழைக்கப்படுகிறது?',
        optionsEn: [
          'Cash Reserve Ratio (CRR)',
          'Statutory Liquidity Ratio (SLR)',
          'Repo Rate',
          'Reverse Repo Rate',
        ],
        optionsTa: [
          'ரொக்க கையிருப்பு விகிதம் (CRR - Cash Reserve Ratio)',
          'சட்டப்பூர்வ நீர்மை விகிதம் (SLR)',
          'ரெப்போ விகிதம்',
          'ரிவர்ஸ் ரெப்போ விகிதம்',
        ],
        correctIndex: 0,
        explanationEn:
            'Cash Reserve Ratio (CRR) is the mandatory percentage of deposits that banks must keep with the RBI in cash without earning interest.',
        explanationTa:
            'வங்கிகள் ரிசர்வ் வங்கியிடம் பணமாக வைத்திருக்க வேண்டிய கட்டாய இருப்பு CRR (Cash Reserve Ratio) எனப்படும்.',
        hasOptionE: false,
      ),

      // 3. Quantitative Aptitude - Quadratic Equation Roots
      Question(
        id: 'bank_exp_03',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'ibps_sbi_clerk',
        questionEn: 'Solve the quadratic equation: x² - 7x + 12 = 0. What are the roots of x?',
        questionTa: 'இருபடிச் சமன்பாட்டைத் தீர்க்க: x² - 7x + 12 = 0. x-ன் மூலங்கள் எவை?',
        optionsEn: [
          'x = 3, 4',
          'x = -3, -4',
          'x = 2, 6',
          'x = 1, 12',
        ],
        optionsTa: [
          'x = 3, 4',
          'x = -3, -4',
          'x = 2, 6',
          'x = 1, 12',
        ],
        correctIndex: 0,
        explanationEn:
            'Factorize: (x - 3)(x - 4) = 0 => x = 3 or x = 4.',
        explanationTa:
            'காரணிப்படுத்துதல்: (x - 3)(x - 4) = 0 => x = 3, 4.',
        hasOptionE: false,
      ),

      // 4. Quantitative Aptitude - Compound Interest
      Question(
        id: 'bank_exp_04',
        subject: 'Quantitative Aptitude',
        category: 'Quantitative Aptitude',
        examType: 'ibps_sbi_clerk',
        questionEn:
            'What is the Compound Interest on a sum of ₹10,000 for 2 years at 10% per annum compounded annually?',
        questionTa:
            'அசல் ரூ. 10,000-க்கு 10% ஆண்டு கூட்டுவட்டி வீதத்தில் 2 ஆண்டுகளுக்கு கிடைக்கும் கூட்டுவட்டி எவ்வளவு?',
        optionsEn: [
          '₹2,100',
          '₹2,000',
          '₹2,200',
          '₹1,900',
        ],
        optionsTa: [
          'ரூ. 2,100',
          'ரூ. 2,000',
          'ரூ. 2,200',
          'ரூ. 1,900',
        ],
        correctIndex: 0,
        explanationEn:
            'Amount = P(1 + R/100)^N = 10000 × (1.1)² = 10000 × 1.21 = ₹12,100. CI = Amount - Principal = 12100 - 10000 = ₹2,100.',
        explanationTa:
            'மொத்தத் தொகை = 10000 × (1.1)² = ரூ. 12,100. கூட்டுவட்டி = 12100 - 10000 = ரூ. 2,100.',
        hasOptionE: false,
      ),
    ];
  }
}
