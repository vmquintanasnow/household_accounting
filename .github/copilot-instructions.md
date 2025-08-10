# Copilot Instructions for home_economy_app

## Project Overview
- This is a Flutter app for managing personal finances, including transactions and savings goals.
- The main logic and UI are in `lib/main.dart`.
- Data is persisted locally using `SharedPreferences` (see `_loadData` and `_saveData` methods).
- The app is structured as a single-stateful widget (`HomeEconomyApp`) with two main tabs: Transactions and Savings Goals.

## Key Components
- **Transactions**: Represented by the `Transaction` class. Each has a title, amount (positive for income, negative for expense), and date.
- **Savings Goals**: Represented by the `SavingGoal` class. Each has a name, target amount, and allocated funds.
- **UI Tabs**: `_buildTransactionsTab()` and `_buildSavingsTab()` build the main views. Tab switching is managed by `_currentIndex` and an `IndexedStack`.
- **Dialogs**: Adding/editing transactions and goals is done via modal dialogs using `showDialog`.

## Data Flow
- All state is managed in `_HomeEconomyAppState`.
- Transactions and goals are loaded from and saved to `SharedPreferences` as JSON.
- UI updates are triggered by `setState` after any data change.

## Localization
- The app uses `MaterialApp` with explicit `locale` set. To avoid errors, always include `localizationsDelegates` and `supportedLocales` in `MaterialApp`.
- Example:
  ```dart
  import 'package:flutter_localizations/flutter_localizations.dart';
  ...
  MaterialApp(
    locale: Locale('en', 'US'),
    supportedLocales: [Locale('en', 'US')],
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    ...
  )
  ```

## Developer Workflows
- **Build/Run**: Use standard Flutter commands: `flutter run`, `flutter build`, etc.
- **Testing**: Place widget tests in `test/`. Run with `flutter test`.
- **Dependencies**: Managed via `pubspec.yaml`. Use `flutter pub get` after changes.

## Conventions & Patterns
- All business logic is in `main.dart` (no separate service/data layers).
- UI and state are tightly coupled for simplicity.
- Use `setState` for all state changes.
- Use `intl` for currency/date formatting.
- Use `showDialog` for all modal interactions.

## Key Files
- `lib/main.dart`: All app logic and UI.
- `pubspec.yaml`: Dependencies and metadata.
- `test/`: Place for widget/unit tests.

## External Integrations
- Uses `shared_preferences` for local storage.
- Uses `intl` for formatting.
- No backend or network communication.

---
If you add new features, follow the single-file, stateful pattern unless refactoring for complexity. Keep UI responsive and persist all user data.
