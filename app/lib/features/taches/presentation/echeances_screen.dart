import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/donnees_demo.dart';
import 'detail_tache_screen.dart';
import 'widgets/liste_taches.dart';

/// Écran Échéances. La liste vit encore dans l'écran (setState) : le détail
/// et le formulaire lui renvoient leur résultat par la navigation.
class EcheancesScreen extends StatefulWidget {
  const EcheancesScreen({super.key});

  @override
  State<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends State<EcheancesScreen> {
  var _taches = tachesDemo();
  String? _idSelectionne;

  void _basculer(Task tache) {
    setState(() {
      _taches = [
        for (final t in _taches)
          t.id == tache.id ? t.copyWith(terminee: !t.terminee) : t,
      ];
    });
  }

  Future<void> _ouvrir(Task tache) async {
    final fait = await context.push<bool>('/taches/${tache.id}', extra: tache);
    if (fait ?? false) _basculer(tache);
  }

  Future<void> _nouvelleTache() async {
    final tache = await context.push<Task>('/taches/nouvelle');
    if (tache == null) return;
    setState(() {
      _taches = [..._taches, tache]
        ..sort((a, b) => a.echeance.compareTo(b.echeance));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Échéances')),
      // Seuil de 840 dp : liste seule en dessous, liste et détail au-dessus.
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 840) {
            return ListeTaches(
              taches: _taches,
              cours: coursDemo,
              onBasculer: _basculer,
              onOuvrir: _ouvrir,
            );
          }
          final selection = _taches
              .where((t) => t.id == _idSelectionne)
              .firstOrNull;
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: ListeTaches(
                  taches: _taches,
                  cours: coursDemo,
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
                        cours: coursDemo
                            .where((c) => c.id == selection.coursId)
                            .firstOrNull,
                        onMarquerFait: () => _basculer(selection),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nouvelleTache,
        tooltip: 'Nouvelle tâche',
        child: const Icon(Icons.add),
      ),
    );
  }
}
