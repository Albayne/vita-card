# VitaCard

**"The record follows the patient. Always."**

VitaCard is a privacy-first health companion app for Zimbabwean university students, built with Flutter. It gives students a single, anonymous "card" for the health-related things they'd otherwise track across scattered notes, apps, or not at all — sexual health testing, mental health, quitting harmful habits, and health savings — without ever asking for a name, student ID, or email.

## Problem Statement

University students in Zimbabwe face several overlapping barriers to managing their health:

- **Stigma and privacy fears** discourage students from tracking or seeking help for sexual health (STI/HIV testing), mental health, and substance use, because doing so on their phone or through campus services risks their identity being linked to sensitive health information.
- **Fragmented tools** — students currently rely on a mix of paper, generic notes apps, or nothing at all to remember test intervals, mood patterns, or savings goals for health costs, none of which are designed for the sensitivity of this data.
- **Financial barriers** to healthcare mean students need a way to plan and save toward health-related expenses (consultations, medication, testing) but lack a lightweight, purpose-built tool to do so.
- **Limited access to counselling** on campus is worsened by the lack of an anonymous, low-friction way to book a slot or log a mood without a paper trail tied to their identity.

## Solution & Features

VitaCard answers this with **on-device-first, anonymous-by-design** tooling. On first launch, the app generates two random tokens (a Health Wallet ID and a Mental Health Token) that stand in for the student everywhere in the app — no name or student ID is ever collected.

| Feature | Module | What it does |
|---|---|---|
| **Health Wallet** | `features/health_wallet` | Anonymous, encrypted local record of health check history, tied to the Health Wallet ID rather than an identity. |
| **STI/HIV Reminder** | `features/sti_reminder` | Deliberately vague reminders ("Time for your regular health check") to log and track routine testing intervals without notifications ever naming a condition or test. |
| **Mental Health** | `features/mental_health` | Anonymous counsellor slot booking (via a Mental Health Token, disconnected from all other tokens) and private mood logging that never syncs off-device. |
| **Quitrr** | `features/quitrr` | A habit-quitting tracker (smoking/substance use) with streak tracking, check-ins, an anonymous peer support feed, and a direct link to the ZACRO Crisis Line for moments of crisis. |
| **Health Fund** | `features/health_fund` | A savings *planner* — calculates and tracks progress toward health-expense goals across configurable wallets. VitaCard never touches, holds, or moves the student's actual money. |
| **Onboarding** | `features/onboarding` | Optional phone verification (via Firebase Auth OTP) or fully anonymous sign-in, followed by generation and reveal of the student's tokens. |

See [PRIVACY.md](PRIVACY.md) for the full, detailed breakdown of what is and is not collected, how encryption works, and how a student can erase their footprint entirely.

## Expected Outcomes

- Students engage more consistently with routine sexual health testing because reminders and logs carry no stigma risk.
- Students build a private, longitudinal view of their mood and habits without fear of that data being exposed or linked to them.
- Students build savings discipline toward real health costs through goal tracking, without VitaCard acting as a financial intermediary.
- Campus counselling slots see higher utilization because booking requires no identifying information.
- A reusable reference implementation for "anonymous by construction" health tooling — useful in any context where stigma is the primary barrier to engagement.

## Future Work

- iOS build target (currently Android-only in this repo).
- Optional encrypted cloud backup for tokens/records for students who want cross-device continuity, opt-in and end-to-end encrypted.
- Expanded peer support moderation tooling for the Quitrr peer feed.
- Localization (Shona / Ndebele) of all in-app copy and notifications.
- Integration with campus counselling systems for real-time slot availability sync.
- Analytics-free usage insights (on-device only) to help students see their own trends without any data leaving the phone.

## Project Architecture

