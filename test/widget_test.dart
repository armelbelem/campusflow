import 'package:campusflow/data/echeance_store.dart';
import 'package:campusflow/main.dart';
import 'package:campusflow/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> lancer(WidgetTester tester) =>
      tester.pumpWidget(CampusFlowApp(store: EcheanceStore.avecExemples()));

  testWidgets('La NavigationBar filtre les échéances terminées',
      (tester) async {
    await lancer(tester);
    expect(find.text('Rendu TP Flutter'), findsOneWidget);
    expect(find.text('Lecture du chapitre 3'), findsNothing);

    await tester.tap(find.text('Terminées'));
    await tester.pumpAndSettle();

    expect(find.text('Lecture du chapitre 3'), findsOneWidget);
    expect(find.text('Rendu TP Flutter'), findsNothing);
  });

  testWidgets('Téléphone : le détail permet de marquer comme fait',
      (tester) async {
    await lancer(tester);

    await tester.tap(find.text('Rendu TP Flutter'));
    await tester.pumpAndSettle();
    expect(find.byType(DetailScreen), findsOneWidget);

    final bouton = find.text('Marquer comme fait');
    await tester.ensureVisible(bouton);
    await tester.tap(bouton);
    await tester.pump();

    expect(find.text('Marquer comme à faire'), findsOneWidget);
    expect(find.text('« Rendu TP Flutter » marquée comme faite'),
        findsOneWidget);
  });

  testWidgets('Le formulaire refuse un envoi vide', (tester) async {
    await lancer(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    final enregistrer = find.text('Enregistrer');
    await tester.ensureVisible(enregistrer);
    await tester.tap(enregistrer);
    await tester.pump();

    expect(find.text('Le titre est obligatoire'), findsOneWidget);
    expect(find.text('La matière est obligatoire'), findsOneWidget);
    expect(find.text('Choisissez une date limite'), findsOneWidget);
  });

  testWidgets('Tablette : liste et détail côte à côte', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await lancer(tester);
    expect(find.text('Sélectionnez une échéance'), findsOneWidget);

    await tester.tap(find.text('Rendu TP Flutter'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailScreen), findsNothing);
    expect(find.text('Rendu TP Flutter'), findsNWidgets(2));
    expect(find.text('Marquer comme fait'), findsOneWidget);
  });
}
