import 'package:flutter/material.dart';

import '../design/tokens.dart';
import '../motion.dart';
import '../theme.dart';
import 'glass/glass_card.dart';
import 'glass/glass_chip.dart';

class HubCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);

    return PressScale(
      borderRadius: BorderRadius.circular(Radii.lg),
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(Spacing.s2 + 2),
        radius: Radii.lg,
        elevation: AppElevation.soft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: t.accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(Radii.sm + 4),
              ),
              child: Icon(icon, color: t.accent),
            ),
            const SizedBox(height: 14),
            Text(title, style: TextStyle(fontFamily: t.serif, fontSize: 20, fontWeight: FontWeight.w700, color: t.text)),
            const SizedBox(height: Spacing.s1),
            Text(subtitle, style: TextStyle(color: t.textSoft, fontSize: 13, height: 1.55)),
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 6, runSpacing: 6,
                children: tags.map((tag) =>
                  GlassChip(label: tag, variant: GlassChipVariant.neutral),
                ).toList(),
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
    );
  }
}
