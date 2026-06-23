import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../motion.dart';
import '../theme.dart';
import 'more_sheet.dart';

/// App chrome — persistent top brand bar + pill-indicator bottom nav.
///
/// Root cause of the historic blank-body bug: the [_PillNav] Row wrapped each
/// tab in [Center]. Flutter's Scaffold passes `maxHeight = screenHeight` (not
/// infinity) to [Scaffold.bottomNavigationBar], so [Center] expanded to fill
/// 800 px, leaving 0 px for the body. Fix: remove [Center] — the Row's own
/// [crossAxisAlignment.center] handles vertical alignment.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  int _indexFor(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/archives') || loc.startsWith('/course')) return 1;
    if (loc.startsWith('/clubs')) return 2;
    if (loc.startsWith('/faculty')) return 3;
    if (loc.startsWith('/settings')) return 4;
    return 0;
  }

  void _openMore(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final scheme = Theme.of(context).colorScheme;
    final index = _indexFor(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: Icon(Icons.menu, color: t.accent, size: 26),
          onPressed: () => _openMore(context),
        ),
        centerTitle: true,
        title: Text(
          'ELITE ENGINEERING',
          style: TextStyle(
            color: t.accent,
            fontFamily: t.serif,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _ProfileChip(onTap: () => context.go('/settings')),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: _PillNav(
        index: index,
        onSelect: (i) {
          switch (i) {
            case 0: context.go('/home'); break;
            case 1: context.go('/archives'); break;
            case 2: context.go('/clubs'); break;
            case 3: context.go('/faculty'); break;
            case 4: context.go('/settings'); break;
          }
        },
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: t.accent.withValues(alpha: 0.14),
            border: Border.all(color: t.accent.withValues(alpha: 0.34), width: 1),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.person, color: t.accent, size: 18),
        ),
      ),
    );
  }
}

/// Bottom navigation with a pill-shaped selected-tab indicator.
/// NOTE: Do NOT wrap [_PillTab] in [Center] here — Center with a finite
/// maxHeight (as passed by Scaffold.bottomNavigationBar) expands to fill
/// the full screen height, leaving zero space for the body.
class _PillNav extends StatelessWidget {
  const _PillNav({required this.index, required this.onSelect});
  final int index;
  final ValueChanged<int> onSelect;

  static const _items = <(IconData, IconData, String)>[
    (Icons.school_outlined,    Icons.school,    'Academy'),
    (Icons.biotech_outlined,   Icons.biotech,   'Research'),
    (Icons.groups_outlined,    Icons.groups,    'Clubs'),
    (Icons.bar_chart_outlined, Icons.bar_chart, 'Ratings'),
    (Icons.person_outline,     Icons.person,    'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: t.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              for (int i = 0; i < _items.length; i++)
                Expanded(
                  child: _PillTab(
                    icon: index == i ? _items[i].$2 : _items[i].$1,
                    label: _items[i].$3,
                    selected: index == i,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillTab extends StatelessWidget {
  const _PillTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? scheme.onPrimary : t.textMuted;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: AnimatedContainer(
            duration: Motion.fast,
            curve: Motion.std,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: selected ? t.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: fg, size: 22),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: t.sans,
                    color: fg,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
