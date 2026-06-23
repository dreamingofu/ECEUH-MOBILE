# ECEUH Mobile — CLAUDE.md

Flutter port of [eceuh.com](https://eceuh.com), a knowledge base for UH Electrical & Computer Engineering students. Serves course archives, file libraries, faculty ratings, and curated external resources.

## Developer Context

- **Dev:** Third-year EE student at University of Houston (Cullen College of Engineering)
- **GitHub:** dreamingofu
- **Related project:** eceuh.com (web version, already live) — the mobile app mirrors its structure and data
- **Goal:** Ship to Google Play Store; iOS is secondary
- **Skill level:** Comfortable with embedded systems and web dev; Flutter is newer territory — prefer explanations when introducing unfamiliar Flutter patterns

---

## Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.22+ / Dart 3.3+ |
| State management | `provider` (ChangeNotifier) |
| Routing | `go_router` 14 with `ShellRoute` |
| Persistence | `shared_preferences` |
| Networking / downloads | `dio`, `path_provider` |
| PDF preview | `webview_flutter` (Google Docs Viewer proxy) |
| Share sheet | `share_plus` |
| External links | `url_launcher` |
| Fonts | `google_fonts` |
| Backend (opt-in) | Supabase — commented out, ready to enable |
| Linting | `flutter_lints` |

---

## Folder Structure

```
lib/
├── main.dart               # Entry point — inits SharedPreferences, wires MultiProvider
├── app.dart                # MaterialApp.router, reads ThemeService for light/dark
├── theme.dart              # EceuhTheme (light/dark), EceuhExtras ThemeExtension
├── router.dart             # GoRouter config, shell + nested routes
├── motion.dart             # Motion constants, FadeSlide, PressScale, Transitions, HeroLeash
│
├── design/
│   └── tokens.dart         # Spacing, Radii, Blur, GlassBorder, AppElevation
│
├── models/
│   ├── course.dart         # Course, CourseHub, CourseSections, SectionRef
│   ├── professor.dart      # ProfessorCourse, Professor (with RMP data)
│   ├── file_entry.dart     # FileEntry, FileVersion, FileType enum + label ext
│   ├── link_entry.dart     # LinkEntry
│   └── club.dart           # Club (name, slug, desc, icon, tags, links, meetingTime, location)
│
├── data/
│   ├── courses.dart        # kCourses, courseBySlug(), live/upcoming getters
│   ├── professors.dart     # kProfessorCourses
│   ├── course_files.dart   # kCourseFiles (Map<slug, List<FileEntry>>), R2 bucket URLs
│   ├── course_links.dart   # kCourseLinks (Map<slug, List<LinkEntry>>)
│   └── clubs.dart          # kClubs (8 UH ECE clubs), clubBySlug()
│
├── services/
│   ├── theme_service.dart  # ChangeNotifier, persists ThemeMode under 'ee-theme'
│   ├── progress_service.dart # ChangeNotifier, per-unit progress, mirrors web localStorage
│   └── share_service.dart  # Static: shareLink(), openExternal(), download()
│
├── screens/
│   ├── home_screen.dart         # Tab 0: promo banner, hero card, faculty ledger, live courses
│   ├── archives_screen.dart     # Tab 1: live courses + on-deck list; stagger animations
│   ├── clubs_screen.dart        # Tab 2: searchable list of all clubs
│   ├── faculty_screen.dart      # Tab 3: searchable faculty directory with ratings
│   ├── settings_screen.dart     # Tab 4: theme toggle, sign in/out, links
│   ├── course_hub_screen.dart   # Course landing: stats, hub cards → files/links
│   ├── file_library_screen.dart # File list with chip filter by FileType
│   ├── external_links_screen.dart # List of curated external resources
│   ├── club_detail_screen.dart  # Club detail: info, meeting time, links
│   ├── preview_screen.dart      # WebView PDF viewer (Google Docs proxy), share/download
│   ├── sign_in_screen.dart      # Auth screen (Supabase, currently stubbed)
│   ├── privacy_screen.dart      # Privacy policy
│   └── delete_account_screen.dart # Two-step account deletion flow
│
└── widgets/
    ├── app_shell.dart         # Top AppBar + 5-tab PillNav (Academy/Research/Clubs/Ratings/Account)
    ├── app_promo_banner.dart  # Dormant Android/iOS promo card (show: false by default)
    ├── hero_card.dart         # Standard page header: kicker, title, code badge, desc
    ├── hub_card.dart          # Course detail nav card with icon, tags, "Open →"
    ├── file_card.dart         # File row: type badge, preview/share/save, version picker
    ├── faculty_ledger.dart    # Animated professor spotlight carousel (custom ring painter)
    ├── gold_button.dart       # Premium CTA button with gold gradient
    ├── more_sheet.dart        # "More" bottom sheet: privacy, delete, GitHub, theme toggle
    ├── search_field.dart      # Reusable styled search input (hint + onChanged)
    └── glass/
        ├── glass_card.dart    # Glassmorphic surface: blur + translucent fill + 1px border
        ├── glass_bar.dart     # Glassmorphic bar (used for persistent overlays)
        ├── glass_chip.dart    # Pill tag — variants: premium, accent, neutral
        └── glass_sheet.dart   # Bottom-sheet glass surface

android/                    # Android platform layer (scaffolded)
test/
  widget_test.dart
  shell_render_test.dart    # Smoke test for AppShell rendering
assets/
  images/
  icons/
```

---

## Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter: { sdk: flutter }
  cupertino_icons: ^1.0.6
  google_fonts: ^6.x        # Sora typeface (serif/sans/mono all use Sora)

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

Routes are declared in [lib/router.dart](lib/router.dart). The shell is a `ShellRoute` — tab state is NOT preserved between tab switches (no `StatefulShellRoute`).

| Tab | Path | Screen |
|---|---|---|
| 0 | `/home` | HomeScreen |
| 1 | `/archives` | ArchivesScreen |
| 1 | `/archives/course/:slug` | CourseHubScreen |
| 1 | `/archives/course/:slug/files` | FileLibraryScreen |
| 1 | `/archives/course/:slug/links` | ExternalLinksScreen |
| 2 | `/clubs` | ClubsScreen |
| 2 | `/clubs/:slug` | ClubDetailScreen |
| 3 | `/faculty` | FacultyScreen |
| 4 | `/settings` | SettingsScreen |
| — | `/sign-in` | SignInScreen (outside shell) |
| — | `/privacy` | PrivacyScreen (outside shell) |
| — | `/delete-account` | DeleteAccountScreen (outside shell) |
| — | `/preview?url=…&title=…` | PreviewScreen (outside shell) |

Navigation: `context.go('/path')` for tab switches, `context.push('/path')` for stack pushes within a branch.

---

## State Management

Two global `ChangeNotifier` providers, registered in `main.dart`:

- **`ThemeService`** — light/dark mode. Persisted under `'ee-theme'` in SharedPreferences. Toggle via `theme.toggle()` or `theme.setMode(mode)`.
- **`ProgressService`** — per-unit completion tracking. Stored as `StringList` of `"key=value"` pairs, mirrors the web app's `eceuh:progress` localStorage key.

Read via `context.watch<T>()` (rebuild on change) or `context.read<T>()` (one-shot / callbacks).

---

## Theme & Design System ("Kinetic Luxe")

All tokens live in [lib/theme.dart](lib/theme.dart) and [lib/design/tokens.dart](lib/design/tokens.dart).

- **`EceuhExtras`** — `ThemeExtension` for project tokens: `accent`, `accentDeep`, `card`, `overlay`, `text`, `textSoft`, `textMuted`, `textDim`, `border`, `goldStart`, `goldEnd`, `serif`, `sans`, `mono`. Access via `EceuhExtras.of(context)`.
- **`EceuhTheme.dark()` / `EceuhTheme.light()`** — full Material 3 `ThemeData`.
- **`Spacing`** — 8px base unit: `s1=8`, `s2=16`, `s3=24`, `s4=32`, `s5=40`, `s6=48`.
- **`Radii`** — `sm=8`, `md=16`, `lg=24`, `xl=32`, `pill=999`.
- **`AppElevation`** — `flat`, `soft`, `lifted` — each returns `List<BoxShadow>`.
- **`Blur`** — `light=12`, `medium=16`, `heavy=20` for `BackdropFilter`.

Typography: all three font families (`t.serif`, `t.sans`, `t.mono`) resolve to **Sora** via `google_fonts`.

---

## Motion System

[lib/motion.dart](lib/motion.dart) provides:

- **`Motion`** — duration constants (`press`, `fast`, `mid`, `slow`, `enter`) and curve constants (`std`, `decel`, `accel`, `spring`, `elastic`).
- **`Motion.stagger(ctrl, index)`** — `CurvedAnimation` for sequenced entrance; items 72ms apart, all done by `Motion.enter` (800ms).
- **`FadeSlide`** — fade-in + upward drift entrance widget. Pair with `Motion.stagger`.
- **`PressScale`** — 0.97× scale-down on press. Use to wrap every tappable card.
- **`Transitions`** — `fadeThrough` and `sharedAxis` `Page` builders for custom route transitions.
- **`HeroLeash`** — `Hero` wrapper that prevents cross-fade flicker during flight.

Standard screen entrance pattern:
```dart
// in initState:
_ctrl = AnimationController(vsync: this, duration: Motion.enter)..forward();
_a = List.generate(N, (i) => Motion.stagger(_ctrl, i));

// in build:
FadeSlide(animation: _a[0], child: ...)
```

---

## Glass Widget System

All glassmorphic surfaces are in [lib/widgets/glass/](lib/widgets/glass/).

- **`GlassCard`** — main surface. Params: `child`, `padding`, `radius` (default `Radii.xl`), `blur` (default `Blur.light`), `elevation`, `tinted`. Dark mode adds a top-edge gradient.
- **`GlassChip`** — pill tag. Variants: `premium` (navy bg / gold text), `accent` (gold-tinted), `neutral` (muted border + overlay bg).
- **`GlassBar`** / **`GlassSheet`** — bar and bottom-sheet variants.

---

## Data Layer

All content data is **static const** Dart — no network fetches.

| File | Key export | Notes |
|---|---|---|
| `data/courses.dart` | `kCourses`, `courseBySlug()` | 16+ courses; `isLive` gates navigation |
| `data/professors.dart` | `kProfessorCourses` | RMP ratings scraped at data-entry time |
| `data/course_files.dart` | `kCourseFiles` | R2 bucket URLs; `_R2` inner class per course |
| `data/course_links.dart` | `kCourseLinks` | 6–8 curated links per live course |
| `data/clubs.dart` | `kClubs`, `clubBySlug()` | 8 UH ECE clubs |

**Adding a new course:**
1. Add `Course` to `kCourses` with `isLive: true`.
2. Add `List<FileEntry>` to `kCourseFiles` keyed by slug.
3. Add `List<LinkEntry>` to `kCourseLinks` keyed by slug.
4. Optionally add professors to `kProfessorCourses`.

**Adding a new club:**
1. Add `Club` to `kClubs` in `data/clubs.dart`. That's it — no route changes needed.

---

## Services

- **`ShareService`** — all methods static. Import and call directly.
  - `shareLink({title, url})` — native share sheet
  - `openExternal(url)` — system browser, `externalApplication` launch mode
  - `download(url, filename?)` — saves to app documents dir via Dio; returns path or null

- **`ThemeService`** / **`ProgressService`** — `.load()` called once in `main.dart`; use provider thereafter.

---

## PDF Preview

`PreviewScreen` routes all PDFs through Google Docs Viewer:
```
https://docs.google.com/gviewer?embedded=true&url=<encoded_url>
```
Direct PDF URLs fail on webview without a native renderer — don't bypass this proxy.

---

## What's Already Built

- 5-tab bottom nav shell (Academy, Research, Clubs, Ratings, Account)
- Home, Archives, Faculty, Settings primary tabs
- 16+ courses (3 live: `circuits2`, `cprog`, `dld`)
- CourseHub → FileLibrary + ExternalLinks nested navigation
- 100+ course files with type-based chip filtering, multi-version support
- Faculty directory with search, rating bars, RMP deep links
- Animated professor spotlight carousel with custom ring painter
- **Clubs directory** — 8 UH ECE clubs, searchable by name/tag/desc, with detail screen (info + links)
- Light/dark theme with SharedPreferences persistence (Sora font via google_fonts)
- Per-unit progress tracking
- Glass surface system (GlassCard, GlassChip, GlassBar, GlassSheet)
- Kinetic Luxe motion system (FadeSlide, PressScale, stagger animations)
- PDF/web preview with share + download
- Sign-in screen (stubbed), privacy policy, account deletion

---

## Feature Roadmap

### ✅ Phase 0 — Foundation (done)
Courses, Faculty, File Library, PDF Preview

### ✅ Phase 1 — Clubs (done)
Static club data + ClubsScreen + ClubDetailScreen

### 🔨 Phase 1 (cont.) — Events (next)

Events are **dynamic** — fetched from Supabase, not static Dart.

**Event model** (`models/event.dart`):
```dart
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String? location;
  final String? clubSlug;
  final String? imageUrl;
  final bool isFeatured;
}
```

**Supabase `events` table:**
```sql
create table events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  starts_at timestamptz not null,
  ends_at timestamptz,
  location text,
  club_slug text,
  image_url text,
  is_featured boolean default false,
  created_at timestamptz default now()
);
```

**New additions:**
- `screens/events_screen.dart` — upcoming events feed, filterable by club/tag
- `services/events_service.dart` — ChangeNotifier, Supabase fetch + cache
- Route: `/events` as a new shell tab (index 3, shifting Ratings to 4, Account to 5)

---

### 📐 Phase 2 — Grade Calculator & Schedule Planner

Pure UI — no backend needed.

- `screens/grade_calculator_screen.dart` — local `StatefulWidget` only
- `screens/schedule_screen.dart` + `services/schedule_service.dart` (SharedPreferences)
- UH grading scale: A=90+, B=80+, C=70+, D=60+, F<60
- Both live inside a "Tools" tab

---

### 🗺️ Phase 3 — Campus Map

- `flutter_map` with OpenStreetMap tiles (no API key)
- `data/map_locations.dart` — static `List<MapLocation>`
- `screens/map_screen.dart`

---

## Pending / Known TODOs

- **Supabase must be enabled for Events** — uncomment `supabase_flutter` in pubspec, initialize in `main.dart`, pass `SUPABASE_URL` and `SUPABASE_ANON_KEY` via `--dart-define`.
- **App icon + splash screen** — not yet generated; needs `flutter_launcher_icons` or manual asset setup.
- **Real search** — `SearchField` is wired for `onChanged` but performs no indexing; `FacultyScreen` and `ClubsScreen` do local in-memory filtering as the reference pattern.
- **Faculty Ledger cycle** — animation timer is 4.8 s; tune if felt too fast on device.
- **Google Play Store** — primary deployment target; needs signing config, `build.gradle` setup, and Play Console listing.
- **Bottom nav expansion** — currently 5 tabs; Events and Tools will add 2 more when those phases land.

---

## Conventions

### Code style
- All `const` constructors where possible (linter-enforced).
- `Keys` on all custom widgets (`use_key_in_widget_constructors` rule).
- No `print()` in production paths.
- Widget files export one public widget; private helpers (`_ClassName`) stay in the same file.
- Screens are `StatelessWidget` by default; use `StatefulWidget` only for local ephemeral state (filter selection, animation controllers).

### Screen entrance animation
Every list/content screen follows this exact pattern:
```dart
class _MyScreenState extends State<MyScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _a;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Motion.enter)..forward();
    _a = List.generate(N, (i) => Motion.stagger(_ctrl, i));
  }
  // wrap each section in FadeSlide(animation: _a[i], child: ...)
```

### Adding a widget
- Place in `lib/widgets/` if reused across 2+ screens; otherwise keep it private in the screen file.
- Follow `HeroCard` / `HubCard` as the naming/param pattern: named params, no positional args.
- Use `EceuhExtras.of(context)` tokens or `Theme.of(context)` — never hardcode colors.
- Tappable cards: always wrap in `PressScale` + `GlassCard`.

### Adding a screen
- Register the route in `router.dart` before building the screen.
- Tab-root screens use `NoTransitionPage`; pushed detail screens use `MaterialPage`.
- `context.go()` for tab switches, `context.push()` for stack pushes.
- Every screen gets a `HeroCard` as its page header (kicker → title → desc).
- Detail screens that are pushed (not tab roots) include their own `Scaffold` with `AppBar` + back button.

### File / link entries
- All file URLs point to the Cloudflare R2 bucket; use the `_R2` URL builder pattern in `course_files.dart`.
- URL-encode spaces and special characters in filenames.
- `FileType` controls card badge color and chip label — pick the most specific type.

---

## Notes for Claude

- **Clubs = static, Events = Supabase** — clubs data is hardcoded Dart; events are fetched from Supabase. Don't mix these up.
- **Supabase is currently off** — it's commented out in pubspec. Only enable it when starting the Events feature.
- **Grade calculator and schedule planner are pure UI** — no backend, no provider; local `StatefulWidget` state only.
- **Campus map = flutter_map + OSM** — do not suggest `google_maps_flutter` (requires API key billing); use `flutter_map` with OpenStreetMap tiles.
- **Google Play first** — when discussing deployment, focus on Android/Play Store; iOS is out of scope for now.
- **Match existing patterns** — before adding anything new, read `HeroCard`, `HubCard`, and `_LiveCard` (archives_screen.dart) to understand the structure. New club cards follow `_ClubCard`; new event cards get their own `EventCard` widget.
- **Explain Flutter patterns** — the dev knows embedded C and web dev but Flutter is newer; briefly explain why you're using a specific widget or pattern when it's non-obvious.
- **Bottom nav will need restructuring again** — when adding Events, insert it at index 3 (pushing Ratings to 4, Account to 5). When adding Tools, it goes at index 5.
- **ShellRoute, not StatefulShellRoute** — tab state is NOT preserved between tab switches. This is intentional for now; don't change it without discussion.
