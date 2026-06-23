import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/app_shell.dart';
import 'screens/home_screen.dart';
import 'screens/archives_screen.dart';
import 'screens/faculty_screen.dart';
import 'screens/course_hub_screen.dart';
import 'screens/file_library_screen.dart';
import 'screens/external_links_screen.dart';
import 'screens/privacy_screen.dart';
import 'screens/delete_account_screen.dart';
import 'screens/preview_screen.dart';
import 'screens/clubs_screen.dart';
import 'screens/club_detail_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Three primary destinations sit in the bottom nav.
/// Detail pages (course hub, file library, links, privacy, delete) push on top
/// of the active tab so back gestures behave naturally.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          pageBuilder: (c, s) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/archives',
          name: 'archives',
          pageBuilder: (c, s) => const NoTransitionPage(child: ArchivesScreen()),
          routes: [
            GoRoute(
              path: 'course/:slug',
              name: 'course',
              pageBuilder: (c, s) => MaterialPage(child: CourseHubScreen(slug: s.pathParameters['slug']!)),
              routes: [
                GoRoute(
                  path: 'files',
                  name: 'files',
                  pageBuilder: (c, s) => MaterialPage(child: FileLibraryScreen(slug: s.pathParameters['slug']!)),
                ),
                GoRoute(
                  path: 'links',
                  name: 'links',
                  pageBuilder: (c, s) => MaterialPage(child: ExternalLinksScreen(slug: s.pathParameters['slug']!)),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/clubs',
          name: 'clubs',
          pageBuilder: (c, s) => const NoTransitionPage(child: ClubsScreen()),
          routes: [
            GoRoute(
              path: ':slug',
              name: 'club',
              pageBuilder: (c, s) => MaterialPage(child: ClubDetailScreen(slug: s.pathParameters['slug']!)),
            ),
          ],
        ),
        GoRoute(
          path: '/faculty',
          name: 'faculty',
          pageBuilder: (c, s) => const NoTransitionPage(child: FacultyScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (c, s) => const MaterialPage(child: SignInScreen()),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (c, s) => const MaterialPage(child: SettingsScreen()),
    ),
    GoRoute(
      path: '/privacy',
      name: 'privacy',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (c, s) => const MaterialPage(child: PrivacyScreen()),
    ),
    GoRoute(
      path: '/delete-account',
      name: 'delete',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (c, s) => const MaterialPage(child: DeleteAccountScreen()),
    ),
    GoRoute(
      path: '/preview',
      name: 'preview',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (c, s) {
        final url = s.uri.queryParameters['url'] ?? '';
        final title = s.uri.queryParameters['title'] ?? 'Preview';
        return MaterialPage(child: PreviewScreen(url: url, title: title));
      },
    ),
  ],
);
