import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/echeance_store.dart';
import 'screens/echeances_screen.dart';

void main() {
  runApp(CampusFlowApp(store: EcheanceStore.avecExemples()));
}

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key, required this.store});

  final EcheanceStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [Locale('fr', 'FR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: _theme,
      home: EcheancesScreen(store: store),
    );
  }

  static final ThemeData _theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE5391F),
      surface: Colors.white,
      surfaceTint: Colors.transparent,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: const Color(0xFFF7F7F8),
      surfaceContainer: const Color(0xFFF3F3F5),
      surfaceContainerHigh: const Color(0xFFEDEDF0),
      surfaceContainerHighest: const Color(0xFFE7E7EB),
      outlineVariant: const Color(0xFFE4E4E7),
    ),
  );
}
