import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:campusflow/core/router.dart';
import 'package:campusflow/features/accueil/titre_screen.dart';
import 'package:campusflow/main.dart';

/// Simule un téléphone de 360 × 780 dp.
void telephone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Future<ProviderContainer> lancer(WidgetTester tester) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const CampusFlowApp(),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets("L'écran de titre affiche le logo et le nom de l'application", (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TitreScreen()));

    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Échéances : liste, case à cocher et barre de navigation', (
    tester,
  ) async {
    telephone(tester);
    await lancer(tester);

    expect(find.text('Rapport SQL'), findsOneWidget);
    expect(find.text('En retard'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    // Cocher la tâche en retard fait disparaître le badge « En retard ».
    await tester.tap(find.byType(Checkbox).at(1));
    await tester.pump();
    expect(find.text('En retard'), findsNothing);
  });

  testWidgets('Routes : chaque écran est atteignable par son adresse', (
    tester,
  ) async {
    telephone(tester);
    final container = await lancer(tester);
    final router = container.read(routerProvider);

    router.go('/cours');
    await tester.pumpAndSettle();
    expect(find.text('Programmation mobile'), findsOneWidget);

    router.go('/profil');
    await tester.pumpAndSettle();
    expect(find.text('Se déconnecter'), findsOneWidget);

    router.go('/taches/t3');
    await tester.pumpAndSettle();
    expect(find.text('Rapport SQL'), findsOneWidget);
    expect(find.text('Marquer comme fait'), findsOneWidget);

    router.go('/login');
    await tester.pumpAndSettle();
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('Détail : « Marquer comme fait » coche la tâche', (tester) async {
    telephone(tester);
    await lancer(tester);

    await tester.tap(find.text('TP Dart : modèles et tests'));
    await tester.pumpAndSettle();
    expect(find.text('Marquer comme fait'), findsOneWidget);

    await tester.tap(find.text('Marquer comme fait'));
    await tester.pumpAndSettle();
    final cases = tester.widgetList<Checkbox>(find.byType(Checkbox));
    expect(cases.elementAt(2).value, isTrue);
  });

  testWidgets('Formulaire : titre obligatoire, puis ajout et SnackBar', (
    tester,
  ) async {
    telephone(tester);
    await lancer(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    expect(find.text('Le titre est obligatoire'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'Fiche de lecture',
    );
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(find.text('Tâche « Fiche de lecture » ajoutée'), findsOneWidget);
    expect(find.text('Fiche de lecture'), findsOneWidget);
  });

  testWidgets('Tablette (≥ 840 dp) : liste et détail côte à côte', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await lancer(tester);

    expect(find.text('Sélectionnez une tâche dans la liste.'), findsOneWidget);
    expect(find.byType(NavigationRail), findsOneWidget);

    await tester.tap(find.text('Rapport SQL'));
    await tester.pumpAndSettle();
    // Le détail s'affiche à droite, sans changer d'écran.
    expect(find.text('Marquer comme fait'), findsOneWidget);
  });
}
