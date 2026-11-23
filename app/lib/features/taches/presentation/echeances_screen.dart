import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';

import '../data/donnees_demo.dart';
import 'detail_tache_screen.dart';
import 'formulaire_tache_screen.dart';
import 'widgets/liste_taches.dart';

/// Écran Échéances (séance 5) : la liste vit dans l'écran, gérée par setState.
class EcheancesScreen extends StatefulWidget {
  const EcheancesScreen({super.key});

  @override
  State<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends State<EcheancesScreen> {
  var _taches = tachesDemo();
  var _onglet = 0;
  String? _idSelectionne;

  void _basculer(Task tache) {
    setState(() {
      _taches = [
        for (final t in _taches)
          t.id == tache.id ? t.copyWith(terminee: !t.terminee) : t,
      ];
    });
  }

  void _ouvrir(Task tache) {
    final cours = coursDemo.where((c) => c.id == tache.coursId).firstOrNull;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => DetailTacheScreen(
          tache: tache,
          cours: cours,
          onMarquerFait: () {
            _basculer(tache);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _nouvelleTache() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => FormulaireTacheScreen(
          cours: coursDemo,
          onEnregistrer: (tache) async {
            setState(() {
              _taches = [..._taches, tache]
                ..sort((a, b) => a.echeance.compareTo(b.echeance));
            });
          },
        ),
      ),
    );
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (i) => setState(() => _onglet = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Échéances',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
