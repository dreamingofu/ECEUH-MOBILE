# ECEUH — Flutter

A Flutter port of [eceuh.com](https://eceuh.com) — the UH Electrical & Computer Engineering knowledge base.

## Quick start

```bash
flutter pub get
flutter run
```

That's it. The app boots into the bottom-nav shell at `/home`.

## Project layout

```
lib/
├── main.dart                       App entry — runApp(EceuhApp())
├── app.dart                        MaterialApp.router + theme provider wiring
├── theme.dart                      ThemeData (light + dark) matching the site palette
├── router.dart                     go_router config — bottom-nav shell + nested routes
│
├── models/
│   ├── course.dart                 Course / CourseHub / CourseSections
│   ├── professor.dart              Professor / ProfessorRating
│   ├── file_entry.dart             FileEntry + FileVersion (multi-version PDFs)
│   └── link_entry.dart             LinkEntry (external resource decks)
│
├── data/
│   ├── courses.dart                ECEUH_COURSE_LIST equivalent
│   ├── course_files.dart           ECEUH_COURSE_FILES equivalent (R2 URLs)
│   ├── course_links.dart           ECEUH_COURSE_LINKS equivalent
│   └── professors.dart             ECEUH_COURSES equivalent
│
├── services/
│   ├── theme_service.dart          Light/dark toggle + persistence
│   ├── progress_service.dart       Per-unit progress tracking (shared_preferences)
│   └── share_service.dart          share_plus + url_launcher wrapper
│
├── widgets/
│   ├── app_shell.dart              Scaffold with bottom NavigationBar
│   ├── more_sheet.dart             Bottom sheet (Privacy / Delete / GitHub / Theme)
│   ├── hero_card.dart              Page hero (kicker + title + desc + code pill)
│   ├── hub_card.dart               Two-column course-hub cards (File Library / External Resources)
│   ├── file_card.dart              File entry with Preview / Share / Save offline
│   ├── faculty_ledger.dart         Rotating animated professor spotlight
│   ├── app_promo_banner.dart       "Get the Android app" (web-only equivalent)
│   └── search_field.dart           Global search input
│
└── screens/
    ├── home_screen.dart            Hero, search, Active Coursework, Faculty Ledger
    ├── archives_screen.dart        Live courses + On Deck list
    ├── faculty_screen.dart         Professor directory grouped by course
    ├── course_hub_screen.dart      Parameterized hub for any course slug
    ├── file_library_screen.dart    Bucket-backed file list with type filter
    ├── external_links_screen.dart  Curated links deck
    ├── privacy_screen.dart         Privacy policy
    ├── delete_account_screen.dart  Account deletion steps
    └── preview_screen.dart         In-app WebView (PDFs via Google Docs Viewer)
```

## Architecture notes

- **One source of truth per data type.** `lib/data/*.dart` is the equivalent of the JS data files. Add a quiz / professor / link there once and every consuming screen picks it up.
- **State** is `ChangeNotifier` + `Provider`. Theme + progress are the only global notifiers; everything else is local screen state.
- **Routing** uses `go_router` with a `StatefulShellRoute` so the bottom-nav preserves per-tab back stacks (native-app behavior).
- **PDF preview** opens an in-app `WebView` pointed at `https://docs.google.com/gview?url=...&embedded=true` so the same trick that fixed mobile PDF preview on the web works here too.
- **Share / Download** route through `share_plus` and `dio` respectively.

## Replacing the auth backend

Supabase is left commented in `pubspec.yaml`. To re-enable:

1. Uncomment the `supabase_flutter` dependency, `flutter pub get`.
2. In `main.dart`, before `runApp`, call:
   ```dart
   await Supabase.initialize(
     url: 'https://YOUR-PROJECT.supabase.co',
     anonKey: 'YOUR-ANON-KEY',
   );
   ```
3. Add an `auth_service.dart` under `services/` and wire it the same way `theme_service.dart` is exposed via `Provider`.

## What still needs polish

- Bundle the three fonts (Lora / Inter / JetBrains Mono) into `assets/fonts/` and uncomment the `fonts:` block in `pubspec.yaml`. Until then the system fonts are used.
- App icons and splash: run `flutter pub run flutter_launcher_icons` and `flutter_native_splash` once you've added launcher assets.
- The Faculty Ledger animation is faithful but feel free to tune `_kCycleDuration` in `widgets/faculty_ledger.dart`.
- Add a real Supabase project to re-enable cross-device progress sync.
