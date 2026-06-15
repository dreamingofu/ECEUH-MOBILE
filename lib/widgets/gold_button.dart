import 'package:flutter/material.dart';

import '../theme.dart';

/// Full-width pill button filled with the Kinetic Luxe gold gradient.
/// Shows a spinner in place of [label] while [loading] is true.
class GoldButton extends StatelessWidget {
  const GoldButton({super.key, required this.label, required this.onTap, this.loading = false});

  final String label;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [t.goldStart, t.goldEnd]),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: loading ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: loading
                  ? SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: scheme.onPrimary),
                    )
                  : Text(label,
                      style: TextStyle(fontFamily: t.serif, color: scheme.onPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}
