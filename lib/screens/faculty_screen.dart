import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/professors.dart';
import '../models/professor.dart';
import '../motion.dart';
import '../theme.dart';

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
    // header (kicker, title, description) + search field
    _a = List.generate(2, (i) => Motion.stagger(_ctrl, i));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
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
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          FadeSlide(
            animation: _a[0],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DIRECTORY //', style: TextStyle(color: t.textDim, fontFamily: t.mono, fontSize: 11, letterSpacing: 2)),
                const SizedBox(height: 6),
                Text('Faculty Ratings',
                  style: TextStyle(fontFamily: t.serif, fontSize: 32, fontWeight: FontWeight.w700, height: 1.05, letterSpacing: -1, color: t.text)),
                const SizedBox(height: 12),
                Text('Sourced manually from RateMyProfessors. Click any card to view the original profile.',
                  style: TextStyle(color: t.textMuted, fontSize: 14, height: 1.55)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FadeSlide(
            animation: _a[1],
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search courses or professors…',
              ),
            ),
          ),
          const SizedBox(height: 18),
          for (final course in filtered) _CourseBlock(course: course),
        ],
      ),
    );
  }
}

class _CourseBlock extends StatelessWidget {
  const _CourseBlock({required this.course});
  final ProfessorCourse course;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Motion.mid,
      curve: Motion.std,
      builder: (context, v, child) => Opacity(opacity: v, child: child),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: t.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: t.border),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(course.title, style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 18, color: t.text)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: t.accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                  child: Text(course.code.replaceAll(' ', '_'), style: TextStyle(fontFamily: t.mono, fontSize: 10, color: t.accent, fontWeight: FontWeight.w700, letterSpacing: 1)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...course.profs.map((p) => _ProfRow(p: p)),
          ],
        ),
      ),
    );
  }
}

class _ProfRow extends StatelessWidget {
  const _ProfRow({required this.p});
  final Professor p;

  Color _meterColor(double? value, BuildContext ctx) {
    if (value == null) return EceuhExtras.of(ctx).border;
    if (value >= 4)   return const Color(0xFF15803D);
    if (value >= 2.5) return const Color(0xFFB45309);
    return const Color(0xFFB91C1C);
  }

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.overlay,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFF6363) : const Color(0xFFB94A4A),
                  const Color(0xFF7A2828),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              alignment: Alignment.center,
              child: Text(p.initials, style: TextStyle(fontFamily: t.serif, color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.4)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.name, style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 17, color: t.text)),
                Text(p.dept, style: TextStyle(color: t.textDim, fontSize: 12)),
              ]),
            ),
          ]),
          if (p.hasRating) ...[
            const SizedBox(height: 14),
            _MeterRow(label: 'OVERALL RATING', value: '${p.overall!.toStringAsFixed(1)} / 5.0', meter: (p.overall ?? 0) / 5, color: _meterColor(p.overall, context)),
            const SizedBox(height: 8),
            _MeterRow(label: 'DIFFICULTY', value: '${p.difficulty?.toStringAsFixed(1) ?? '—'} / 5.0', meter: (p.difficulty ?? 0) / 5, color: _meterColor(p.difficulty, context)),
            const SizedBox(height: 8),
            _MeterRow(label: 'WOULD TAKE AGAIN', value: '${p.wouldTake ?? '—'}%', meter: (p.wouldTake ?? 0) / 100, color: const Color(0xFF15803D)),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('No ratings yet.', style: TextStyle(color: t.textDim, fontStyle: FontStyle.italic, fontSize: 12)),
            ),
          if (p.rmpUrl != null) ...[
            const SizedBox(height: 14),
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

class _MeterRow extends StatelessWidget {
  const _MeterRow({required this.label, required this.value, required this.meter, required this.color});
  final String label, value;
  final double meter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: t.textDim, fontSize: 11, letterSpacing: 0.6, fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(color: color, fontFamily: t.mono, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 4),
      ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: meter.clamp(0, 1)),
          duration: const Duration(milliseconds: 900),
          curve: Motion.std,
          builder: (_, v, __) => LinearProgressIndicator(
            value: v,
            minHeight: 6,
            backgroundColor: t.border,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ),
    ]);
  }
}
