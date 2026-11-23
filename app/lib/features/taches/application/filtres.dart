import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'taches_notifier.dart';

enum Filtre {
  aFaire('À faire'),
  faites('Faites'),
  enRetard('En retard');

  const Filtre(this.libelle);
  final String libelle;

  /// La règle métier de chaque filtre (Task.enRetard vient du modèle).
  bool garde(Task t) => switch (this) {
    Filtre.aFaire => !t.terminee,
    Filtre.faites => t.terminee,
    Filtre.enRetard => t.enRetard,
  };
}

/// Le filtre choisi par l'utilisateur sur l'écran Échéances.
class FiltreNotifier extends Notifier<Filtre> {
  @override
  Filtre build() => Filtre.aFaire;

  void choisir(Filtre filtre) => state = filtre;
}

final filtreProvider = NotifierProvider<FiltreNotifier, Filtre>(
  FiltreNotifier.new,
);

/// Fournisseur dérivé : recalculé dès que les tâches ou le filtre changent.
/// Il garde les trois états (chargement, erreur, données) des tâches.
final tachesFiltreesProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final filtre = ref.watch(filtreProvider);
  return ref
      .watch(tachesProvider)
      .whenData((taches) => taches.where(filtre.garde).toList());
});

/// Nombre de tâches dans chaque filtre, pour les libellés des boutons.
final compteursProvider = Provider<Map<Filtre, int>>((ref) {
  final taches = ref.watch(tachesProvider).value ?? const <Task>[];
  return {for (final f in Filtre.values) f: taches.where(f.garde).length};
});
