import 'package:flutter/material.dart';

import '../data/echeance_store.dart';
import '../models/echeance.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.store,
    required this.echeanceId,
  });

  final EcheanceStore store;
  final String echeanceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final echeance = store.parId(echeanceId);
          if (echeance == null) {
            return const Center(child: Text('Échéance introuvable'));
          }
          return EcheanceDetail(
            echeance: echeance,
            onBasculer: () => store.basculerFait(echeance.id),
          );
        },
      ),
    );
  }
}

class EcheanceDetail extends StatelessWidget {
  const EcheanceDetail({
    super.key,
    required this.echeance,
    required this.onBasculer,
  });

  final Echeance echeance;
  final VoidCallback onBasculer;

  void _basculer(BuildContext context) {
    final devientFait = !echeance.fait;
    onBasculer();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            devientFait
                ? '« ${echeance.titre} » marquée comme faite'
                : '« ${echeance.titre} » remise à faire',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final loc = MaterialLocalizations.of(context);
    final e = echeance;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(e.titre, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.school_outlined, size: 18),
                    label: Text(e.matiere),
                  ),
                  Chip(
                    avatar: Icon(
                      e.fait ? Icons.check_circle : Icons.schedule,
                      size: 18,
                    ),
                    label: Text(e.fait ? 'Terminée' : 'À faire'),
                    backgroundColor: e.fait ? scheme.secondaryContainer : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.event_outlined),
                      title: const Text('Date limite'),
                      subtitle: Text(loc.formatFullDate(e.date)),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.hourglass_bottom),
                      title: const Text('Délai'),
                      subtitle: Text(
                        e.delaiEnClair,
                        style: e.enRetard
                            ? TextStyle(color: scheme.error)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              if (e.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 4),
                        Text(e.description, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _basculer(context),
                icon: Icon(e.fait ? Icons.undo : Icons.check),
                label: Text(
                  e.fait ? 'Marquer comme à faire' : 'Marquer comme fait',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
