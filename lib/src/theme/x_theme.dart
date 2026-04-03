import 'package:flutter/material.dart';

/// Theme factory for Material Design 3.
///
/// Provides pre-configured light and dark themes compatible with Flutter 3.x.
/// Use [XTheme.light()] or [XTheme.dark()] for Material3 theme data.
///
/// Example:
/// ```dart
/// MaterialApp(
///   theme: XTheme.light(seedColor: Colors.blue),
///   darkTheme: XTheme.dark(seedColor: Colors.blue),
///   themeMode: ThemeMode.system,
/// )
/// ```
class XTheme {
  /// Creates a light Material 3 theme
  static ThemeData light({
    Color seedColor = Colors.blue,
    bool useMaterial3 = true,
  }) {
    return ThemeData(
      useMaterial3: useMaterial3,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seedColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: seedColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: BorderSide(color: seedColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: seedColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Creates a dark Material 3 theme
  static ThemeData dark({
    Color seedColor = Colors.blue,
    bool useMaterial3 = true,
  }) {
    return ThemeData(
      useMaterial3: useMaterial3,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seedColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: seedColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: BorderSide(color: seedColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade900,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: seedColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Creates a Nord-inspired light Material 3 theme.
  static ThemeData nordLight({
    bool useMaterial3 = true,
  }) {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: XNordPalette.nord10,
      onPrimary: XNordPalette.nord6,
      primaryContainer: XNordPalette.nord7,
      onPrimaryContainer: XNordPalette.nord0,
      secondary: XNordPalette.nord9,
      onSecondary: XNordPalette.nord0,
      secondaryContainer: XNordPalette.nord8,
      onSecondaryContainer: XNordPalette.nord0,
      tertiary: XNordPalette.nord15,
      onTertiary: XNordPalette.nord6,
      tertiaryContainer: XNordPalette.nord14,
      onTertiaryContainer: XNordPalette.nord0,
      error: XNordPalette.nord11,
      onError: XNordPalette.nord6,
      errorContainer: XNordPalette.nord12,
      onErrorContainer: XNordPalette.nord0,
      surface: XNordPalette.nord6,
      onSurface: XNordPalette.nord0,
      onSurfaceVariant: XNordPalette.nord3,
      outline: XNordPalette.nord3,
      outlineVariant: XNordPalette.nord4,
      shadow: XNordPalette.nord0,
      scrim: XNordPalette.nord0,
      inverseSurface: XNordPalette.nord1,
      onInverseSurface: XNordPalette.nord5,
      inversePrimary: XNordPalette.nord8,
      surfaceTint: XNordPalette.nord10,
    );

    return _buildNordTheme(
      colorScheme: scheme,
      useMaterial3: useMaterial3,
      isDark: false,
    );
  }

  /// Creates a Nord-inspired dark Material 3 theme.
  static ThemeData nordDark({
    bool useMaterial3 = true,
  }) {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: XNordPalette.nord8,
      onPrimary: XNordPalette.nord0,
      primaryContainer: XNordPalette.nord9,
      onPrimaryContainer: XNordPalette.nord6,
      secondary: XNordPalette.nord7,
      onSecondary: XNordPalette.nord0,
      secondaryContainer: XNordPalette.nord10,
      onSecondaryContainer: XNordPalette.nord6,
      tertiary: XNordPalette.nord15,
      onTertiary: XNordPalette.nord0,
      tertiaryContainer: XNordPalette.nord14,
      onTertiaryContainer: XNordPalette.nord6,
      error: XNordPalette.nord11,
      onError: XNordPalette.nord6,
      errorContainer: XNordPalette.nord12,
      onErrorContainer: XNordPalette.nord0,
      surface: XNordPalette.nord0,
      onSurface: XNordPalette.nord6,
      onSurfaceVariant: XNordPalette.nord4,
      outline: XNordPalette.nord3,
      outlineVariant: XNordPalette.nord2,
      shadow: XNordPalette.nord0,
      scrim: XNordPalette.nord0,
      inverseSurface: XNordPalette.nord6,
      onInverseSurface: XNordPalette.nord1,
      inversePrimary: XNordPalette.nord10,
      surfaceTint: XNordPalette.nord8,
    );

    return _buildNordTheme(
      colorScheme: scheme,
      useMaterial3: useMaterial3,
      isDark: true,
    );
  }

  static ThemeData _buildNordTheme({
    required ColorScheme colorScheme,
    required bool useMaterial3,
    required bool isDark,
  }) {
    final base = ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: colorScheme,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: isDark ? XNordPalette.nord1 : XNordPalette.nord5,
        foregroundColor: colorScheme.onSurface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? XNordPalette.nord1 : XNordPalette.nord5,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: isDark ? XNordPalette.nord1 : XNordPalette.nord6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Official Nord palette with 16 strictly defined colors.
abstract class XNordPalette {
  // Polar Night
  static const Color nord0 = Color(0xFF2E3440);
  static const Color nord1 = Color(0xFF3B4252);
  static const Color nord2 = Color(0xFF434C5E);
  static const Color nord3 = Color(0xFF4C566A);

  // Snow Storm
  static const Color nord4 = Color(0xFFD8DEE9);
  static const Color nord5 = Color(0xFFE5E9F0);
  static const Color nord6 = Color(0xFFECEFF4);

  // Frost
  static const Color nord7 = Color(0xFF8FBCBB);
  static const Color nord8 = Color(0xFF88C0D0);
  static const Color nord9 = Color(0xFF81A1C1);
  static const Color nord10 = Color(0xFF5E81AC);

  // Aurora
  static const Color nord11 = Color(0xFFBF616A);
  static const Color nord12 = Color(0xFFD08770);
  static const Color nord13 = Color(0xFFEBCB8B);
  static const Color nord14 = Color(0xFFA3BE8C);
  static const Color nord15 = Color(0xFFB48EAD);

  static const List<Color> values = [
    nord0,
    nord1,
    nord2,
    nord3,
    nord4,
    nord5,
    nord6,
    nord7,
    nord8,
    nord9,
    nord10,
    nord11,
    nord12,
    nord13,
    nord14,
    nord15,
  ];
}

/// Color palette generator from seed colors.
///
/// Creates a complete color palette from a single seed color.
/// Useful for generating consistent colors throughout your app.
///
/// Example:
/// ```dart
/// final palette = XColorPalette.fromSeed(Colors.blue);
/// Container(color: palette.accent)
/// ```
class XColorPalette {
  /// Primary color
  final Color primary;

  /// Secondary color
  final Color secondary;

  /// Tertiary color
  final Color tertiary;

  /// Accent color
  final Color accent;

  /// Surface color
  final Color surface;

  /// Error color
  final Color error;

  /// Success color
  final Color success;

  /// Warning color
  final Color warning;

  /// Info color
  final Color info;

  XColorPalette({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.accent,
    required this.surface,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
  });

  /// Creates a palette from a seed color
  factory XColorPalette.fromSeed(Color seedColor) {
    final scheme = ColorScheme.fromSeed(seedColor: seedColor);

    return XColorPalette(
      primary: scheme.primary,
      secondary: scheme.secondary,
      tertiary: scheme.tertiary,
      accent: seedColor,
      surface: scheme.surface,
      error: scheme.error,
      success: Colors.green,
      warning: Colors.orange,
      info: Colors.blue,
    );
  }

  /// Creates a palette with custom colors
  factory XColorPalette.custom({
    Color primary = Colors.blue,
    Color secondary = Colors.teal,
    Color tertiary = Colors.purple,
    Color accent = Colors.amber,
    Color surface = Colors.white,
    Color error = Colors.red,
    Color success = Colors.green,
    Color warning = Colors.orange,
    Color info = Colors.lightBlue,
  }) {
    return XColorPalette(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      accent: accent,
      surface: surface,
      error: error,
      success: success,
      warning: warning,
      info: info,
    );
  }

  /// Gets lighter shade of a color
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lighter = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lighter.toColor();
  }

  /// Gets darker shade of a color
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darker.toColor();
  }

  /// Converts color to hex string
  static String toHex(Color color) {
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  /// Converts hex string to color
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (!hexString.startsWith('#')) buffer.write('#');
    buffer.write(hexString);

    return Color(int.parse(buffer.toString().replaceFirst('#', '0x')));
  }
}
