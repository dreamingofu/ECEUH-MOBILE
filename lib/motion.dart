import 'package:flutter/material.dart';

/// Centralized motion constants for the ECEUH Kinetic Luxe design system.
abstract final class Motion {
  static const Duration press = Duration(milliseconds: 100);
  static const Duration fast  = Duration(milliseconds: 200);
  static const Duration mid   = Duration(milliseconds: 300);
  static const Duration slow  = Duration(milliseconds: 500);
  static const Duration enter = Duration(milliseconds: 800);

  static const Curve std   = Curves.easeOutCubic;
  static const Curve decel = Curves.easeOutQuart;
  static const Curve accel = Curves.easeInCubic;

  /// [CurvedAnimation] for staggered screen entrance.
  /// Items are offset ~72ms apart; all complete by [enter].
  static CurvedAnimation stagger(Animation<double> parent, int index) =>
      CurvedAnimation(
        parent: parent,
        curve: Interval(
          (index * 0.09).clamp(0.0, 0.45),
          ((index * 0.09) + 0.55).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      );
}

/// Fade in + subtle upward drift — the standard entrance animation.
/// Pair with [Motion.stagger] for sequenced section reveals.
class FadeSlide extends StatelessWidget {
  const FadeSlide({super.key, required this.animation, required this.child});
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: animation,
    child: SlideTransition(
      position: Tween(begin: const Offset(0, 0.035), end: Offset.zero)
          .animate(animation),
      child: child,
    ),
  );
}
