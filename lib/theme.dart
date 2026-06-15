import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Kinetic Luxe" design system — Sora typography, metallic-gold accents,
/// pill shapes and glassmorphic surfaces. Light = "Crisp Gallery",
/// dark = "Deep Midnight".
class EceuhTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF735C00),
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF735C00),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFD4AF37),
      onPrimaryContainer: const Color(0xFF554300),
      secondary: const Color(0xFF515F78),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFD2E0FE),
      onSecondaryContainer: const Color(0xFF55637D),
      tertiary: const Color(0xFF415BA4),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFF97B0FF),
      onTertiaryContainer: const Color(0xFF254188),
      error: const Color(0xFFBA1A1A),
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF93000A),
      surface: const Color(0xFFFFF8F0),
      onSurface: const Color(0xFF1F1B13),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFFBF3E5),
      surfaceContainer: const Color(0xFFF5EDDF),
      surfaceContainerHigh: const Color(0xFFEFE7DA),
      surfaceContainerHighest: const Color(0xFFEAE1D4),
      onSurfaceVariant: const Color(0xFF4D4635),
      outline: const Color(0xFF7F7663),
      outlineVariant: const Color(0xFFD0C5AF),
      inverseSurface: const Color(0xFF343027),
      onInverseSurface: const Color(0xFFF8F0E2),
      inversePrimary: const Color(0xFFE9C349),
      surfaceTint: const Color(0xFF735C00),
    );

    const extras = EceuhExtras(
      accent: Color(0xFF735C00),
      accentDeep: Color(0xFF554300),
      card: Color(0xFFFFFFFF),
      overlay: Color(0x80FFFFFF),
      text: Color(0xFF1F1B13),
      textSoft: Color(0xFF4D4635),
      textMuted: Color(0xFF7F7663),
      textDim: Color(0xFFA89E89),
      border: Color(0xFFD0C5AF),
      goldStart: Color(0xFFD4AF37),
      goldEnd: Color(0xFF735C00),
      serif: 'Sora',
      sans: 'Sora',
      mono: 'Sora',
    );

    return _build(scheme, extras);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFE9C349),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFFE9C349),
      onPrimary: const Color(0xFF3A2F00),
      primaryContainer: const Color(0xFF574500),
      onPrimaryContainer: const Color(0xFFFFE088),
      secondary: const Color(0xFFB9C7E4),
      onSecondary: const Color(0xFF243756),
      secondaryContainer: const Color(0xFF39475F),
      onSecondaryContainer: const Color(0xFFD6E3FF),
      tertiary: const Color(0xFFB4C5FF),
      onTertiary: const Color(0xFF1B2B5E),
      tertiaryContainer: const Color(0xFF27438A),
      onTertiaryContainer: const Color(0xFFDBE1FF),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: const Color(0xFF0A192F),
      onSurface: const Color(0xFFF8F0E2),
      surfaceContainerLowest: const Color(0xFF050E1C),
      surfaceContainerLow: const Color(0xFF0F2038),
      surfaceContainer: const Color(0xFF13243D),
      surfaceContainerHigh: const Color(0xFF1E3050),
      surfaceContainerHighest: const Color(0xFF283C63),
      onSurfaceVariant: const Color(0xFFC7C0AE),
      outline: const Color(0xFF948C7A),
      outlineVariant: const Color(0xFF43485A),
      inverseSurface: const Color(0xFFF8F0E2),
      onInverseSurface: const Color(0xFF1F1B13),
      inversePrimary: const Color(0xFF735C00),
      surfaceTint: const Color(0xFFE9C349),
    );

    const extras = EceuhExtras(
      accent: Color(0xFFE9C349),
      accentDeep: Color(0xFFA6862F),
      card: Color(0xFF13243D),
      overlay: Color(0x1AFFFFFF),
      text: Color(0xFFF8F0E2),
      textSoft: Color(0xFFC7C0AE),
      textMuted: Color(0xFF9C9486),
      textDim: Color(0xFF6E6657),
      border: Color(0x1FFFFFFF),
      goldStart: Color(0xFFF1D592),
      goldEnd: Color(0xFFE9C349),
      serif: 'Sora',
      sans: 'Sora',
      mono: 'Sora',
    );

    return _build(scheme, extras);
  }

  static ThemeData _build(ColorScheme scheme, EceuhExtras extras) {
    final sora = GoogleFonts.sora().fontFamily!;
    final brightness = scheme.brightness;
    final text = extras.text;
    final textSoft = extras.textSoft;
    final textMuted = extras.textMuted;
    final textDim = extras.textDim;
    final accent = extras.accent;

    final textTheme = TextTheme(
      displayLarge: TextStyle(fontFamily: sora, fontWeight: FontWeight.w700, fontSize: 48, color: text, letterSpacing: -1, height: 1.1),
      displayMedium: TextStyle(fontFamily: sora, fontWeight: FontWeight.w700, fontSize: 36, color: text, letterSpacing: -0.5, height: 1.15),
      displaySmall: TextStyle(fontFamily: sora, fontWeight: FontWeight.w600, fontSize: 32, color: text, height: 1.2),
      headlineMedium: TextStyle(fontFamily: sora, fontWeight: FontWeight.w600, fontSize: 28, color: text, height: 1.2),
      titleLarge: TextStyle(fontFamily: sora, fontWeight: FontWeight.w600, fontSize: 24, color: text, height: 1.3),
      titleMedium: TextStyle(fontFamily: sora, fontWeight: FontWeight.w600, fontSize: 16, color: text),
      bodyLarge: TextStyle(fontFamily: sora, fontSize: 18, color: textSoft, height: 1.6),
      bodyMedium: TextStyle(fontFamily: sora, fontSize: 16, color: textSoft, height: 1.6),
      bodySmall: TextStyle(fontFamily: sora, fontSize: 12, color: textMuted),
      labelSmall: TextStyle(fontFamily: sora, fontSize: 14, color: accent, letterSpacing: 0.7, fontWeight: FontWeight.w600, height: 1.0),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      fontFamily: sora,
      cardTheme: CardThemeData(
        color: extras.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(color: extras.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xF00A192F)
            : const Color(0xF2FFFFFF),
        indicatorColor: accent.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontFamily: sora, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.4, color: textMuted),
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
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: TextStyle(fontFamily: sora, fontWeight: FontWeight.w700, letterSpacing: 0.4, fontSize: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: TextStyle(fontFamily: sora, fontWeight: FontWeight.w700, letterSpacing: 0.4, fontSize: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: extras.overlay,
        hintStyle: TextStyle(color: textDim, fontFamily: sora),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: extras.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: extras.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[extras],
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
    required this.goldStart,
    required this.goldEnd,
    required this.serif,
    required this.sans,
    required this.mono,
  });

  final Color accent, accentDeep, card, overlay, text, textSoft, textMuted, textDim, border, goldStart, goldEnd;
  final String serif, sans, mono;

  static EceuhExtras of(BuildContext c) => Theme.of(c).extension<EceuhExtras>()!;

  /// Shared label style for form-field captions ("Institutional Email", etc.).
  TextStyle get fieldLabel =>
      TextStyle(fontFamily: sans, color: text, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.7);

  @override
  EceuhExtras copyWith({
    Color? accent, Color? accentDeep, Color? card, Color? overlay, Color? text,
    Color? textSoft, Color? textMuted, Color? textDim, Color? border,
    Color? goldStart, Color? goldEnd,
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
        goldStart: goldStart ?? this.goldStart,
        goldEnd: goldEnd ?? this.goldEnd,
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
      goldStart: Color.lerp(goldStart, other.goldStart, t)!,
      goldEnd: Color.lerp(goldEnd, other.goldEnd, t)!,
      serif: serif, sans: sans, mono: mono,
    );
  }
}
