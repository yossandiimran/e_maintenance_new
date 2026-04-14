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

/// Shared animation durations & curves for consistent motion.
class AppMotion {
  const AppMotion._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 480);
  static const Duration stagger = Duration(milliseconds: 60);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve enter = Curves.easeOutBack;
  static const Curve exit = Curves.easeInCubic;
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
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -0.8,
        color: tokens.textPrimary,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.12,
        letterSpacing: -0.5,
        color: tokens.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.2,
        color: tokens.textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.15,
        color: tokens.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: tokens.textPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 13,
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
      bodySmall: TextStyle(
        fontFamily: 'Lato',
        fontSize: 12,
        height: 1.45,
        color: tokens.textMuted,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        color: tokens.textPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Lato',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        color: tokens.textMuted,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Lato',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
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
      // Smoother page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
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
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: tokens.borderSoft),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: tokens.surface,
        elevation: 8,
        shadowColor: tokens.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: tokens.borderSoft),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.surfaceElevated,
        hintStyle: textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
        labelStyle: textTheme.labelMedium?.copyWith(color: tokens.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: tokens.brand, width: 1.6),
        ),
        errorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: tokens.danger),
        ),
        focusedErrorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(color: tokens.danger, width: 1.6),
        ),
        border: outlineInputBorder,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: tokens.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: tokens.textPrimary),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: tokens.borderSoft),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.brand,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: textTheme.labelLarge?.copyWith(color: Colors.white),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        height: 62,
        indicatorColor: tokens.brandSoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(color: tokens.brand, fontWeight: FontWeight.w800);
          }
          return textTheme.labelMedium?.copyWith(color: tokens.textMuted);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: tokens.brand, size: 22);
          }
          return IconThemeData(color: tokens.textMuted, size: 22);
        }),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: tokens.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: tokens.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: tokens.borderSoft),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: tokens.surfaceElevated,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: outlineInputBorder,
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(tokens.surface),
          surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: tokens.borderSoft),
            ),
          ),
          elevation: const WidgetStatePropertyAll<double>(8),
          shadowColor: WidgetStatePropertyAll<Color>(tokens.shadow),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: tokens.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: tokens.brand.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: tokens.surfaceMuted,
        selectedColor: tokens.brand,
        secondarySelectedColor: tokens.brand,
        labelStyle: textTheme.labelLarge?.copyWith(color: tokens.textPrimary),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(color: Colors.white),
        side: BorderSide(color: tokens.borderSoft),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        showCheckmark: true,
        checkmarkColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tokens.brand,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: tokens.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        shadowColor: tokens.shadow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: tokens.borderSoft,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: tokens.brand,
        linearTrackColor: tokens.borderSoft,
        circularTrackColor: tokens.borderSoft,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tokens.brand,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: tokens.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: tokens.borderSoft),
          boxShadow: <BoxShadow>[
            BoxShadow(color: tokens.shadow, blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: tokens.textPrimary),
      ),
    );
  }
}
