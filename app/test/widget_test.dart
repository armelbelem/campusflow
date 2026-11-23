import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:campusflow/features/accueil/titre_screen.dart';
import 'package:campusflow/main.dart';

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
    await tester.pumpWidget(const CampusFlowApp());

    expect(find.text('Échéances'), findsWidgets);
    expect(find.text('Rapport SQL'), findsOneWidget);
    expect(find.text('En retard'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    // Cocher la tâche en retard la fait disparaître du badge « En retard ».
    await tester.tap(find.byType(Checkbox).at(1));
    await tester.pump();
    expect(find.text('En retard'), findsNothing);
  });

  testWidgets('Détail : « Marquer comme fait » coche la tâche', (tester) async {
    await tester.pumpWidget(const CampusFlowApp());

    await tester.tap(find.text('Exposé sur le routage IP'));
    await tester.pumpAndSettle();
    expect(find.text('Marquer comme fait'), findsOneWidget);

    await tester.tap(find.text('Marquer comme fait'));
    await tester.pumpAndSettle();
    final cases = tester.widgetList<Checkbox>(find.byType(Checkbox));
    expect(cases.last.value, isTrue);
  });

  testWidgets('Formulaire : titre obligatoire, puis ajout et SnackBar', (
    tester,
  ) async {
    await tester.pumpWidget(const CampusFlowApp());

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

    await tester.pumpWidget(const CampusFlowApp());
    expect(find.text('Sélectionnez une tâche dans la liste.'), findsOneWidget);

    await tester.tap(find.text('Rapport SQL'));
    await tester.pumpAndSettle();
    // Le détail s'affiche à droite, sans changer d'écran.
    expect(find.text('Marquer comme fait'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
