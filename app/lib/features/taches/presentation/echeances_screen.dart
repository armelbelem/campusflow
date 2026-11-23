import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../core/widgets/message_erreur.dart';
import '../application/filtres.dart';
import '../application/taches_notifier.dart';
import 'detail_tache_screen.dart';
import 'widgets/liste_taches.dart';

/// Écran Échéances, branché sur l'état partagé : une tâche cochée ou ajoutée
/// ailleurs apparaît ici immédiatement. Les trois états de AsyncValue sont
/// traités : chargement, erreur avec Réessayer, données.
class EcheancesScreen extends ConsumerStatefulWidget {
  const EcheancesScreen({super.key});

  @override
  ConsumerState<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends ConsumerState<EcheancesScreen> {
  String? _idSelectionne;

  Future<void> _basculer(Task tache) => avecMessageErreur(
    context,
    () => ref.read(tachesProvider.notifier).basculer(tache),
  );

  @override
  Widget build(BuildContext context) {
    // watch dans build : l'écran se reconstruit à chaque changement.
    final etat = ref.watch(tachesFiltreesProvider);
    final toutes = ref.watch(tachesProvider).value ?? const <Task>[];
    final cours = ref.watch(coursProvider).value ?? const <Course>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Échéances')),
      body: Column(
        children: [
          const _BarreFiltres(),
          Expanded(
            child: etat.when(
              data: (taches) => RefreshIndicator(
                onRefresh: () => ref.refresh(tachesProvider.future),
                child: _corps(toutes, taches, cours),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (erreur, _) => MessageErreur(
                message: '$erreur',
                onReessayer: () => ref.invalidate(tachesProvider),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // read dans un gestionnaire d'action, jamais watch.
        onPressed: () => context.push('/taches/nouvelle'),
        tooltip: 'Nouvelle tâche',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _corps(List<Task> toutes, List<Task> taches, List<Course> cours) {
    // Seuil de 840 dp : liste seule en dessous, liste et détail au-dessus.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 840) {
          return ListeTaches(
            taches: taches,
            cours: cours,
            onBasculer: _basculer,
            onOuvrir: (t) => context.push('/taches/${t.id}'),
          );
        }
        // Cherchée dans toutes les tâches : une tâche cochée reste affichée
        // même si elle sort du filtre courant.
        final selection = toutes
            .where((t) => t.id == _idSelectionne)
            .firstOrNull;
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: ListeTaches(
                taches: taches,
                cours: cours,
                idSelectionne: _idSelectionne,
                onBasculer: _basculer,
                onOuvrir: (t) => setState(() => _idSelectionne = t.id),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              flex: 3,
              child: selection == null
                  ? const Center(
                      child: Text('Sélectionnez une tâche dans la liste.'),
                    )
                  : DetailTacheView(
                      tache: selection,
                      cours: cours
                          .where((c) => c.id == selection.coursId)
                          .firstOrNull,
                      onMarquerFait: () => _basculer(selection),
                      onSupprimer: () => avecMessageErreur(context, () async {
                        await ref
                            .read(tachesProvider.notifier)
                            .supprimer(selection.id);
                        if (mounted) setState(() => _idSelectionne = null);
                      }),
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// Les trois filtres reliés au fournisseur dérivé (ChoiceChip dans un Wrap :
/// ils passent à la ligne au lieu de déborder sur un petit écran).
class _BarreFiltres extends ConsumerWidget {
  const _BarreFiltres();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actif = ref.watch(filtreProvider);
    final compteurs = ref.watch(compteursProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CampusSpacing.m,
        CampusSpacing.s,
        CampusSpacing.m,
        0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: CampusSpacing.s,
          children: [
            for (final f in Filtre.values)
              ChoiceChip(
                label: Text('${f.libelle} (${compteurs[f]})'),
                selected: f == actif,
                onSelected: (_) => ref.read(filtreProvider.notifier).choisir(f),
              ),
          ],
        ),
      ),
    );
  }
}
