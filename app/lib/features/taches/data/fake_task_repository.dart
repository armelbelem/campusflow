import 'package:campusflow_models/campusflow_models.dart';

import '../../../core/api_exception.dart';
import '../domain/task_repository.dart';
import 'donnees_demo.dart';

/// Implémentation en mémoire, sans réseau : pour les tests et les démos.
class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository({List<Task>? taches, this.echec = false})
    : _taches = [...(taches ?? tachesDemo())];

  final List<Task> _taches;

  /// Si `true`, chaque appel échoue comme si le serveur était coupé.
  bool echec;

  void _verifier() {
    if (echec) throw const ApiException('Serveur injoignable (simulation).');
  }

  @override
  Future<List<Task>> lister() async {
    _verifier();
    return List.unmodifiable(_taches);
  }

  @override
  Future<Task> ajouter(Task tache) async {
    _verifier();
    _taches.add(tache);
    return tache;
  }

  @override
  Future<Task> basculer(Task tache) async {
    _verifier();
    final i = _taches.indexWhere((t) => t.id == tache.id);
    final maj = tache.copyWith(terminee: !tache.terminee);
    _taches[i] = maj;
    return maj;
  }

  @override
  Future<void> supprimer(String id) async {
    _verifier();
    _taches.removeWhere((t) => t.id == id);
  }
}
