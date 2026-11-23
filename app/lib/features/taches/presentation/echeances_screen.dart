import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';

import '../data/donnees_demo.dart';
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

  void _basculer(Task tache) {
    setState(() {
      _taches = [
        for (final t in _taches)
          t.id == tache.id ? t.copyWith(terminee: !t.terminee) : t,
      ];
    });
  }

  void _bientot(String quoi) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$quoi : bientôt disponible')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Échéances')),
      body: ListeTaches(
        taches: _taches,
        cours: coursDemo,
        onBasculer: _basculer,
        onOuvrir: (t) => _bientot('Détail'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bientot('Nouvelle tâche'),
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
