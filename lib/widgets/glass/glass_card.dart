import 'dart:ui';

import 'package:flutter/material.dart';

import '../../design/tokens.dart';
import '../../theme.dart';

/// Glassmorphic surface — translucent fill + backdrop blur + 1px white-alpha
/// border. Default radius is [Radii.xl] (32px) per the system's card rule.
///
/// In dark mode a subtle top-edge gradient suggests an overhead light source,
/// matching the design system's "Deep Midnight" card guidance.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Spacing.s3),
    this.radius = Radii.xl,
    this.blur = Blur.light,
    this.elevation = AppElevation.flat,
    this.tinted = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;
  final AppElevation elevation;

  /// When true the fill picks up a faint accent tint (used for highlighted
  /// cards like an active course or a selected option).
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = Colors.white.withValues(
      alpha: dark ? GlassBorder.darkOpacity : GlassBorder.lightOpacity,
    );
    final fill = tinted
        ? t.accent.withValues(alpha: dark ? 0.10 : 0.08)
        : t.overlay;
    final br = BorderRadius.circular(radius);

    final pane = ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: dark ? null : fill,
            gradient: dark
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.06),
                      fill,
                    ],
                  )
                : null,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: br,
          ),
          child: child,
        ),
      ),
    );

    if (elevation == AppElevation.flat) return pane;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: br,
        boxShadow: elevation.shadows(context),
      ),
      child: pane,
    );
  }
}
