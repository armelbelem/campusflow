import 'package:flutter/material.dart';

/// Couleurs du design system v1 (docs/seance2/04-design-system.md).
/// Chaque couleur portant du texte respecte un contraste d'au moins 4,5:1.
abstract final class CampusColors {
  static const primaire = Color(0xFFC4260E);
  static const texte = Color(0xFF1B1C1F);
  static const texteSecondaire = Color(0xFF5B5E66);
  static const surface = Color(0xFFF7F6F3);
  static const bordure = Color(0xFFDAD7D1);
  static const succes = Color(0xFF1D7348);
  static const retard = Color(0xFFB3261E);
}

/// Espacements du design system (en dp).
abstract final class CampusSpacing {
  static const s = 8.0;
  static const m = 16.0;
  static const l = 24.0;
  static const xl = 32.0;
}

/// Thème unique de l'application : les widgets lisent leurs couleurs et
/// leurs tailles ici, jamais en dur.
ThemeData campusTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: CampusColors.primaire)
      .copyWith(
        primary: CampusColors.primaire,
        onPrimary: Colors.white,
        error: CampusColors.retard,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: CampusColors.texte,
        onSurfaceVariant: CampusColors.texteSecondaire,
        surfaceContainerLow: CampusColors.surface,
        outlineVariant: CampusColors.bordure,
      );
  final rond12 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: CampusColors.texte,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: CampusColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: rond12.copyWith(
        side: const BorderSide(color: CampusColors.bordure),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: rond12,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: rond12,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: CampusColors.primaire,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: CampusColors.surface,
      indicatorColor: Color(0xFFFBE6E0),
    ),
  );
}
