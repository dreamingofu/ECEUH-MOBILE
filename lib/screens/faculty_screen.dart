import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/professors.dart';
import '../design/tokens.dart';
import '../models/professor.dart';
import '../motion.dart';
import '../theme.dart';
import '../widgets/glass/glass_card.dart';
import '../widgets/glass/glass_chip.dart';
import '../widgets/search_field.dart';

class FacultyScreen extends StatefulWidget {
  const FacultyScreen({super.key});

  @override
  State<FacultyScreen> createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _a;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Motion.enter)..forward();
    _a = List.generate(1, (i) => Motion.stagger(_ctrl, i));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final filtered = q.isEmpty
        ? kProfessorCourses
        : kProfessorCourses
            .map((c) => ProfessorCourse(
              id: c.id, code: c.code, title: c.title,
              profs: c.profs.where((p) =>
                p.name.toLowerCase().contains(q) ||
                c.title.toLowerCase().contains(q) ||
                c.code.toLowerCase().contains(q)
              ).toList(),
            ))
            .where((c) => c.profs.isNotEmpty)
            .toList();

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(Spacing.s2, Spacing.s4, Spacing.s2, Spacing.s3),
        children: [
          FadeSlide(
            animation: _a[0],
            child: SearchField(
              hint: 'Search courses or professors…',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: Spacing.s3),
          for (final course in filtered) _CourseSection(course: course),
        ],
      ),
    );
  }
}

/// A course header floating above its professor cards — no outer container.
/// Removing the nested elevation lets each prof card read as its own glass
/// surface against the scaffold, per the design system's "elevation through
/// glass + breathing room" guidance.
class _CourseSection extends StatelessWidget {
  const _CourseSection({required this.course});
  final ProfessorCourse course;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Motion.mid,
      curve: Motion.std,
      builder: (_, v, child) => Opacity(opacity: v, child: child),
      child: Padding(
        padding: const EdgeInsets.only(bottom: Spacing.s3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.s1),
              child: Row(
                children: [
                  Expanded(
                    child: Text(course.title,
                      style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 16, color: t.text)),
                  ),
                  const SizedBox(width: Spacing.s1),
                  GlassChip(label: course.code.replaceAll(' ', '_')),
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < course.profs.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _ProfCard(p: course.profs[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfCard extends StatelessWidget {
  const _ProfCard({required this.p});
  final Professor p;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(18),
      elevation: AppElevation.soft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _AvatarChip(initials: p.initials),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 17, color: t.text)),
                Text(p.dept, style: TextStyle(color: t.textDim, fontSize: 12)),
              ]),
            ),
          ]),
          if (p.hasRating) ...[
            const SizedBox(height: Spacing.s2),
            _MeterRow(label: 'OVERALL RATING',   value: '${p.overall!.toStringAsFixed(1)} / 5.0',                   meter: (p.overall ?? 0) / 5),
            const SizedBox(height: Spacing.s1),
            _MeterRow(label: 'DIFFICULTY',       value: '${p.difficulty?.toStringAsFixed(1) ?? '—'} / 5.0',         meter: (p.difficulty ?? 0) / 5),
            const SizedBox(height: Spacing.s1),
            _MeterRow(label: 'WOULD TAKE AGAIN', value: '${p.wouldTake ?? '—'}%',                                   meter: (p.wouldTake ?? 0) / 100),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('No ratings yet.', style: TextStyle(color: t.textDim, fontStyle: FontStyle.italic, fontSize: 12)),
            ),
          if (p.rmpUrl != null) ...[
            const SizedBox(height: Spacing.s2),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.open_in_new, size: 14),
                label: const Text('View on RMP'),
                onPressed: () => launchUrl(Uri.parse(p.rmpUrl!), mode: LaunchMode.externalApplication),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Soft accent-tinted circle with bold gold initials. Replaces the previous
/// red-gradient avatar which violated the design system's gold-anchored,
/// no-mid-tone palette rules.
class _AvatarChip extends StatelessWidget {
  const _AvatarChip({required this.initials});
  final String initials;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: t.accent.withValues(alpha: 0.12),
        border: Border.all(color: t.accent.withValues(alpha: 0.32), width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(initials,
        style: TextStyle(fontFamily: t.serif, color: t.accent, fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 0.6)),
    );
  }
}

class _MeterRow extends StatelessWidget {
  const _MeterRow({required this.label, required this.value, required this.meter});
  final String label, value;
  final double meter;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: t.textDim, fontSize: 11, letterSpacing: 0.6, fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(color: t.accent, fontFamily: t.mono, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 4),
      ClipRRect(
        borderRadius: BorderRadius.circular(Radii.pill),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: meter.clamp(0, 1)),
          duration: const Duration(milliseconds: 900),
          curve: Motion.std,
          builder: (_, v, __) => LinearProgressIndicator(
            value: v,
            minHeight: 6,
            backgroundColor: t.border,
            valueColor: AlwaysStoppedAnimation(t.accent),
          ),
        ),
      ),
    ]);
  }
}
