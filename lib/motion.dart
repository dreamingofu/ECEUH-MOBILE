import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  /// Material 3 Expressive "satisfying" spring — used for result reveals,
  /// snap-back overshoots, and any state change that benefits from weight.
  static const Curve spring = Cubic(0.34, 1.56, 0.64, 1.0);

  /// Tight elastic curve for short, snappy emphasis (icon swaps, badge pops).
  static const Curve elastic = Cubic(0.16, 1.0, 0.30, 1.0);

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

/// Standard press feedback — momentary scale-down on highlight. Replaces the
/// duplicated `AnimatedScale + InkWell.onHighlightChanged` pattern used by
/// cards across the app.
class PressScale extends StatefulWidget {
  const PressScale({
    super.key,
    required this.child,
    required this.onTap,
    this.scale = 0.97,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback onTap;
  final double scale;
  final BorderRadius? borderRadius;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(32);
    return AnimatedScale(
      scale: _pressed ? widget.scale : 1.0,
      duration: Motion.press,
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: widget.onTap,
          onHighlightChanged: (v) => setState(() => _pressed = v),
          child: widget.child,
        ),
      ),
    );
  }
}

/// `go_router` Page builders that wrap a screen in a Kinetic-Luxe transition.
/// Foundation only — wire them into the router in a later refactor pass.
abstract final class Transitions {
  /// Fade-through — content fades out, replaced content fades in. Use for
  /// peer-level navigation where neither screen is "below" the other.
  static Page<T> fadeThrough<T>({required LocalKey key, required Widget child}) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: Motion.mid,
      reverseTransitionDuration: Motion.fast,
      transitionsBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Motion.std),
        child: child,
      ),
    );
  }

  /// Horizontal slide + fade — used when navigating into a deeper view.
  /// Reverse direction (e.g., a Back action) flips the slide axis.
  static Page<T> sharedAxis<T>({
    required LocalKey key,
    required Widget child,
    bool reverse = false,
  }) {
    final dx = reverse ? -0.08 : 0.08;
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: Motion.mid,
      reverseTransitionDuration: Motion.fast,
      transitionsBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Motion.std),
        child: SlideTransition(
          position: Tween(begin: Offset(dx, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: anim, curve: Motion.std),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Thin wrapper around `Hero` that keeps the same widget visible during
/// flight, preventing the system's default cross-fade from flickering the
/// Kinetic Luxe surface treatment.
class HeroLeash extends StatelessWidget {
  const HeroLeash({super.key, required this.tag, required this.child});
  final Object tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (_, __, ___, ____, _____) => child,
      child: child,
    );
  }
}
