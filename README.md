# 🎯 ExamArena CBT

> **An offline-first, bilingual (Tamil & English) Gamified Mock Test & Computer-Based Testing (CBT) platform built with Flutter, Riverpod & SQLite.**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Material 3](https://img.shields.io/badge/Material_3-Ready-purple?style=for-the-badge&logo=materialdesign)](https://m3.material.io)

---

## 📌 Overview

**ExamArena CBT** simulates 17 authentic Indian competitive exam blueprints (UPSC CSE/CSAT/CDS/NDA, TNPSC Group 1/2/4 & TNUSRB, RRB NTPC/Group D/ALP, SSC CGL/CHSL/MTS/GD, and IBPS/SBI/RBI Banking) with sectional auto-locking timers, official TCS iON question palette states, bilingual Tamil ⇄ English support, Mistake Vault error revision, and gamified XP/stamina progression.

---

## ✨ Key Features

- ⏱️ **Real Exam Simulations (17 Blueprints + PYQ Papers):**
  - **SSC CGL Tier 1:** 100 Questions, 60 minutes with **15-minute auto-locking sections**, `+2.0 / -0.50` marking scheme.
  - **RRB NTPC:** 100 Questions (90 minutes), `+1.0 / -0.33` negative marking with instant Tamil ⇄ English toggle per question.
  - **TNPSC Group 1 / Group 2 & 4:** 200 Questions (180 minutes), `+1.5 / 0.0` marking, **5-option format (A, B, C, D, E: Answer Not Known)**.
  - **Banking (IBPS/SBI Clerk, PO, RBI Assistant):** 100 Questions (60 minutes), **20-minute auto-locking sections**, `+1.0 / -0.25`.
  - **UPSC CSE GS-1, CSAT GS-2, CDS & NDA:** Authentic negative marking & comprehension/numeracy simulations.
- 🎨 **TCS iON Official Palette States:**
  - ⚪ `Not Visited` (Grey)
  - 🔴 `Not Answered` (Red)
  - 🟢 `Answered` (Green)
  - 🟣 `Marked for Review` (Purple)
  - 🟣🟢 `Answered & Marked for Review` (Purple with Green badge)
- 🎮 **Gamified Progression & Stamina Engine:**
  - Earn XP dynamically based on accuracy bonus: `(correct * 10) + accuracyBonus` (`+50` for ≥90%, `+35` for ≥80%, `+20` for ≥70%, `+10` for ≥50%).
  - Level up every 500 XP: **Topic Speed Sprints** ➔ **Sectional Timed Drills** ➔ **Full CBT Mocks** ➔ **AI Adaptive Boss Gauntlet**.
  - 8 Aspirant Merit Tiers (Bronze I through Conqueror VIII) + 5-Heart Stamina discipline system with 2-hour auto-recovery and Mistake Revision healing drills.
- 🤖 **AI-Assisted MCQ Generation:** Integrated with Google Gemini API (`gemini-2.5-flash`) for generating dynamic bilingual MCQs saved permanently into SQLite.
- 💾 **100% Offline-First:** 80+ pre-seeded bilingual MCQs, bundled `Inter` & `Noto Sans Tamil` fonts, test attempt analytics, streak history, theme preferences, and Mistake Vault persisted locally in `sqflite`.
- 🛡️ **Anti-Accidental Exit:** Strict `PopScope` integration preventing accidental exits during active examinations.

---

## 🛠️ Architecture & Tech Stack

```
exam_arena_cbt/
├── assets/google_fonts/             # Bundled Inter & NotoSansTamil TTFs (100% offline)
├── lib/
│   ├── core/                        # Theme, Constants, SQLite AppDatabase, Utils
│   └── features/
│       ├── ai_generator/            # Gemini 2.5 Flash service, Local SQLite seed bank, AI Gauntlet UI
│       ├── exam_engine/             # CBT session state, Sectional auto-lock, Analytics service, TCS UI
│       └── progression/             # Exams, PYQs, XP/Tiers, Hearts, Mistake Vault, Test History
```

- **Framework:** Flutter (Material 3, Light + OLED Midnight Dark Mode)
- **Language:** Dart 3.x
- **State Management:** `flutter_riverpod` (`Notifier` / `NotifierProvider` / `FutureProvider`)
- **Local Database:** `sqflite` (`exam_arena_cbt.db`, schema v6)
- **AI Integration:** `google_generative_ai` (`gemini-2.5-flash`)

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.13.2)
- Android Studio / VS Code with Flutter extension

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/whiteknight-spec/exam_arena_cbt.git
   cd exam_arena_cbt
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run static analysis & tests:
   ```bash
   flutter analyze && flutter test
   ```

4. Run on your connected device / emulator:
   ```bash
   flutter run
   ```

---

## 📄 License
This project is licensed under the MIT License.
