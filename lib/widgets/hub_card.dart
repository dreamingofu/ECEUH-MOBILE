import 'package:flutter/material.dart';

import '../motion.dart';
import '../theme.dart';

class HubCard extends StatefulWidget {
  const HubCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.tags = const [],
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final List<String> tags;

  @override
  State<HubCard> createState() => _HubCardState();
}

class _HubCardState extends State<HubCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: Motion.press,
      curve: Curves.easeOut,
      child: Material(
        color: t.card,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onHighlightChanged: (v) => setState(() => _pressed = v),
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: t.border),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: t.accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: t.accent),
                ),
                const SizedBox(height: 14),
                Text(widget.title, style: TextStyle(fontFamily: t.serif, fontSize: 20, fontWeight: FontWeight.w700, color: t.text)),
                const SizedBox(height: 8),
                Text(widget.subtitle, style: TextStyle(color: t.textSoft, fontSize: 13, height: 1.55)),
                if (widget.tags.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6, runSpacing: 6,
                    children: widget.tags.map((tag) => _Pill(label: tag)).toList(),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Open', style: TextStyle(color: t.textDim, fontSize: 13)),
                    Text('→', style: TextStyle(color: t.accent, fontFamily: t.mono, fontWeight: FontWeight.w700)),
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

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: t.overlay,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: t.border),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: t.textMuted)),
    );
  }
}
