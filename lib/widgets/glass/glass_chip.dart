import 'package:flutter/material.dart';

import '../../design/tokens.dart';
import '../../theme.dart';

/// Pill-shaped tag. The `premium` variant is the design system's
/// "Navy background with Gold text" treatment used for high-contrast labels;
/// `accent` is a softer gold-on-overlay variant for inline metadata.
enum GlassChipVariant { premium, accent, neutral }

class GlassChip extends StatelessWidget {
  const GlassChip({
    super.key,
    required this.label,
    this.variant = GlassChipVariant.accent,
    this.icon,
  });

  final String label;
  final GlassChipVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final scheme = Theme.of(context).colorScheme;

    final (bg, fg, border) = switch (variant) {
      GlassChipVariant.premium => (
          scheme.inverseSurface,
          t.accent,
          Colors.transparent,
        ),
      GlassChipVariant.accent => (
          t.accent.withValues(alpha: 0.12),
          t.accent,
          t.accent.withValues(alpha: 0.20),
        ),
      GlassChipVariant.neutral => (
          t.overlay,
          t.textMuted,
          t.border,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: t.mono,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
