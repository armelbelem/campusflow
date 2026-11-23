import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campusflow/features/taches/application/taches_notifier.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('basculer remplace la liste au lieu de la modifier', () {
    final avant = container.read(tachesProvider);
    final id = avant.firstWhere((t) => !t.terminee).id;

    container.read(tachesProvider.notifier).basculer(id);
    final apres = container.read(tachesProvider);

    expect(identical(avant, apres), isFalse);
    expect(apres.firstWhere((t) => t.id == id).terminee, isTrue);
    // L'ancienne liste n'a pas bougé : l'état est immuable.
    expect(avant.firstWhere((t) => t.id == id).terminee, isFalse);
  });

  test('ajouter insère la tâche à sa place dans l’ordre des échéances', () {
    final tache = Task(id: 'n1', titre: 'Nouvelle', echeance: DateTime(2000));

    container.read(tachesProvider.notifier).ajouter(tache);

    expect(container.read(tachesProvider).first.id, 'n1');
  });

  test('supprimer retire la tâche', () {
    container.read(tachesProvider.notifier).supprimer('t1');

    expect(container.read(tachesProvider).any((t) => t.id == 't1'), isFalse);
  });
}
