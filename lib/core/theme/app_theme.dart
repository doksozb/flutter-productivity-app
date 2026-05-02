import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  PRODUCTIVITY PRO — Design Token System
//  Drop this file into lib/core/theme/
//  Then wrap your app: theme: AppTheme.dark()
// ─────────────────────────────────────────────

abstract class AppColors {
  // Backgrounds
  static const bgPrimary   = Color(0xFF0C0F17);
  static const bgSurface   = Color(0xFF131722);
  static const bgElevated  = Color(0xFF1D2133);

  // Borders
  static const borderSubtle   = Color(0xFF1A1E2E);
  static const borderDefault  = Color(0xFF2A2D3A);
  static const borderStrong   = Color(0xFF353A50);

  // Accent — electric teal
  static const accent         = Color(0xFF00D4AA);
  static const accentDim      = Color(0xFF0F3D32);
  static const accentSurface  = Color(0xFF051F1A);

  // Text
  static const textPrimary    = Color(0xFFEEF0F8);
  static const textSecondary  = Color(0xFF8A8FA8);
  static const textMuted      = Color(0xFF4A5070);
  static const textHint       = Color(0xFF2E3145);

  // Semantic
  static const success  = Color(0xFF00D4AA);
  static const error    = Color(0xFFE05555);
  static const errorDim = Color(0xFF3D1A1A);
  static const warning  = Color(0xFFEF9F27);
  static const purple   = Color(0xFF8B79F0);
  static const purpleDim = Color(0xFF1A1530);
}

abstract class AppRadius {
  static const sm  = BorderRadius.all(Radius.circular(8));
  static const md  = BorderRadius.all(Radius.circular(10));
  static const lg  = BorderRadius.all(Radius.circular(14));
  static const xl  = BorderRadius.all(Radius.circular(16));
  static const xxl = BorderRadius.all(Radius.circular(20));
  static const full = BorderRadius.all(Radius.circular(999));
}

abstract class AppSpacing {
  static const xs  = 4.0;
  static const sm  = 8.0;
  static const md  = 12.0;
  static const lg  = 16.0;
  static const xl  = 20.0;
  static const xxl = 28.0;
  static const screen = EdgeInsets.symmetric(horizontal: 18, vertical: 16);
}

abstract class AppTextStyles {
  // Display — Syne bold (headings, screen titles)
  static TextStyle displayLarge  = GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.5);
  static TextStyle displayMedium = GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3);
  static TextStyle displaySmall  = GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary);

  // Stats — large numbers
  static TextStyle statNumber = GoogleFonts.syne(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static TextStyle statNumberAccent = GoogleFonts.syne(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.accent);

  // Body — DM Sans
  static TextStyle bodyLarge  = GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static TextStyle bodyMedium = GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary);
  static TextStyle bodySmall  = GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary);

  // Labels
  static TextStyle labelLarge  = GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static TextStyle labelMedium = GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary);
  static TextStyle labelSmall  = GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textMuted, letterSpacing: 0.07);

  // Section headers (ALL CAPS overline)
  static TextStyle overline = GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 0.08, height: 1);

  // Button
  static TextStyle button = GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.bgPrimary);
}

abstract class AppDecorations {
  // Standard surface card
  static BoxDecoration card = BoxDecoration(
    color: AppColors.bgSurface,
    borderRadius: AppRadius.xl,
    border: Border.all(color: AppColors.borderSubtle, width: 1),
  );

  // Accent tinted card (completed tasks, accent stats)
  static BoxDecoration cardAccent = BoxDecoration(
    color: AppColors.accentSurface,
    borderRadius: AppRadius.xl,
    border: Border.all(color: AppColors.accentDim, width: 1),
  );

  // Error tinted card
  static BoxDecoration cardError = BoxDecoration(
    color: AppColors.errorDim,
    borderRadius: AppRadius.xl,
    border: Border.all(color: const Color(0xFF5A2020), width: 1),
  );

  // Purple tinted card
  static BoxDecoration cardPurple = BoxDecoration(
    color: AppColors.purpleDim,
    borderRadius: AppRadius.xl,
    border: Border.all(color: const Color(0xFF2A2045), width: 1),
  );

  // Text input field
  static BoxDecoration inputField = BoxDecoration(
    color: AppColors.bgPrimary,
    borderRadius: AppRadius.md,
    border: Border.all(color: AppColors.borderSubtle, width: 1),
  );

  static BoxDecoration inputFieldFocused = BoxDecoration(
    color: AppColors.bgPrimary,
    borderRadius: AppRadius.md,
    border: Border.all(color: AppColors.accent, width: 1),
  );

  // Bottom nav bar
  static BoxDecoration bottomNav = const BoxDecoration(
    color: AppColors.bgSurface,
    border: Border(top: BorderSide(color: AppColors.borderSubtle, width: 1)),
  );

  // Filter chip — inactive
  static BoxDecoration chipInactive = BoxDecoration(
    border: Border.all(color: AppColors.borderSubtle, width: 1),
    borderRadius: AppRadius.full,
  );

