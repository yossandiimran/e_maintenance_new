import 'package:flutter/material.dart';

@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.pageBackground,
    required this.pageBackgroundAlt,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.brand,
    required this.brandSoft,
    required this.accent,
    required this.success,
    required this.warning,
    required this.danger,
    required this.border,
    required this.borderSoft,
    required this.shadow,
    required this.heroStart,
    required this.heroEnd,
    required this.brandGradient,
    required this.blockColors,
  });

  final Color pageBackground;
  final Color pageBackgroundAlt;
  final Color surface;
  final Color surfaceMuted;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color brand;
  final Color brandSoft;
  final Color accent;
  final Color success;
  final Color warning;
  final Color danger;
  final Color border;
  final Color borderSoft;
  final Color shadow;
  final Color heroStart;
  final Color heroEnd;
  final LinearGradient brandGradient;
  final List<Color> blockColors;

  @override
  AppTokens copyWith({
    Color? pageBackground,
    Color? pageBackgroundAlt,
    Color? surface,
    Color? surfaceMuted,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? brand,
    Color? brandSoft,
    Color? accent,
    Color? success,
    Color? warning,
    Color? danger,
    Color? border,
    Color? borderSoft,
    Color? shadow,
    Color? heroStart,
    Color? heroEnd,
    LinearGradient? brandGradient,
    List<Color>? blockColors,
  }) {
    return AppTokens(
      pageBackground: pageBackground ?? this.pageBackground,
      pageBackgroundAlt: pageBackgroundAlt ?? this.pageBackgroundAlt,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      brand: brand ?? this.brand,
      brandSoft: brandSoft ?? this.brandSoft,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      border: border ?? this.border,
      borderSoft: borderSoft ?? this.borderSoft,
      shadow: shadow ?? this.shadow,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
      brandGradient: brandGradient ?? this.brandGradient,
      blockColors: blockColors ?? this.blockColors,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) {
      return this;
    }

    return AppTokens(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t) ?? pageBackground,
      pageBackgroundAlt: Color.lerp(pageBackgroundAlt, other.pageBackgroundAlt, t) ?? pageBackgroundAlt,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t) ?? surfaceMuted,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t) ?? surfaceElevated,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      brand: Color.lerp(brand, other.brand, t) ?? brand,
      brandSoft: Color.lerp(brandSoft, other.brandSoft, t) ?? brandSoft,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      border: Color.lerp(border, other.border, t) ?? border,
      borderSoft: Color.lerp(borderSoft, other.borderSoft, t) ?? borderSoft,
      shadow: Color.lerp(shadow, other.shadow, t) ?? shadow,
      heroStart: Color.lerp(heroStart, other.heroStart, t) ?? heroStart,
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t) ?? heroEnd,
      brandGradient: t < 0.5 ? brandGradient : other.brandGradient,
      blockColors: t < 0.5 ? blockColors : other.blockColors,
    );
  }
}

class AppTheme {
  const AppTheme._();

  static ThemeData light() => _buildTheme(_lightTokens, Brightness.light);
  static ThemeData dark() => _buildTheme(_darkTokens, Brightness.dark);

