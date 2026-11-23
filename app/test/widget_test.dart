import 'package:flutter_test/flutter_test.dart';

import 'package:campusflow/main.dart';

void main() {
  testWidgets("L'écran de titre affiche le nom de l'application", (
    tester,
  ) async {
    await tester.pumpWidget(const CampusFlowApp());

    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.text('Ne ratez plus aucun rendu'), findsOneWidget);
  });
}