VitaCard is a Flutter app using **feature-first architecture** with [Riverpod](https://riverpod.dev/) for state management and [go_router](https://pub.dev/packages/go_router) for declarative, shell-based navigation.

```
lib/
├── main.dart                 # App entry point: env, Firebase, Hive, notifications init
├── app.dart                  # GoRouter route table + StatefulShellRoute tab navigation
├── core/                     # Cross-cutting, feature-agnostic infrastructure
│   ├── auth/                 # Firebase phone/anonymous auth service
│   ├── constants/            # App-wide colors, text styles, and copy (AppStrings)
│   ├── crypto/                # Anonymous token (Health Wallet ID / MH Token) generator
│   ├── encryption/           # AES-256-CBC record-level encryption helper
│   ├── notifications/        # Local notification scheduling service
│   ├── storage/              # Hive init + AES-256 secure-key-backed encrypted boxes
│   └── theme/                # Material theme definition
├── features/                 # One folder per feature, each self-contained:
│   │                         #   models/  (Hive-backed data classes + generated adapters)
│   │                         #   providers/ (Riverpod state/business logic)
│   │                         #   screens/ (UI pages)
│   │                         #   widgets/ (feature-local UI components)
│   ├── onboarding/
│   ├── dashboard/
│   ├── health_wallet/
│   ├── sti_reminder/
│   ├── mental_health/
│   ├── quitrr/
│   └── health_fund/
└── shared/                    # Reusable, feature-agnostic UI widgets and utils
    ├── widgets/                # Buttons, cards, badges, shell navigation, etc.
    └── utils/                  # Currency/date formatting helpers
```

**Data flow:** Riverpod providers in each feature own state and talk to two storage layers — an encrypted local **Hive** database (`core/storage/hive_service.dart`) for all personal health data, and **Firestore** for the three narrow, pseudonymous document types described in [PRIVACY.md](PRIVACY.md) (counsellor slots, peer posts, push tokens). No personal health data ever reaches Firestore.

**Navigation:** `app.dart` defines a `GoRouter` with a top-level onboarding flow (`/`, `/welcome`, `/verify-phone`, `/token-reveal`) followed by a `StatefulShellRoute` that drives the five bottom-tab branches (dashboard, fund, STI, mind, quitrr) inside `shared/widgets/main_shell.dart`.

### Tech stack

- **Framework:** Flutter (Dart SDK `^3.4.0`)
- **State management:** flutter_riverpod
- **Local storage:** Hive + hive_flutter (AES-256 encrypted boxes), flutter_secure_storage for keys/tokens
- **Backend:** Firebase (Auth, Cloud Firestore, Cloud Messaging) — used minimally and pseudonymously
- **Routing:** go_router (StatefulShellRoute for tabbed navigation)
- **Other:** flutter_local_notifications, fl_chart, flutter_dotenv, encrypt, crypto, timezone, add_2_calendar

## Getting Started (Cloning & Running Locally)

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (channel `stable`, compatible with Dart `^3.4.0`)
- Android Studio or VS Code with the Flutter/Dart extensions
- An Android device or emulator (this repo currently targets Android; see [Future Work](#future-work) for iOS)
- A [Firebase](https://firebase.google.com/) project with **Authentication** (Phone + Anonymous sign-in enabled), **Cloud Firestore**, and **Cloud Messaging** enabled
- Git

### 1. Clone the repository

```bash
git clone https://github.com/Albayne/vita-card.git
cd vita-card
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure environment variables

The app reads Firebase configuration from a `.env` file at the project root (loaded via `flutter_dotenv`, declared as a Flutter asset in `pubspec.yaml`). Copy the example file and fill in your own Firebase project's values:

```bash
cp .env.example .env
```

Then edit `.env`:

```
FIREBASE_API_KEY=your_key_here
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id
```

You can find these values in your Firebase project settings under **Project settings → General → Your apps**. `.env` is git-ignored — never commit real credentials.

### 4. Generate Hive model adapters

Several models (`fund_goal`, `wallet_config`, `health_record`, `counsellor_slot`, `mood_log`, `streak_record`, `sti_test_log`) use Hive's code generation for their `.g.dart` adapters. If you change any `@HiveType` model, regenerate with:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Run the app

```bash
flutter run
```

Select a connected device/emulator when prompted, or pass `-d <device_id>`.

### 6. Run tests

```bash
flutter test
```

## Contributing

This is a student project. If you're a collaborator:

1. Create a feature branch off `main`.
2. Keep feature code self-contained inside its `features/<name>/` folder (models/providers/screens/widgets).
3. Never commit `.env`, keystores, or anything under `PRIVACY.md`'s "what is stored" boundaries to a server-side store.
4. Run `flutter test` and `flutter analyze` before opening a PR.

## Privacy

Privacy is the core design constraint of this app, not an afterthought. Read [PRIVACY.md](PRIVACY.md) before touching auth, storage, or networking code — it documents exactly what may and may not be collected, stored, or transmitted, and why.
