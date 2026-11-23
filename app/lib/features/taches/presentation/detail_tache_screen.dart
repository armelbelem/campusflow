import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/formats.dart';
import '../../../core/theme.dart';
import '../application/taches_notifier.dart';

/// Page de la route /taches/:id : elle lit la tâche dans l'état partagé,
/// sans paramètre ni callback venant de la liste.
class DetailTachePage extends ConsumerWidget {
  const DetailTachePage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tache = ref
        .watch(tachesProvider)
        .where((t) => t.id == id)
        .firstOrNull;
    if (tache == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Tâche introuvable.')),
      );
    }
    final cours = ref
        .watch(coursProvider)
        .where((c) => c.id == tache.coursId)
        .firstOrNull;
    return DetailTacheScreen(
      tache: tache,
      cours: cours,
      onMarquerFait: () => ref.read(tachesProvider.notifier).basculer(id),
      onSupprimer: () {
        ref.read(tachesProvider.notifier).supprimer(id);
        context.pop();
      },
    );
  }
}

/// Écran Détail d'une tâche (téléphone).
class DetailTacheScreen extends StatelessWidget {
  const DetailTacheScreen({
    super.key,
    required this.tache,
    required this.onMarquerFait,
    this.cours,
    this.onSupprimer,
  });

  final Task tache;
  final Course? cours;
  final VoidCallback onMarquerFait;
  final VoidCallback? onSupprimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: DetailTacheView(
        tache: tache,
        cours: cours,
        onMarquerFait: onMarquerFait,
        onSupprimer: onSupprimer,
      ),
    );
  }
}

/// Contenu du détail, réutilisé dans la colonne de droite sur tablette.
class DetailTacheView extends StatelessWidget {
  const DetailTacheView({
    super.key,
    required this.tache,
    required this.onMarquerFait,
    this.cours,
    this.onSupprimer,
  });

  final Task tache;
  final Course? cours;
  final VoidCallback onMarquerFait;
  final VoidCallback? onSupprimer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statut = tache.terminee
        ? 'Faite'
        : tache.enRetard
        ? 'En retard'
        : 'À faire';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(CampusSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(tache.titre, style: theme.textTheme.titleLarge),
          const SizedBox(height: CampusSpacing.m),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(CampusSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Ligne(
                    icone: Icons.school_outlined,
                    libelle: 'Cours',
                    valeur: cours?.intitule ?? 'Aucun cours',
                  ),
                  _Ligne(
                    icone: Icons.event_outlined,
                    libelle: 'Échéance',
                    valeur: formatDateLongue(tache.echeance),
                  ),
                  _Ligne(
                    icone: Icons.flag_outlined,
                    libelle: 'Statut',
                    valeur: statut,
                  ),
                  if (tache.description case final description?) ...[
                    const Divider(height: CampusSpacing.l),
                    Text(description, style: theme.textTheme.bodyLarge),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: CampusSpacing.l),
          FilledButton.icon(
            onPressed: onMarquerFait,
            icon: Icon(tache.terminee ? Icons.undo : Icons.check),
            label: Text(
              tache.terminee ? 'Remettre à faire' : 'Marquer comme fait',
            ),
          ),
          if (onSupprimer != null) ...[
            const SizedBox(height: CampusSpacing.s),
            TextButton.icon(
              onPressed: onSupprimer,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Supprimer'),
            ),
          ],
        ],
      ),
    );
  }
}

class _Ligne extends StatelessWidget {
  const _Ligne({
    required this.icone,
    required this.libelle,
    required this.valeur,
  });

  final IconData icone;
  final String libelle;
  final String valeur;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: CampusSpacing.s),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$libelle : ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: valeur),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
