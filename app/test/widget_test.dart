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
}
