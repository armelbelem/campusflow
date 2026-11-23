import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/router.dart';
import 'core/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Noms des jours et des mois en français pour DateFormat.
  await initializeDateFormatting('fr_FR');
  // ProviderScope stocke l'état de tous les fournisseurs Riverpod.
  // Pas de nouvel essai automatique : l'erreur s'affiche avec un bouton
  // Réessayer, et c'est l'utilisateur qui relance.
  runApp(ProviderScope(retry: (_, _) => null, child: const CampusFlowApp()));
}

class CampusFlowApp extends ConsumerWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: campusTheme(),
      // Interface en français, y compris le calendrier de choix de date.
      locale: const Locale('fr'),
      supportedLocales: const [Locale('fr'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
