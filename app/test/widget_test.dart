import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:campusflow/main.dart';

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets("L'écran de titre affiche le logo et le nom de l'application", (
    tester,
  ) async {
    await tester.pumpWidget(const CampusFlowApp());

    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.text('Ne ratez plus aucun rendu'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
