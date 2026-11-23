import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme.dart';
import 'features/taches/presentation/echeances_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Noms des jours et des mois en français pour DateFormat.
  await initializeDateFormatting('fr_FR');
  runApp(const CampusFlowApp());
}

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: campusTheme(),
      // Interface en français, y compris le calendrier de choix de date.
      locale: const Locale('fr'),
      supportedLocales: const [Locale('fr'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const EcheancesScreen(),
    );
  }
}
