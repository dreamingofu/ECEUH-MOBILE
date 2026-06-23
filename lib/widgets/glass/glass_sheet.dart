import 'dart:ui';

import 'package:flutter/material.dart';

import '../../design/tokens.dart';

/// Backdrop surface for modal bottom sheets. Top-edge is rounded to [Radii.xl];
/// the bottom extends to the screen edge so the sheet anchors cleanly to it.
/// Blur defaults to [Blur.heavy] to obscure underlying content while keeping
/// it perceptible — the "glass pane" effect from the design system.
class GlassSheet extends StatelessWidget {
  const GlassSheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(Spacing.s3, Spacing.s2, Spacing.s3, Spacing.s4),
    this.blur = Blur.heavy,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = Colors.white.withValues(
      alpha: dark ? GlassBorder.darkOpacity : GlassBorder.lightOpacity,
    );
    final fill = dark
        ? const Color(0xFF0A192F).withValues(alpha: 0.85)
        : Colors.white.withValues(alpha: 0.85);
    const topRadius = Radius.circular(Radii.xl);
    const sheetShape = BorderRadius.only(topLeft: topRadius, topRight: topRadius);

    return ClipRRect(
      borderRadius: sheetShape,
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
            border: Border(
              top: BorderSide(color: borderColor, width: 1),
              left: BorderSide(color: borderColor, width: 1),
              right: BorderSide(color: borderColor, width: 1),
            ),
            borderRadius: sheetShape,
          ),
          child: SafeArea(top: false, child: child),
        ),
      ),
    );
  }
}

