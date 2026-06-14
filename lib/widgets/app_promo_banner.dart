import 'package:flutter/material.dart';

import '../theme.dart';

/// Equivalent of the .web-only "Get the Android app" banner from the website.
/// In the Flutter app this slot is dormant by default — flip [show] to true
/// if you ever want to surface an iOS/promo card here.
class AppPromoBanner extends StatelessWidget {
  const AppPromoBanner({super.key, this.show = false});
  final bool show;

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();
    final t = EceuhExtras.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [t.accent.withValues(alpha: 0.10), t.accent.withValues(alpha: 0.04)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [t.accent, t.accentDeep]),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text('E', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w900, fontSize: 22, color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ECEUH is on Android.', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: t.text)),
                Text('Same files, faster, with native share.', style: TextStyle(fontSize: 12, color: t.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
