import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/courses.dart';
import '../design/tokens.dart';
import '../models/course.dart';
import '../motion.dart';
import '../theme.dart';
import '../widgets/glass/glass_card.dart';

class ArchivesScreen extends StatefulWidget {
  const ArchivesScreen({super.key});

  @override
  State<ArchivesScreen> createState() => _ArchivesScreenState();
}

class _ArchivesScreenState extends State<ArchivesScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _a;

  @override
  void initState() {
    super.initState();
    final count = 3 + liveCourses.length + 2;
    _ctrl = AnimationController(vsync: this, duration: Motion.enter)..forward();
    _a = List.generate(count, (i) => Motion.stagger(_ctrl, i));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    var ai = 0;

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(Spacing.s2, Spacing.s2, Spacing.s2, Spacing.s3),
        children: [
          FadeSlide(
            animation: _a[ai++],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('COURSE ARCHIVES',
                  style: TextStyle(fontFamily: t.mono, fontWeight: FontWeight.w700, fontSize: 12, color: t.accent, letterSpacing: 1.4)),
                const SizedBox(height: 8),
                Text('Every course in the ECE base.',
                  style: TextStyle(fontFamily: t.serif, fontSize: 32, fontWeight: FontWeight.w700, height: 1.05, letterSpacing: -1, color: t.text)),
                const SizedBox(height: 12),
                Text('Live courses have full walkthroughs, files, and resources. The rest are on deck and get added one at a time.',
                  style: TextStyle(color: t.textMuted, fontSize: 14, height: 1.55)),
              ],
            ),
          ),
          const SizedBox(height: Spacing.s4 - 4),
          FadeSlide(
            animation: _a[ai++],
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('Live', style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 24, color: t.text)),
              const SizedBox(width: 8),
              Text('Active content', style: TextStyle(color: t.textDim, fontSize: 12, fontFamily: t.mono)),
            ]),
          ),
          const SizedBox(height: 12),
          for (final c in liveCourses)
            FadeSlide(
              animation: _a[ai++],
              child: _LiveCard(course: c, onTap: () => context.push('/archives/course/${c.slug}')),
            ),
          const SizedBox(height: Spacing.s4 - 4),
          FadeSlide(
            animation: _a[ai++],
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('On Deck', style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 22, color: t.textMuted)),
              const SizedBox(width: 8),
              Text('Coming soon · ${upcomingCourses.length} courses', style: TextStyle(color: t.textDim, fontSize: 12, fontFamily: t.mono)),
            ]),
          ),
          const SizedBox(height: 12),
          FadeSlide(
            animation: _a[ai],
            child: GlassCard(
              padding: EdgeInsets.zero,
              radius: Radii.md,
              child: Column(
                children: [
                  for (int i = 0; i < upcomingCourses.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.s2, vertical: 14),
                      decoration: i < upcomingCourses.length - 1
                          ? BoxDecoration(border: Border(bottom: BorderSide(color: t.border)))
                          : null,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: Text(upcomingCourses[i].code,
                              style: TextStyle(fontFamily: t.mono, fontSize: 11, color: t.textDim, fontWeight: FontWeight.w700)),
                          ),
                          Expanded(
                            child: Text(upcomingCourses[i].displayArchiveTitle,
                              style: TextStyle(color: t.textMuted, fontSize: 14)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: t.border, borderRadius: BorderRadius.circular(Radii.pill)),
                            child: Text('Coming soon', style: TextStyle(color: t.textDim, fontSize: 10, letterSpacing: 0.5)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveCard extends StatelessWidget {
  const _LiveCard({required this.course, required this.onTap});
  final Course course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PressScale(
        borderRadius: BorderRadius.circular(Radii.lg),
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.all(Spacing.s2),
          radius: Radii.lg,
          elevation: AppElevation.soft,
          child: Row(children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: t.accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(Radii.sm + 6),
              ),
              child: Icon(Icons.menu_book_outlined, color: t.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(course.code,
                  style: TextStyle(fontFamily: t.mono, fontSize: 10, color: t.accent, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(course.displayArchiveTitle,
                  style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 17, fontStyle: FontStyle.italic, color: t.text)),
                const SizedBox(height: 4),
                Text('${course.units} units · Live', style: TextStyle(color: t.textDim, fontSize: 12)),
              ]),
            ),
            Icon(Icons.chevron_right, color: t.textDim),
          ]),
        ),
      ),
    );
  }
}
