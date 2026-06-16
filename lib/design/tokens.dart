import 'package:flutter/material.dart';

/// Spacing scale — 8px base unit (matches the design system YAML `spacing.unit: 8px`).
/// Use these instead of hardcoded EdgeInsets / SizedBox values so the rhythm
/// stays consistent across screens.
abstract final class Spacing {
  static const double s1 = 8;
  static const double s2 = 16;
  static const double s3 = 24;
  static const double s4 = 32;
  static const double s5 = 40;
  static const double s6 = 48;
}

/// Corner-radius scale — matches the design system YAML `rounded` block.
/// `pill` is the full-pill geometry used for buttons, inputs, and tags.
abstract final class Radii {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double pill = 999;
}

/// Backdrop-blur sigma tiers for glassmorphic surfaces.
/// Tuned to the design system's "12–20px backdrop blur" guidance.
abstract final class Blur {
  static const double light = 12;
  static const double medium = 16;
  static const double heavy = 20;
}

/// Glass-pane border opacities — 10% white in light mode, 5% in dark mode.
abstract final class GlassBorder {
  static const double lightOpacity = 0.55;
  static const double darkOpacity = 0.06;
}

/// "Long and soft" ambient shadows per the elevation guidance.
/// Light mode uses neutral black; dark mode tints with Deep Navy for tonal
/// depth rather than harsh black.
enum AppElevation {
  flat,
  soft,
  lifted;

  List<BoxShadow> shadows(BuildContext ctx) {
    final dark = Theme.of(ctx).brightness == Brightness.dark;
    switch (this) {
      case AppElevation.flat:
        return const [];
      case AppElevation.soft:
        return [
          BoxShadow(
            color: dark
                ? const Color(0xFF0A192F).withValues(alpha: 0.40)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ];
      case AppElevation.lifted:
        return [
          BoxShadow(
            color: dark
                ? const Color(0xFF0A192F).withValues(alpha: 0.55)
                : Colors.black.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ];
    }
  }
}
