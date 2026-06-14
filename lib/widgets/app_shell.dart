import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'more_sheet.dart';

/// Bottom-nav scaffold. Wraps the three primary tabs (Home / Archives /
/// Faculty) and a More button that opens a bottom sheet.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  int _indexFor(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/archives') || loc.startsWith('/course')) return 1;
    if (loc.startsWith('/faculty')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _indexFor(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/home'); break;
            case 1: context.go('/archives'); break;
            case 2: context.go('/faculty'); break;
            case 3:
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                showDragHandle: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
                builder: (_) => const MoreSheet(),
              );
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Archives'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Faculty'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}
