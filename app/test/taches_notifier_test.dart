import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campusflow/core/session_storage.dart';
import 'package:campusflow/features/taches/application/taches_notifier.dart';
import 'package:campusflow/features/taches/data/api_task_repository.dart';
import 'package:campusflow/features/taches/data/fake_task_repository.dart';

/// L'état est testé sans réseau : le repository est remplacé par le Fake,
/// et un utilisateur est déjà connecté.
ProviderContainer conteneur(FakeTaskRepository repo) {
  final c = ProviderContainer(
    overrides: [
      taskRepositoryProvider.overrideWithValue(repo),
      sessionStorageProvider.overrideWithValue(
        MemoireSessionStorage(
          jeton: 'jeton-de-test',
          utilisateur: User(id: 'u1', nom: 'Ibrahim', email: 'i@campus.bf'),
        ),
      ),
    ],
    retry: (_, _) => null,
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  test(
    'build charge les tâches depuis le repository, triées par date',
    () async {
      final c = conteneur(FakeTaskRepository());

      final taches = await c.read(tachesProvider.future);

      expect(taches, hasLength(5));
      expect(taches.first.echeance.isBefore(taches.last.echeance), isTrue);
    },
  );

  test('basculer remplace la liste au lieu de la modifier', () async {
    final c = conteneur(FakeTaskRepository());
    final avant = await c.read(tachesProvider.future);
    final tache = avant.firstWhere((t) => !t.terminee);

    await c.read(tachesProvider.notifier).basculer(tache);
    final apres = c.read(tachesProvider).value!;

    expect(identical(avant, apres), isFalse);
    expect(apres.firstWhere((t) => t.id == tache.id).terminee, isTrue);
    // L'ancienne liste n'a pas bougé : l'état est immuable.
    expect(avant.firstWhere((t) => t.id == tache.id).terminee, isFalse);
  });

  test('ajouter puis supprimer passent par le repository', () async {
    final repo = FakeTaskRepository();
    final c = conteneur(repo);
    await c.read(tachesProvider.future);

    final nouvelle = Task(
      id: 'n1',
      titre: 'Nouvelle',
      echeance: DateTime(2000),
    );
    await c.read(tachesProvider.notifier).ajouter(nouvelle);
    expect(c.read(tachesProvider).value!.first.id, 'n1');
    expect((await repo.lister()).any((t) => t.id == 'n1'), isTrue);

    await c.read(tachesProvider.notifier).supprimer('n1');
    expect(c.read(tachesProvider).value!.any((t) => t.id == 'n1'), isFalse);
  });

  test('un serveur en panne donne un état « erreur »', () async {
    final c = conteneur(FakeTaskRepository(echec: true));

    await expectLater(c.read(tachesProvider.future), throwsA(anything));
    expect(c.read(tachesProvider).hasError, isTrue);
  });
}
