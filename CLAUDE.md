# ECEUH Mobile — CLAUDE.md

Flutter port of [eceuh.com](https://eceuh.com), a knowledge base for UH Electrical & Computer Engineering students. Serves course archives, file libraries, faculty ratings, and curated external resources.

---

## Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.22+ / Dart 3.3+ |
| State management | `provider` (ChangeNotifier) |
| Routing | `go_router` 14 with `StatefulShellRoute` |
| Persistence | `shared_preferences` |
| Networking / downloads | `dio`, `path_provider` |
| PDF preview | `webview_flutter` (Google Docs Viewer proxy) |
| Share sheet | `share_plus` |
| External links | `url_launcher` |
| Backend (opt-in) | Supabase — commented out, ready to enable |
| Linting | `flutter_lints` |

---

## Folder Structure

```
lib/
├── main.dart               # Entry point — inits SharedPreferences, wires MultiProvider
├── app.dart                # MaterialApp.router, reads ThemeService for light/dark
├── theme.dart              # EceuhPalette, EceuhTheme, EceuhExtras (ThemeExtension)
├── router.dart             # GoRouter config, shell + nested routes
│
├── models/
│   ├── course.dart         # Course, CourseHub, CourseSections, SectionRef
│   ├── professor.dart      # ProfessorCourse, Professor (with RMP data)
│   ├── file_entry.dart     # FileEntry, FileVersion, FileType enum + label ext
│   └── link_entry.dart     # LinkEntry
│
├── data/
│   ├── courses.dart        # kCourses (List<Course>), courseBySlug(), live/upcoming getters
│   ├── professors.dart     # kProfessorCourses (List<ProfessorCourse>)
│   ├── course_files.dart   # kCourseFiles (Map<slug, List<FileEntry>>), R2 bucket URLs
│   └── course_links.dart   # kCourseLinks (Map<slug, List<LinkEntry>>)
│
├── services/
│   ├── theme_service.dart  # ChangeNotifier, persists ThemeMode under 'ee-theme'
│   ├── progress_service.dart # ChangeNotifier, per-unit progress, mirrors web localStorage
│   └── share_service.dart  # Static: shareLink(), openExternal(), download()
│
├── screens/
│   ├── home_screen.dart         # Tab 1: promo banner, hero card, faculty ledger, live courses
│   ├── archives_screen.dart     # Tab 2: live courses + on-deck coming-soon list
│   ├── faculty_screen.dart      # Tab 3: searchable faculty directory with ratings
│   ├── course_hub_screen.dart   # Course landing: stats, hub cards → files/links
│   ├── file_library_screen.dart # File list with chip filter by FileType
│   ├── external_links_screen.dart # List of curated external resources
│   ├── preview_screen.dart      # WebView PDF viewer (Google Docs proxy), share/download
│   ├── privacy_screen.dart      # Privacy policy (4 sections)
│   └── delete_account_screen.dart # Two-step account deletion flow
│
└── widgets/
    ├── app_shell.dart         # Bottom NavigationBar (4 tabs), wraps all primary screens
    ├── app_promo_banner.dart  # Dormant Android/iOS promo card (show: false by default)
    ├── hero_card.dart         # Standard page header: kicker, title, code badge, desc
    ├── hub_card.dart          # Course detail nav card with icon, tags, "Open →"
    ├── file_card.dart         # File row: type badge, preview/share/save actions, version picker
    ├── faculty_ledger.dart    # Animated professor spotlight carousel (custom ring painter)
    ├── more_sheet.dart        # "More" bottom sheet: privacy, delete, GitHub, theme toggle
    └── search_field.dart      # Reusable styled search input (scaffold for future search index)

test/
  widget_test.dart            # Default Flutter smoke test (minimal)

assets/
  images/                     # Image assets (referenced in pubspec.yaml)
  icons/                      # Icon assets (referenced in pubspec.yaml)
```

---

## Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter: { sdk: flutter }
  cupertino_icons: ^1.0.6

  go_router: ^14.2.0        # Routing
  provider: ^6.1.2          # State management

  shared_preferences: ^2.2.3 # Theme + progress persistence
  dio: ^5.4.3+1              # File downloads
  path_provider: ^2.1.3      # App documents directory for saved files

  share_plus: ^9.0.0         # Native share sheet
  url_launcher: ^6.3.0       # Open URLs in system browser
  webview_flutter: ^4.8.0    # PDF / web preview

  # supabase_flutter: ^2.5.6 # Optional backend — uncomment to enable
```

---

## Routing

Routes are declared in [lib/router.dart](lib/router.dart). The shell is a `StatefulShellRoute` with three branches:

| Branch | Path | Screen |
|---|---|---|
| 0 | `/home` | HomeScreen |
| 1 | `/archives` | ArchivesScreen |
| 1 | `/archives/course/:slug` | CourseHubScreen |
| 1 | `/archives/course/:slug/files` | FileLibraryScreen |
| 1 | `/archives/course/:slug/links` | ExternalLinksScreen |
| 2 | `/faculty` | FacultyScreen |
| — | `/privacy` | PrivacyScreen (outside shell) |
| — | `/delete-account` | DeleteAccountScreen (outside shell) |
| — | `/preview?url=…&title=…` | PreviewScreen (outside shell) |

Navigation from anywhere: `context.go('/path')` for tab switches, `context.push('/path')` for stack pushes within a branch.

---

## State Management

Two global `ChangeNotifier` providers, registered in `main.dart`:

- **`ThemeService`** — light/dark mode. Persisted under `'ee-theme'` in SharedPreferences. Toggle via `theme.toggle()` or `theme.setMode(mode)`.
- **`ProgressService`** — per-unit completion tracking. Stored as `StringList` of `"key=value"` pairs, mirrors the web app's `eceuh:progress` localStorage key.

Read via `context.watch<T>()` (rebuild on change) or `context.read<T>()` (one-shot / callbacks).

---

## Theme System

All color, typography, and shape tokens live in [lib/theme.dart](lib/theme.dart).

- **`EceuhPalette`** — named color constants for both dark (`d*`) and light (`l*`) variants.
- **`EceuhTheme.dark()` / `EceuhTheme.light()`** — full `ThemeData` with Material 3 components preconfigured.
- **`EceuhExtras`** — a `ThemeExtension` for project-specific tokens not covered by Material (e.g., `overlayBg`, `active`, `accentDeep`).

Access extras: `Theme.of(context).extension<EceuhExtras>()!`

Typography uses three families (currently falling back to system fonts — bundle to activate):
- `Lora` — serif, for display/headline/title
- `Inter` — sans, for body/label
- `JetBrains Mono` — mono, for badges/kicker/code

---

## Data Layer

All data is **static const** Dart. No network calls for content data.

| File | Key export | Notes |
|---|---|---|
| `data/courses.dart` | `kCourses`, `courseBySlug()` | 16+ courses; `isLive` flag gates navigation |
| `data/professors.dart` | `kProfessorCourses` | Includes RMP ratings scraped at data-entry time |
| `data/course_files.dart` | `kCourseFiles` | R2 bucket URLs; `_R2` inner class holds base URL per course |
| `data/course_links.dart` | `kCourseLinks` | 6–8 curated links per live course |

When adding a new course:
1. Add a `Course` entry in `kCourses` with `isLive: true`.
2. Add a `List<FileEntry>` entry in `kCourseFiles` keyed by slug.
3. Add a `List<LinkEntry>` entry in `kCourseLinks` keyed by slug.
4. Optionally add professors to `kProfessorCourses`.

---

## Services

- **`ShareService`** — all methods are static. Import and call directly, no provider needed.
  - `shareLink({title, url})` — native share sheet
  - `openExternal(url)` — system browser, `externalApplication` launch mode
  - `download(url, filename?)` — saves to app documents dir via Dio; filename inferred from URL if omitted; returns path or null

- **`ThemeService`** / **`ProgressService`** — call `.load()` once at startup (done in `main.dart`); thereafter use provider.

---

## PDF Preview

`PreviewScreen` routes all PDFs through Google Docs Viewer:
```
https://docs.google.com/gviewer?embedded=true&url=<encoded_url>
```
This matches the web app's approach. Don't bypass this — direct PDF URLs fail on webview without a native PDF renderer.

---

## What's Already Built

- Bottom-nav shell with tab state preservation
- Home, Archives, Faculty primary tabs
- 16+ courses (3 live: `circuits2`, `cprog`, `dld`)
- CourseHub → FileLibrary + ExternalLinks nested navigation
- 100+ course files with type-based chip filtering, multi-version support
- Faculty directory with search, rating bars, RMP deep links
- Animated professor spotlight carousel with custom ring painter
- Light/dark theme with SharedPreferences persistence
- Per-unit progress tracking
- PDF/web preview screen with share + download actions
- Privacy policy and two-step account deletion screens
- "More" bottom sheet (privacy, delete account, GitHub, theme toggle)
- AppPromoBanner component (dormant, ready to activate)

---

## Pending / Known TODOs

- **Bundle fonts** — uncomment the `fonts:` block in `pubspec.yaml` and add Lora, Inter, JetBrains Mono font files to `assets/`.
- **App icon + splash screen** — not yet generated; needs `flutter_launcher_icons` or manual setup.
- **Real search** — `SearchField` is wired for `onChanged` but searches nothing yet; `FacultyScreen` has its own local filter as a reference pattern.
- **Supabase integration** — uncomment `supabase_flutter` in pubspec and initialize in `main.dart` to enable progress sync across devices.
- **Platform directories** — `android/` and `ios/` have not been generated; run `flutter create . --platforms=android,ios` to scaffold them.
- **Faculty Ledger cycle** — animation timer is 4.8 s; tune if felt too fast on device.

---

## Conventions

### Code style
- All `const` constructors where possible (enforced by linter).
- `Keys` on all custom widgets (enforced by `use_key_in_widget_constructors` rule).
- No `print()` in production paths (rule is set to `false` for debug convenience — remove before release).
- Widget files export one public widget; private helpers (`_ClassName`) stay in the same file.
- Screens are stateless by default; use `StatefulWidget` only when local ephemeral state is needed (e.g., filter chip selection, animation controllers).

### Adding a widget
- Place in `lib/widgets/` if reused across 2+ screens, otherwise keep it private in the screen file.
- Follow `HeroCard` / `HubCard` as the pattern: named params, no positional args past the first.
- Use `EceuhPalette` tokens or `Theme.of(context)` — never hardcode hex colors.

### Adding a screen
- Register the route in `router.dart` before building the screen.
- Screens outside the shell (modal-style) use `context.push()`; tab-level screens use `context.go()`.
- Every screen gets a `HeroCard` as its page header (kicker → title → desc).

### File / link entries
- All file URLs point to the Cloudflare R2 bucket; use the `_R2` URL builder pattern in `course_files.dart`.
- URL-encode spaces and special characters in filenames.
- `FileType` controls card badge color and chip label — pick the most specific type.

### Contact / ownership
- Privacy contact: `mail@felipejmiranda.com`
- Third-party services referenced in privacy policy: Supabase, Vercel Analytics, Cloudflare R2.
