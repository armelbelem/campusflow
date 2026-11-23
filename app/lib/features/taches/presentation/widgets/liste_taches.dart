import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme.dart';
import 'tache_tile.dart';

/// Liste des tâches construite à la demande par ListView.builder.
class ListeTaches extends StatelessWidget {
  const ListeTaches({
    super.key,
    required this.taches,
    required this.cours,
    required this.onBasculer,
    required this.onOuvrir,
    this.idSelectionne,
  });

  final List<Task> taches;
  final List<Course> cours;
  final ValueChanged<Task> onBasculer;
  final ValueChanged<Task> onOuvrir;
  final String? idSelectionne;

  @override
  Widget build(BuildContext context) {
    if (taches.isEmpty) {
      return const Center(child: Text('Aucune tâche ici.'));
    }
    final coursParId = {for (final c in cours) c.id: c};
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        CampusSpacing.m,
        CampusSpacing.s,
        CampusSpacing.m,
        88, // place pour le bouton flottant
      ),
      itemCount: taches.length,
      itemBuilder: (context, i) {
        final tache = taches[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: CampusSpacing.s),
          child: TacheTile(
            tache: tache,
            cours: coursParId[tache.coursId],
            selectionnee: tache.id == idSelectionne,
            onBasculer: () => onBasculer(tache),
            onOuvrir: () => onOuvrir(tache),
          ),
        );
      },
    );
  }
}
