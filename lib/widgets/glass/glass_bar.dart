import 'dart:ui';

import 'package:flutter/material.dart';

import '../../design/tokens.dart';
import '../../theme.dart';

/// High-blur sticky bar surface for the top app bar or bottom navigation.
/// The design system specifies persistent navigation with a 20px backdrop
/// blur so content scrolls beautifully underneath.
class GlassBar extends StatelessWidget {
  const GlassBar({
    super.key,
    required this.child,
    this.blur = Blur.heavy,
    this.bottomEdge = false,
  });

  final Widget child;
  final double blur;

  /// When true the bar tints its bottom edge with a subtle hairline divider
  /// (used by top app bars to separate from scrolling content).
  final bool bottomEdge;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = dark
        ? const Color(0xFF0A192F).withValues(alpha: 0.72)
        : Colors.white.withValues(alpha: 0.72);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fill,
            border: bottomEdge
                ? Border(bottom: BorderSide(color: t.border, width: 0.5))
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
