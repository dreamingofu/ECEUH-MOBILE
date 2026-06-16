import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/courses.dart';
import '../models/course.dart';
import '../motion.dart';
import '../theme.dart';
import '../widgets/app_promo_banner.dart';
import '../widgets/faculty_ledger.dart';
import '../widgets/search_field.dart';

({int ready, int total}) _moduleProgress(Course c) {
  var ready = 0;
  if (c.hub != null) ready++;
  if (c.sections?.files != null) ready++;
  if (c.sections?.links != null) ready++;
  if (c.sections?.topics != null) ready++;
  return (ready: ready, total: 4);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _a;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Motion.enter)..forward();
    _a = List.generate(7, (i) => Motion.stagger(_ctrl, i));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final textTheme = Theme.of(context).textTheme;
    final activeCourse = liveCourses.first;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          FadeSlide(
            animation: _a[0],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppPromoBanner(),
                Text('UNIVERSITY OF HOUSTON · ECE', style: textTheme.labelSmall),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: textTheme.displayMedium,
                    children: [
                      const TextSpan(text: 'Master your '),
                      TextSpan(text: 'ECE', style: TextStyle(color: t.accent, fontStyle: FontStyle.italic)),
                      const TextSpan(text: ' coursework.'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'A living record of homework walkthroughs, lab notes, and faculty ratings — built in real time each semester at the University of Houston.',
                  style: TextStyle(color: t.textSoft, fontSize: 14, height: 1.55),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FadeSlide(animation: _a[1], child: const SearchField()),
          const SizedBox(height: 24),
          FadeSlide(animation: _a[2], child: _ActiveCourseCard(course: activeCourse)),
          const SizedBox(height: 16),
          FadeSlide(animation: _a[3], child: const _FacultyCtaCard()),
          const SizedBox(height: 28),
          FadeSlide(
            animation: _a[4],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your Library', style: textTheme.displaySmall),
                GestureDetector(
                  onTap: () => context.push('/archives'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('VIEW ALL', style: TextStyle(fontFamily: t.sans, color: t.accent, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 14, color: t.accent),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FadeSlide(
            animation: _a[5],
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: liveCourses.length,
                itemBuilder: (context, i) => Padding(
                  padding: EdgeInsets.only(right: i == liveCourses.length - 1 ? 0 : 16),
                  child: _LibraryCard(course: liveCourses[i]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          FadeSlide(animation: _a[6], child: const FacultyLedger()),
        ],
      ),
    );
  }
}

class _ActiveCourseCard extends StatefulWidget {
  const _ActiveCourseCard({required this.course});
  final Course course;

  @override
  State<_ActiveCourseCard> createState() => _ActiveCourseCardState();
}

class _ActiveCourseCardState extends State<_ActiveCourseCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final progress = _moduleProgress(widget.course);
    final pct = (progress.ready / progress.total * 100).round();

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: Motion.press,
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onHighlightChanged: (v) => setState(() => _pressed = v),
          onTap: () => context.push('/archives/course/${widget.course.slug}'),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: t.overlay,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: t.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: t.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text('ACTIVE COURSE',
                              style: TextStyle(fontFamily: t.sans, color: t.accent, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                          ),
                          const SizedBox(height: 12),
                          Text(widget.course.hub?.title ?? widget.course.title,
                            style: TextStyle(fontFamily: t.serif, fontSize: 24, fontWeight: FontWeight.w600, color: t.text, height: 1.2)),
                          const SizedBox(height: 4),
                          Text('${widget.course.code} · ${widget.course.desc}',
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: t.textSoft, fontSize: 13, height: 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: pct),
                      duration: Motion.slow,
                      curve: Motion.std,
                      builder: (_, v, __) => Text('$v%',
                        style: TextStyle(fontFamily: t.serif, fontSize: 28, fontWeight: FontWeight.w700, color: t.accent)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Resources ready', style: TextStyle(fontFamily: t.sans, fontSize: 13, fontWeight: FontWeight.w600, color: t.text)),
                    Text('${progress.ready}/${progress.total} modules', style: TextStyle(fontFamily: t.sans, fontSize: 12, color: t.textMuted)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 8,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: t.border.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress.ready / progress.total),
                        duration: const Duration(milliseconds: 900),
                        curve: Motion.std,
                        builder: (_, v, child) => FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: v,
                          child: child,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [t.goldStart, t.goldEnd]),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _StatBox(label: 'MODULES', value: '${progress.ready}/${progress.total}')),
                    const SizedBox(width: 12),
                    Expanded(child: _StatBox(label: 'UNITS', value: '${widget.course.units}')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.card.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontFamily: t.sans, color: t.accent, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontFamily: t.serif, fontSize: 18, fontWeight: FontWeight.w600, color: t.text)),
        ],
      ),
    );
  }
}

