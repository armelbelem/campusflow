import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Les trois destinations de la barre de navigation.
const _destinations = [
  (
    chemin: '/taches',
    libelle: 'Échéances',
    icone: Icons.event_note_outlined,
    iconeActive: Icons.event_note,
  ),
  (
    chemin: '/cours',
    libelle: 'Cours',
    icone: Icons.school_outlined,
    iconeActive: Icons.school,
  ),
  (
    chemin: '/profil',
    libelle: 'Profil',
    icone: Icons.person_outline,
    iconeActive: Icons.person,
  ),
];

/// Enveloppe des écrans principaux (ShellRoute) : barre de navigation en bas
/// sur téléphone, rail à gauche à partir de 600 dp. Pas de Scaffold ici :
/// chaque écran garde le sien.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.chemin, required this.child});

  final String chemin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final index = _destinations
        .indexWhere((d) => chemin.startsWith(d.chemin))
        .clamp(0, _destinations.length - 1);
    void aller(int i) => context.go(_destinations[i].chemin);

    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Column(
              children: [
                Expanded(child: child),
                NavigationBar(
                  selectedIndex: index,
                  onDestinationSelected: aller,
                  destinations: [
                    for (final d in _destinations)
                      NavigationDestination(
                        icon: Icon(d.icone),
                        selectedIcon: Icon(d.iconeActive),
                        label: d.libelle,
                      ),
                  ],
                ),
              ],
            );
          }
          return Row(
            children: [
              NavigationRail(
                selectedIndex: index,
                onDestinationSelected: aller,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final d in _destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icone),
                      selectedIcon: Icon(d.iconeActive),
                      label: Text(d.libelle),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: child),
            ],
          );
        },
      ),
    );
  }
}
