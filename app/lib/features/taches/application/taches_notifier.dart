import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cours/data/api_cours_repository.dart';
import '../data/api_task_repository.dart';
import '../domain/task_repository.dart';

/// L'état des tâches, chargé depuis le repository. AsyncValue porte les trois
/// états : chargement, erreur, données. Chaque modification passe d'abord
/// par le serveur, puis remplace la liste (l'état reste immuable).
class TachesNotifier extends AsyncNotifier<List<Task>> {
  TaskRepository get _repo => ref.read(taskRepositoryProvider);

  @override
  Future<List<Task>> build() async =>
      _trier(await ref.watch(taskRepositoryProvider).lister());

  /// POST /taches
  Future<void> ajouter(Task tache) async {
    final creee = await _repo.ajouter(tache);
    _remplacer((liste) => [...liste, creee]);
  }

  /// PATCH /taches/:id
  Future<void> basculer(Task tache) async {
    final maj = await _repo.basculer(tache);
    _remplacer((liste) => [for (final t in liste) t.id == maj.id ? maj : t]);
  }

  /// DELETE /taches/:id
  Future<void> supprimer(String id) async {
    await _repo.supprimer(id);
    _remplacer(
      (liste) => [
        for (final t in liste)
          if (t.id != id) t,
      ],
    );
  }

  void _remplacer(List<Task> Function(List<Task> liste) calcul) {
    if (!ref.mounted) return;
    state = AsyncData(_trier(calcul(state.value ?? const [])));
  }

  static List<Task> _trier(List<Task> taches) =>
      [...taches]..sort((a, b) => a.echeance.compareTo(b.echeance));
}

final tachesProvider = AsyncNotifierProvider<TachesNotifier, List<Task>>(
  TachesNotifier.new,
);

final coursProvider = FutureProvider<List<Course>>(
  (ref) => ref.watch(coursRepositoryProvider).lister(),
);