class _FacultyCtaCard extends StatefulWidget {
  const _FacultyCtaCard();

  @override
  State<_FacultyCtaCard> createState() => _FacultyCtaCardState();
}

class _FacultyCtaCardState extends State<_FacultyCtaCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final scheme = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: Motion.press,
      curve: Curves.easeOut,
      child: Material(
        color: scheme.inverseSurface,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onHighlightChanged: (v) => setState(() => _pressed = v),
          onTap: () => context.push('/faculty'),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Icon(Icons.groups_outlined, color: scheme.onInverseSurface),
                ),
                const SizedBox(height: 16),
                Text('Faculty Directory',
                  style: TextStyle(fontFamily: t.serif, fontSize: 20, fontWeight: FontWeight.w600, color: scheme.onInverseSurface)),
                const SizedBox(height: 6),
                Text('Browse ratings, difficulty, and reviews from real ECE students.',
                  style: TextStyle(color: scheme.onInverseSurface.withValues(alpha: 0.7), fontSize: 13, height: 1.5)),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.only(top: 14),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1)))),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: t.goldStart, size: 18),
                      const SizedBox(width: 8),
                      Text('VIEW ALL PROFESSORS',
                        style: TextStyle(fontFamily: t.sans, color: scheme.onInverseSurface, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                    ],
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

class _LibraryCard extends StatefulWidget {
  const _LibraryCard({required this.course});
  final Course course;

  @override
  State<_LibraryCard> createState() => _LibraryCardState();
}

class _LibraryCardState extends State<_LibraryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final hue = (widget.course.slug.hashCode % 360).toDouble();

    return AnimatedScale(
      scale: _pressed ? 0.95 : 1.0,
      duration: Motion.press,
      curve: Curves.easeOut,
      child: SizedBox(
        width: 150,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onHighlightChanged: (v) => setState(() => _pressed = v),
            onTap: () => context.push('/archives/course/${widget.course.slug}'),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (widget.course.art.startsWith('http'))
                  Image.network(widget.course.art, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _CoverGradient(hue: hue))
                else
                  _CoverGradient(hue: hue),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
                        stops: const [0.4, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12, right: 12, bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: t.accent, borderRadius: BorderRadius.circular(999)),
                        child: Text(widget.course.code,
                          style: TextStyle(fontFamily: t.mono, color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1)),
                      ),
                      const SizedBox(height: 6),
                      Text(widget.course.displayArchiveTitle,
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: t.serif, color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600, height: 1.2)),
                    ],
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

class _CoverGradient extends StatelessWidget {
  const _CoverGradient({required this.hue});
  final double hue;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [
            HSLColor.fromAHSL(1, hue, 0.45, 0.42).toColor(),
            HSLColor.fromAHSL(1, (hue + 40) % 360, 0.55, 0.20).toColor(),
          ],
        ),
      ),
      child: Center(child: Icon(Icons.bolt, size: 40, color: Colors.white.withValues(alpha: 0.35))),
    );
  }
}
