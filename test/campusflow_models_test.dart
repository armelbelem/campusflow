import 'package:campusflow_models/campusflow_models.dart';
import 'package:test/test.dart';

void main() {
  test('copyWith ne modifie que le champ demandé', () {
    final tache = Task(
      id: 't1',
      titre: 'TP Dart',
      echeance: DateTime(2026, 11, 3),
    );

    final faite = tache.copyWith(terminee: true);

    expect(faite.terminee, isTrue);
    expect(faite.titre, tache.titre);
    expect(faite.echeance, tache.echeance);
    expect(tache.terminee, isFalse); // l'original n'a pas changé
  });

  test('fromJson lit une tâche valide', () {
    final tache = Task.fromJson({
      'id': 't1',
      'titre': 'TP Dart',
      'echeance': '2026-11-03T18:00:00',
      'terminee': true,
    });

    expect(tache.titre, 'TP Dart');
    expect(tache.echeance, DateTime(2026, 11, 3, 18));
    expect(tache.terminee, isTrue);
    expect(tache.description, isNull);
  });

  test('fromJson lance une FormatException si un champ manque', () {
    expect(
      () => User.fromJson({'id': 'u1', 'nom': 'Awa'}), // pas d'email
      throwsFormatException,
    );
  });
}