  // Filter chip — active
  static BoxDecoration chipActive = const BoxDecoration(
    color: AppColors.accent,
    borderRadius: AppRadius.full,
  );

  // Task checkbox — unchecked
  static BoxDecoration checkboxUnchecked = BoxDecoration(
    border: Border.all(color: AppColors.borderDefault, width: 2),
    borderRadius: AppRadius.sm,
  );

  // Task checkbox — checked
  static BoxDecoration checkboxChecked = const BoxDecoration(
    color: AppColors.accent,
    borderRadius: AppRadius.sm,
  );

  // Tag / badge
  static BoxDecoration taskTag = const BoxDecoration(
    color: Color(0xFF1A2420),
    borderRadius: AppRadius.sm,
  );

  // Avatar circle
  static BoxDecoration avatar = BoxDecoration(
    color: AppColors.accentSurface,
    border: Border.all(color: AppColors.accentDim, width: 2),
    borderRadius: AppRadius.xl,
  );

  // Auth logo tile
  static BoxDecoration logoTile = const BoxDecoration(
    color: AppColors.accent,
    borderRadius: AppRadius.lg,
  );

  // Progress bar background
  static BoxDecoration progressBg = const BoxDecoration(
    color: AppColors.borderSubtle,
    borderRadius: AppRadius.full,
  );

  // Progress bar fill
  static BoxDecoration progressFill = const BoxDecoration(
    color: AppColors.accent,
    borderRadius: AppRadius.full,
  );

  // Quick action button
  static BoxDecoration quickAction = BoxDecoration(
    color: AppColors.bgSurface,
    borderRadius: AppRadius.xl,
    border: Border.all(color: AppColors.borderSubtle, width: 1),
  );

  // Icon tile — neutral
  static BoxDecoration iconTile = const BoxDecoration(
    color: AppColors.bgElevated,
    borderRadius: AppRadius.sm,
  );

  // Icon tile — accent
  static BoxDecoration iconTileAccent = const BoxDecoration(
    color: Color(0xFF082E25),
    borderRadius: AppRadius.sm,
  );

  // Bottom sheet
  static BoxDecoration bottomSheet = const BoxDecoration(
    color: AppColors.bgSurface,
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  );
}

// ─────────────────────────────────────────────
//  ThemeData — pass to MaterialApp
// ─────────────────────────────────────────────

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgPrimary,
      colorScheme: const ColorScheme.dark(
        primary:    AppColors.accent,
        onPrimary:  AppColors.bgPrimary,
        secondary:  AppColors.purple,
        surface:    AppColors.bgSurface,
        onSurface:  AppColors.textPrimary,
        error:      AppColors.error,
      ),

      // Text
      textTheme: TextTheme(
        displayLarge:  AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall:  AppTextStyles.displaySmall,
        bodyLarge:     AppTextStyles.bodyLarge,
        bodyMedium:    AppTextStyles.bodyMedium,
        bodySmall:     AppTextStyles.bodySmall,
        labelLarge:    AppTextStyles.labelLarge,
        labelMedium:   AppTextStyles.labelMedium,
        labelSmall:    AppTextStyles.labelSmall,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.displaySmall,
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
      ),

      // Bottom nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgSurface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.accent),
        unselectedLabelStyle: AppTextStyles.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgPrimary,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: BorderSide(color: AppColors.accent),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),

      // Elevated button (primary CTA)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.bgPrimary,
          textStyle: AppTextStyles.button,
          minimumSize: const Size(double.infinity, 52),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
          elevation: 0,
        ),
      ),

      // Outlined button (secondary)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          textStyle: AppTextStyles.labelLarge,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: AppColors.borderSubtle),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.accent),
        ),
      ),

      // Card
      cardTheme: const CardThemeData(
        color: AppColors.bgSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xl,
          side: BorderSide(color: AppColors.borderSubtle),
        ),
        margin: EdgeInsets.zero,
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.accent;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.bgPrimary),
        side: const BorderSide(color: AppColors.borderDefault, width: 2),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: AppColors.accent,
        labelStyle: AppTextStyles.labelMedium,
        side: const BorderSide(color: AppColors.borderSubtle),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.full),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1,
        space: 0,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgElevated,
        contentTextStyle: AppTextStyles.bodyMedium,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
        behavior: SnackBarBehavior.floating,
      ),

      // Dialog / Bottom sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.bgSurface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xl),
        titleTextStyle: AppTextStyles.displaySmall,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.bgPrimary;
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.accent;
          return AppColors.bgElevated;
        }),
      ),

      // List tile
      listTileTheme: const ListTileThemeData(
        tileColor: AppColors.bgSurface,
        textColor: AppColors.textSecondary,
        iconColor: AppColors.textMuted,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      ),

      // Progress indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearTrackColor: AppColors.borderSubtle,
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppColors.textMuted,
        size: 20,
      ),
    );
  }
}
