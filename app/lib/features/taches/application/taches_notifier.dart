import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/donnees_demo.dart';

/// L'état partagé des tâches. L'état est immuable : chaque action assigne
/// une nouvelle liste au lieu de modifier l'ancienne.
class TachesNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() => tachesDemo();

  void ajouter(Task tache) {
    state = [...state, tache]..sort((a, b) => a.echeance.compareTo(b.echeance));
  }

  void basculer(String id) {
    state = [
      for (final t in state) t.id == id ? t.copyWith(terminee: !t.terminee) : t,
    ];
  }

  void supprimer(String id) {
    state = [
      for (final t in state)
        if (t.id != id) t,
    ];
  }
}

final tachesProvider = NotifierProvider<TachesNotifier, List<Task>>(
  TachesNotifier.new,
);

final coursProvider = Provider<List<Course>>((ref) => coursDemo);