  static final AppTokens _lightTokens = AppTokens(
    pageBackground: const Color(0xFFFFFAEB),
    pageBackgroundAlt: const Color(0xFFFFF0C2),
    surface: const Color(0xFFFFFFFF),
    surfaceMuted: const Color(0xFFFFF0C2),
    surfaceElevated: const Color(0xFFFFFAEB),
    textPrimary: const Color(0xFF1F1F1F),
    textSecondary: const Color(0xFF533D22),
    textMuted: const Color(0xFF876847),
    brand: const Color(0xFFFA520F),
    brandSoft: const Color(0xFFFFE295),
    accent: const Color(0xFFFFA110),
    success: const Color(0xFF2C8C4B),
    warning: const Color(0xFFB06A09),
    danger: const Color(0xFFD2451E),
    border: const Color(0xFFE6C98E),
    borderSoft: const Color(0xFFF2DEB0),
    shadow: const Color(0x1F7F6315),
    heroStart: const Color(0xFFFFF0C2),
    heroEnd: const Color(0xFFFFD06A),
    brandGradient: const LinearGradient(
      colors: <Color>[
        Color(0xFFFFD900),
        Color(0xFFFFE295),
        Color(0xFFFFA110),
        Color(0xFFFF8105),
        Color(0xFFFB6424),
        Color(0xFFFA520F),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    blockColors: const <Color>[
      Color(0xFFFFD900),
      Color(0xFFFFE295),
      Color(0xFFFFA110),
      Color(0xFFFF8105),
      Color(0xFFFB6424),
      Color(0xFFFA520F),
    ],
  );

  static final AppTokens _darkTokens = AppTokens(
    pageBackground: const Color(0xFF1B130B),
    pageBackgroundAlt: const Color(0xFF2A1D10),
    surface: const Color(0xFF24180E),
    surfaceMuted: const Color(0xFF322114),
    surfaceElevated: const Color(0xFF3E2916),
    textPrimary: const Color(0xFFFFF4DF),
    textSecondary: const Color(0xFFF2D7AD),
    textMuted: const Color(0xFFD5B27B),
    brand: const Color(0xFFFF7A1A),
    brandSoft: const Color(0xFF5B3818),
    accent: const Color(0xFFFFD06A),
    success: const Color(0xFF6EDB8D),
    warning: const Color(0xFFFFC15A),
    danger: const Color(0xFFFF8A65),
    border: const Color(0x4DFFE295),
    borderSoft: const Color(0x33FFE295),
    shadow: const Color(0x52341405),
    heroStart: const Color(0xFF3E2916),
    heroEnd: const Color(0xFF8D430F),
    brandGradient: const LinearGradient(
      colors: <Color>[
        Color(0xFFFFD06A),
        Color(0xFFFFB83E),
        Color(0xFFFFA110),
        Color(0xFFFF8105),
        Color(0xFFFB6424),
        Color(0xFFFA520F),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    blockColors: const <Color>[
      Color(0xFFFFD06A),
      Color(0xFFFFB83E),
      Color(0xFFFFA110),
      Color(0xFFFF8105),
      Color(0xFFFB6424),
      Color(0xFFFA520F),
    ],
  );

  static ThemeData _buildTheme(AppTokens tokens, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: tokens.brand,
      onPrimary: Colors.white,
      secondary: tokens.accent,
      onSecondary: tokens.textPrimary,
      error: tokens.danger,
      onError: Colors.white,
      surface: tokens.surface,
      onSurface: tokens.textPrimary,
    );

    final textTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.08,
        letterSpacing: -1.0,
        color: tokens.textPrimary,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.1,
        letterSpacing: -0.7,
        color: tokens.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.3,
        color: tokens.textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.2,
        color: tokens.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: tokens.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 15,
        height: 1.5,
        color: tokens.textSecondary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Lato',
        fontSize: 13,
        height: 1.5,
        color: tokens.textSecondary,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: tokens.textPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Lato',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: tokens.textMuted,
      ),
    );

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: tokens.border),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.pageBackground,
      fontFamily: 'Lato',
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[tokens],
      dividerColor: tokens.borderSoft,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: tokens.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: tokens.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: tokens.surface,
        margin: EdgeInsets.zero,
        elevation: 0,
        shadowColor: tokens.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: tokens.borderSoft),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: tokens.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: BorderSide(color: tokens.borderSoft),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.surfaceElevated,
        hintStyle: textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
        labelStyle: textTheme.labelMedium?.copyWith(color: tokens.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: tokens.brand, width: 1.4),
        ),
        errorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: tokens.danger),
        ),
        focusedErrorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: tokens.danger, width: 1.4),
        ),
        border: outlineInputBorder,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: tokens.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: tokens.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: tokens.borderSoft),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.brand,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tokens.textPrimary,
          backgroundColor: tokens.surfaceElevated,
          side: BorderSide(color: tokens.border),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: tokens.surface,
        indicatorColor: tokens.brandSoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(color: tokens.brand);
          }
          return textTheme.labelMedium?.copyWith(color: tokens.textMuted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: tokens.brand);
          }
          return IconThemeData(color: tokens.textMuted);
        }),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: tokens.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: tokens.borderSoft),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: tokens.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    );
  }
}
