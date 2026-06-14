import 'package:flutter/material.dart';

import '../theme.dart';

/// Standard hero used at the top of most screens. Mirrors the .hero-card
/// pattern from course-pages.css.
class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.kicker,
    required this.title,
    required this.desc,
    this.code,
    this.trailing,
  });

  final String kicker;
  final String title;
  final String desc;
  final String? code;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        color: t.overlay,
        borderRadius: BorderRadius.circular(22),
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
                    Text(
                      kicker.toUpperCase(),
                      style: TextStyle(fontFamily: t.mono, fontSize: 11, color: t.accent, letterSpacing: 1.4, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(title,
                      style: TextStyle(
                        fontFamily: t.serif, fontWeight: FontWeight.w700,
                        fontSize: 30, height: 1.05, letterSpacing: -0.6, color: t.text,
                      ),
                    ),
                  ],
                ),
              ),
              if (code != null)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: t.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(code!, style: TextStyle(fontFamily: t.mono, color: t.accent, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 1.2)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(desc, style: TextStyle(color: t.textSoft, fontSize: 14, height: 1.55)),
          if (trailing != null) ...[const SizedBox(height: 14), trailing!],
        ],
      ),
    );
  }
}
