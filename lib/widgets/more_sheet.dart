import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/theme_service.dart';
import '../theme.dart';

class MoreSheet extends StatelessWidget {
  const MoreSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('More', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 14),
            _MoreItem(icon: Icons.settings_outlined, title: 'Settings', subtitle: 'Profile, notifications, appearance',
              onTap: () { Navigator.pop(context); context.push('/settings'); }),
            _MoreItem(icon: Icons.shield_outlined, title: 'Privacy Policy', subtitle: 'What we collect and why',
              onTap: () { Navigator.pop(context); context.push('/privacy'); }),
            _MoreItem(icon: Icons.delete_outline, title: 'Delete Account', subtitle: 'Remove your data in 7 days',
              onTap: () { Navigator.pop(context); context.push('/delete-account'); }),
            _MoreItem(icon: Icons.code, title: 'GitHub', subtitle: 'Source & contributions',
              onTap: () => launchUrl(Uri.parse('https://github.com/dreamingofu/eceuh'),
                  mode: LaunchMode.externalApplication)),
            _MoreItem(
              icon: theme.mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              title: 'Toggle theme',
              subtitle: theme.mode == ThemeMode.dark ? 'Switch to light' : 'Switch to dark',
              onTap: () => theme.toggle(),
              keepOpen: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreItem extends StatelessWidget {
  const _MoreItem({required this.icon, required this.title, required this.subtitle, required this.onTap, this.keepOpen = false});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool keepOpen;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: t.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: t.accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: t.serif, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(color: t.textDim, fontSize: 11, letterSpacing: 0.04)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: t.textDim, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
