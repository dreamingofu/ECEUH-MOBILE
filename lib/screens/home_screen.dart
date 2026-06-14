import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/courses.dart';
import '../theme.dart';
import '../widgets/app_promo_banner.dart';
import '../widgets/faculty_ledger.dart';
import '../widgets/search_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const AppPromoBanner(),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            decoration: BoxDecoration(
              color: t.overlay,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: t.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ECE Coursework, archived.',
                  style: TextStyle(fontFamily: t.serif, fontSize: 28, fontWeight: FontWeight.w700, height: 1.05, letterSpacing: -0.6, color: t.text)),
                const SizedBox(height: 10),
                Text(
                  'A living record of homework walkthroughs, lab notes, and faculty ratings — built in real time each semester at the University of Houston.',
                  style: TextStyle(color: t.textSoft, fontSize: 14, height: 1.55),
                ),
                const SizedBox(height: 16),
                const SearchField(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const FacultyLedger(),
          const SizedBox(height: 20),
          Text('Course Archives',
            style: TextStyle(fontFamily: t.serif, fontSize: 22, fontWeight: FontWeight.w700, color: t.text)),
          const SizedBox(height: 4),
          Text('Live courses with full walkthroughs, files, and resources.',
            style: TextStyle(color: t.textMuted, fontSize: 13)),
          const SizedBox(height: 12),
          ...liveCourses.map((c) => _ArchiveTile(
            code: c.code,
            title: c.title,
            units: c.units,
            onTap: () => context.push('/archives/course/${c.slug}'),
          )),
        ],
      ),
    );
  }
}

class _ArchiveTile extends StatelessWidget {
  const _ArchiveTile({required this.code, required this.title, required this.units, required this.onTap});
  final String code, title;
  final int units;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: t.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Text(title, style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: t.text)),
        subtitle: Text('$code  ·  $units units', style: TextStyle(color: t.textDim, fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: t.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text('Live', style: TextStyle(color: t.accent, fontWeight: FontWeight.w700, fontSize: 11)),
        ),
        onTap: onTap,
      ),
    );
  }
}
