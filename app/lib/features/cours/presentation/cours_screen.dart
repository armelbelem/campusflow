import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../taches/application/taches_notifier.dart';

/// Écran Cours : la liste des cours et le nombre de tâches à faire.
class CoursScreen extends ConsumerWidget {
  const CoursScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cours = ref.watch(coursProvider);
    final taches = ref.watch(tachesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cours')),
      body: ListView.builder(
        padding: const EdgeInsets.all(CampusSpacing.m),
        itemCount: cours.length,
        itemBuilder: (context, i) {
          final c = cours[i];
          final aFaire = taches
              .where((t) => t.coursId == c.id && !t.terminee)
              .length;
          final details = [
            c.enseignant,
            '${c.credits} crédits',
            if (c.salle case final salle?) 'salle $salle',
          ].join(' · ');
          return Padding(
            padding: const EdgeInsets.only(bottom: CampusSpacing.s),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(c.intitule),
                subtitle: Text(details),
                trailing: Text(
                  aFaire == 0 ? 'à jour' : '$aFaire à faire',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
