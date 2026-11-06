import 'package:flutter/material.dart';

import '../data/echeance_store.dart';
import '../models/echeance.dart';
import 'detail_screen.dart';
import 'formulaire_screen.dart';

const double kLargeurTablette = 840;

class EcheancesScreen extends StatefulWidget {
  const EcheancesScreen({super.key, required this.store});

  final EcheanceStore store;

  @override
  State<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends State<EcheancesScreen> {
  int _onglet = 0;

  String? _selectionId;

  List<Echeance> _filtrer(List<Echeance> toutes) => switch (_onglet) {
        0 => toutes.where((e) => !e.fait).toList(),
        1 => toutes.where((e) => e.fait).toList(),
        _ => toutes,
      };

  void _ouvrir(Echeance echeance, {required bool large}) {
    if (large) {
      setState(() => _selectionId = echeance.id);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              DetailScreen(store: widget.store, echeanceId: echeance.id),
        ),
      );
    }
  }

  Future<void> _ouvrirFormulaire() async {
    final nouvelle = await Navigator.of(context).push<Echeance>(
      MaterialPageRoute(builder: (_) => FormulaireScreen(store: widget.store)),
    );
    if (nouvelle == null || !mounted) return;
    setState(() {
      _selectionId = nouvelle.id;
      if (_onglet == 1) _onglet = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final store = widget.store;
        final echeances = _filtrer(store.echeances);

        return Scaffold(
          appBar: AppBar(title: const Text('Échéances')),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final large = constraints.maxWidth >= kLargeurTablette;

              final liste = EcheanceListe(
                echeances: echeances,
                selectionId: large ? _selectionId : null,
                onTap: (e) => _ouvrir(e, large: large),
              );
              if (!large) return liste;

              final selection =
                  _selectionId == null ? null : store.parId(_selectionId!);
              return Row(
                children: [
                  SizedBox(width: 360, child: liste),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: selection == null
                        ? const _MessageVide(
                            icone: Icons.touch_app_outlined,
                            texte: 'Sélectionnez une échéance',
                          )
                        : EcheanceDetail(
                            echeance: selection,
                            onBasculer: () => store.basculerFait(selection.id),
                          ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _ouvrirFormulaire,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter'),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _onglet,
            onDestinationSelected: (i) => setState(() => _onglet = i),
            destinations: [
              NavigationDestination(
                icon: _avecCompteur(
                    Icons.pending_actions_outlined, store.nbAFaire),
                selectedIcon:
                    _avecCompteur(Icons.pending_actions, store.nbAFaire),
                label: 'À faire',
              ),
              const NavigationDestination(
                icon: Icon(Icons.task_alt_outlined),
                selectedIcon: Icon(Icons.task_alt),
                label: 'Terminées',
              ),
              const NavigationDestination(
                icon: Icon(Icons.list_alt_outlined),
                selectedIcon: Icon(Icons.list_alt),
                label: 'Toutes',
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _avecCompteur(IconData icone, int nombre) => Badge.count(
        count: nombre,
        isLabelVisible: nombre > 0,
        child: Icon(icone),
      );
}

class EcheanceListe extends StatelessWidget {
  const EcheanceListe({
    super.key,
    required this.echeances,
    required this.onTap,
    this.selectionId,
  });

  final List<Echeance> echeances;
  final ValueChanged<Echeance> onTap;
  final String? selectionId;

  @override
  Widget build(BuildContext context) {
    if (echeances.isEmpty) {
      return const _MessageVide(
        icone: Icons.inbox_outlined,
        texte: 'Aucune échéance ici',
      );
    }

    final scheme = Theme.of(context).colorScheme;
    final loc = MaterialLocalizations.of(context);

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: echeances.length,
      itemBuilder: (context, index) {
        final e = echeances[index];
        return ListTile(
          selected: e.id == selectionId,
          selectedTileColor: scheme.secondaryContainer,
          selectedColor: scheme.onSecondaryContainer,
          leading: CircleAvatar(
            backgroundColor:
                e.fait ? scheme.surfaceContainerHighest : scheme.primaryContainer,
            foregroundColor:
                e.fait ? scheme.onSurfaceVariant : scheme.onPrimaryContainer,
            child: Icon(e.fait ? Icons.check : Icons.event_note),
          ),
          title: Text(
            e.titre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: e.fait
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          subtitle: Text(
            '${e.matiere} · ${loc.formatMediumDate(e.date)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            e.libelleDelai,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: e.enRetard ? scheme.error : null,
            ),
          ),
          onTap: () => onTap(e),
        );
      },
    );
  }
}

class _MessageVide extends StatelessWidget {
  const _MessageVide({required this.icone, required this.texte});

  final IconData icone;
  final String texte;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 48, color: theme.colorScheme.outline),
          const SizedBox(height: 8),
          Text(texte, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
