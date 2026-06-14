import 'package:flutter/material.dart';

/// Palette tokens mirror the website's CSS variables.
class EceuhPalette {
  // Dark
  static const dBg          = Color(0xFF1A1A2E);
  static const dCard        = Color(0xFF261817);
  static const dOverlay     = Color(0x99262A3E);
  static const dActive      = Color(0xFF2A2A3E);
  static const dAccent      = Color(0xFFFF6363);
  static const dAccentDeep  = Color(0xFF67000E);
  static const dText        = Color(0xFFFFFFFF);
  static const dTextSoft    = Color(0xFFCBD5E1);
  static const dTextMuted   = Color(0xFF94A3B8);
  static const dTextDim     = Color(0xFF64748B);
  static const dBorder      = Color(0x14FFFFFF);

  // Light
  static const lBg          = Color(0xFFF4ECEA);
  static const lCard        = Color(0xFFFFF5F3);
  static const lOverlay     = Color(0xB3FFFFFF);
  static const lActive      = Color(0xFFFFE4DF);
  static const lAccent      = Color(0xFFB94A4A);
  static const lAccentDeep  = Color(0xFF67000E);
  static const lText        = Color(0xFF1A1A2E);
  static const lTextSoft    = Color(0xFF334155);
  static const lTextMuted   = Color(0xFF475569);
  static const lTextDim     = Color(0xFF64748B);
  static const lBorder      = Color(0x24262A3E);
}

class EceuhTheme {
  static ThemeData light() => _build(
        brightness: Brightness.light,
        bg: EceuhPalette.lBg,
        card: EceuhPalette.lCard,
        overlay: EceuhPalette.lOverlay,
        accent: EceuhPalette.lAccent,
        accentDeep: EceuhPalette.lAccentDeep,
        text: EceuhPalette.lText,
        textSoft: EceuhPalette.lTextSoft,
        textMuted: EceuhPalette.lTextMuted,
        textDim: EceuhPalette.lTextDim,
        border: EceuhPalette.lBorder,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        bg: EceuhPalette.dBg,
        card: EceuhPalette.dCard,
        overlay: EceuhPalette.dOverlay,
        accent: EceuhPalette.dAccent,
        accentDeep: EceuhPalette.dAccentDeep,
        text: EceuhPalette.dText,
        textSoft: EceuhPalette.dTextSoft,
        textMuted: EceuhPalette.dTextMuted,
        textDim: EceuhPalette.dTextDim,
        border: EceuhPalette.dBorder,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color card,
    required Color overlay,
    required Color accent,
    required Color accentDeep,
    required Color text,
    required Color textSoft,
    required Color textMuted,
    required Color textDim,
    required Color border,
  }) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: Colors.white,
      secondary: accentDeep,
      onSecondary: Colors.white,
      surface: card,
      onSurface: text,
      error: const Color(0xFFEF4444),
      onError: Colors.white,
    );

    final textTheme = TextTheme(
      displayLarge: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w700, fontSize: 48, color: text, letterSpacing: -1.5, height: 1.05),
      displayMedium: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w700, fontSize: 36, color: text, letterSpacing: -0.8),
      displaySmall: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w700, fontSize: 28, color: text, letterSpacing: -0.4),
      headlineMedium: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w700, fontSize: 22, color: text, letterSpacing: -0.3),
      titleLarge: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w700, fontSize: 20, color: text),
      titleMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 15, color: text),
      bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, color: textSoft, height: 1.6),
      bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, color: textSoft, height: 1.55),
      bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12, color: textMuted),
      labelSmall: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: accent, letterSpacing: 1.4, fontWeight: FontWeight.w700),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      textTheme: textTheme,
      fontFamily: 'Inter',
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xD91A1A2E)
            : const Color(0xEDFFF5F3),
        indicatorColor: accent.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.04, color: textMuted),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return IconThemeData(color: accent);
          return IconThemeData(color: textDim);
        }),
        height: 64,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, letterSpacing: 0.4, fontSize: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, letterSpacing: 0.4, fontSize: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: overlay,
        hintStyle: TextStyle(color: textDim, fontFamily: 'Inter'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accent),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        EceuhExtras(
          accent: accent,
          accentDeep: accentDeep,
          card: card,
          overlay: overlay,
          text: text,
          textSoft: textSoft,
          textMuted: textMuted,
          textDim: textDim,
          border: border,
          serif: 'Lora',
          sans: 'Inter',
          mono: 'JetBrainsMono',
        ),
      ],
    );
  }
}

/// Project-specific tokens exposed through Theme.of(context).extension<EceuhExtras>().
@immutable
class EceuhExtras extends ThemeExtension<EceuhExtras> {
  const EceuhExtras({
    required this.accent,
    required this.accentDeep,
    required this.card,
    required this.overlay,
    required this.text,
    required this.textSoft,
    required this.textMuted,
    required this.textDim,
    required this.border,
    required this.serif,
    required this.sans,
    required this.mono,
  });

  final Color accent, accentDeep, card, overlay, text, textSoft, textMuted, textDim, border;
  final String serif, sans, mono;

  static EceuhExtras of(BuildContext c) => Theme.of(c).extension<EceuhExtras>()!;

  @override
  EceuhExtras copyWith({
    Color? accent, Color? accentDeep, Color? card, Color? overlay, Color? text,
    Color? textSoft, Color? textMuted, Color? textDim, Color? border,
    String? serif, String? sans, String? mono,
  }) => EceuhExtras(
        accent: accent ?? this.accent,
        accentDeep: accentDeep ?? this.accentDeep,
        card: card ?? this.card,
        overlay: overlay ?? this.overlay,
        text: text ?? this.text,
        textSoft: textSoft ?? this.textSoft,
        textMuted: textMuted ?? this.textMuted,
        textDim: textDim ?? this.textDim,
        border: border ?? this.border,
        serif: serif ?? this.serif,
        sans: sans ?? this.sans,
        mono: mono ?? this.mono,
      );

  @override
  EceuhExtras lerp(EceuhExtras? other, double t) {
    if (other == null) return this;
    return EceuhExtras(
      accent: Color.lerp(accent, other.accent, t)!,
      accentDeep: Color.lerp(accentDeep, other.accentDeep, t)!,
      card: Color.lerp(card, other.card, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSoft: Color.lerp(textSoft, other.textSoft, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textDim: Color.lerp(textDim, other.textDim, t)!,
      border: Color.lerp(border, other.border, t)!,
      serif: serif, sans: sans, mono: mono,
    );
  }
}
