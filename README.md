# 🎯 ExamArena CBT

> **A high-performance, bilingual (Tamil & English) Gamified Mock Test & Computer-Based Testing (CBT) platform built with Flutter & Dart.**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Material 3](https://img.shields.io/badge/Material_3-Ready-purple?style=for-the-badge&logo=materialdesign)](https://m3.material.io)

---

## 📌 Overview

**ExamArena CBT** simulates authentic government and competitive exam environments (SSC CGL, RRB NTPC/JE, and TNPSC) with millisecond-accurate section countdowns, official TCS iON question palette states, and gamified level progression to supercharge student performance.

---

## ✨ Key Features

- ⏱️ **Real Exam Simulations:**
  - **SSC CGL Tier 1:** 100 Questions, 60 minutes with **15-minute auto-locking sections**, `+2.0 / -0.50` marking scheme.
  - **RRB NTPC / JE:** 100 Questions (90 minutes), `+1.0 / -0.33` negative marking with instant Tamil ⇄ English toggle per question.
  - **TNPSC Group 2 / CTS:** 200 Questions (180 minutes), `+1.5 / 0.0` marking, **5-option format (A, B, C, D, E: Answer Not Known)**.
- 🎨 **TCS iON Official Palette States:**
  - ⚪ `Not Visited` (Grey)
  - 🔴 `Not Answered` (Red)
  - 🟢 `Answered` (Green)
  - 🟣 `Marked for Review` (Purple)
  - 🟣🟢 `Answered & Marked for Review` (Purple with Green badge)
- 🎮 **Gamified Progression Engine:**
  - Earn XP dynamically based on accuracy bonus: `(correct * 10) + accuracyBonus`.
  - Level up every 500 XP: unlocks **Topic Speed Sprints** ➔ **Sectional Timed Drills** ➔ **Full Mock Arena** ➔ **AI Boss Gauntlet**.
- 🤖 **AI-Assisted MCQ Generation:** Integrated with Google Gemini API for generating dynamic bilingual MCQs with step-by-step Tamil & English explanations.
- 💾 **Offline-First Storage:** Local question banks, test progress, and analytics persisted securely via `sqflite`.
- 🛡️ **Anti-Accidental Exit:** Strict `PopScope` integration preventing accidental exits during active examinations.

---

## 🛠️ Architecture & Tech Stack

```
exam_arena_cbt/
├── lib/
│   ├── models/         # Data contracts (Question, ExamSession, PaletteState)
│   ├── data/           # SQLite persistence & question seed banks
│   ├── state/          # State management (ChangeNotifier / Provider)
│   ├── screens/        # CBT Engine, Test Summary, Analytics Dashboard
│   └── widgets/        # Question Palette, Timer Header, Option Selector
```

- **Framework:** Flutter (Material 3)
- **Language:** Dart 3.x
- **Local Database:** `sqflite` + `path_provider`
- **Cloud & Auth (Optional Sync):** Supabase
- **AI Integration:** Google Generative AI (Gemini)

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

3. Run on your connected device / emulator:
   ```bash
   flutter run
   ```

---

## 📄 License
This project is licensed under the MIT License.
