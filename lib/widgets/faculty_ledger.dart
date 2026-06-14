import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/professors.dart';
import '../models/professor.dart';
import '../theme.dart';

/// Animated rotating spotlight of randomly picked rated professors.
/// 1:1 spirit-port of the Faculty Ledger card on the homepage.
class FacultyLedger extends StatefulWidget {
  const FacultyLedger({super.key});

  @override
  State<FacultyLedger> createState() => _FacultyLedgerState();
}

class _FacultyLedgerState extends State<FacultyLedger> with SingleTickerProviderStateMixin {
  static const Duration _kCycleDuration = Duration(milliseconds: 4800);

  late final List<_Spotlight> _pool;
  late final AnimationController _ringSpinController;
  Timer? _timer;
  int _index = 0;
  double _displayedScore = 0;

  @override
  void initState() {
    super.initState();
    _pool = _buildPool()..shuffle();
    _ringSpinController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
    if (_pool.isNotEmpty) {
      _displayedScore = _pool[0].overall;
      _timer = Timer.periodic(_kCycleDuration, (_) => _advance());
    }
  }

  @override
  void dispose() {
    _ringSpinController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _advance() {
    setState(() {
      _index = (_index + 1) % _pool.length;
      _displayedScore = _pool[_index].overall;
    });
  }

  List<_Spotlight> _buildPool() {
    final seen = <String>{};
    final list = <_Spotlight>[];
    for (final course in kProfessorCourses) {
      for (final p in course.profs) {
        if (!p.hasRating) continue;
        final key = '${p.name}|${course.id}';
        if (seen.contains(key)) continue;
        seen.add(key);
        list.add(_Spotlight(
          prof: p, code: course.code, courseTitle: _abbrev(course.id, course.title),
        ));
      }
    }
    return list;
  }

  static String _abbrev(String slug, String fallback) => switch (slug) {
        'dld' => 'DLD',
        'circuits2' => 'Circuits 2',
        'cprog' => 'C Programming',
        'engi1100' => 'Intro Engr',
        'engi1331' => 'Computing',
        'engi2304' => 'Tech Comm',
        'ece2201' => 'Circuits 1',
        'ece2100' => 'Circuits Lab',
        'inde2333' => 'Engr Stats',
        'ece3155' => 'Electronics Lab',
        'ece3355' => 'Electronics',
        'ece3337' => 'Signals & Sys',
        'ece3317' => 'EM Waves',
        'ece3436' => 'Microprocessors',
        'ece3340' => 'Numerical',
        _ => fallback,
      };

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    if (_pool.isEmpty) {
      return const SizedBox.shrink();
    }
    final spot = _pool[_index];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Faculty Ledger', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              Text('VIEW ALL →',
                style: TextStyle(color: t.accent, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(anim),
                child: child,
              ),
            ),
            child: _Spotlight.build(
              key: ValueKey(spot.prof.name + spot.code),
              ctx: context,
              spotlight: spot,
              ringController: _ringSpinController,
              displayedScore: spot.overall,
            ),
          ),
        ],
      ),
    );
  }
}

class _Spotlight {
  const _Spotlight({required this.prof, required this.code, required this.courseTitle});
  final Professor prof;
  final String code;
  final String courseTitle;
  double get overall => prof.overall ?? 0;

  static Widget build({
    required Key key,
    required BuildContext ctx,
    required _Spotlight spotlight,
    required AnimationController ringController,
    required double displayedScore,
  }) {
    final t = EceuhExtras.of(ctx);
    final prof = spotlight.prof;
    final hue = _hashHue(prof.name);
    final gradStart = HSLColor.fromAHSL(1, hue, 0.38, 0.38).toColor();
    final gradEnd = HSLColor.fromAHSL(1, (hue + 32) % 360, 0.48, 0.18).toColor();
    final stars = (prof.overall ?? 0).round();
    return Row(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 88, height: 88,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: ringController,
                builder: (_, __) => Transform.rotate(
                  angle: ringController.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size(88, 88),
                    painter: _RingPainter(color: t.accent),
                  ),
                ),
              ),
              Container(
                width: 70, height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [gradStart, gradEnd],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(prof.initials,
                  style: TextStyle(fontFamily: t.serif, fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(spotlight.code, style: TextStyle(fontFamily: t.mono, fontWeight: FontWeight.w700, fontSize: 10, color: t.accent, letterSpacing: 1.4)),
              const SizedBox(height: 2),
              Text(prof.title,
                style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 20, color: t.text, letterSpacing: -0.4, height: 1.15)),
              const SizedBox(height: 4),
              Text(spotlight.courseTitle.toUpperCase(),
                style: TextStyle(color: t.textMuted, fontSize: 11, letterSpacing: 0.6)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ...List.generate(5, (i) => Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Icon(Icons.star, size: 12, color: i < stars ? t.accent : t.border),
                  )),
                  const SizedBox(width: 10),
                  Text(displayedScore.toStringAsFixed(1),
                    style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 22, color: t.accent)),
                  Text(' / 5.0', style: TextStyle(color: t.textDim, fontSize: 10, letterSpacing: 1)),
                ],
              ),
              if (prof.wouldTake != null) ...[
                const SizedBox(height: 4),
                Text('${prof.wouldTake}% WOULD TAKE AGAIN',
                  style: TextStyle(color: t.textDim, fontSize: 10, letterSpacing: 0.8)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static double _hashHue(String s) {
    int h = 0;
    for (final code in s.codeUnits) { h = (h * 31 + code) & 0x7fffffff; }
    return (h % 360).toDouble();
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [color, color.withValues(alpha: 0), color.withValues(alpha: 0), color],
        stops: const [0, 0.30, 0.70, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, r - 2, paint);
  }
  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => oldDelegate.color != color;
}
