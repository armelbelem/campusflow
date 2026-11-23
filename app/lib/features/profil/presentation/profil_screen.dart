import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';

/// Utilisateur de démonstration : le persona de la séance 2.
final _utilisateurDemo = User(
  id: 'u1',
  nom: 'Ibrahim Sawadogo',
  email: 'ibrahim.sawadogo@campus.bf',
  coursIds: const ['c1', 'c2', 'c3'],
);

/// Écran Profil : compte et déconnexion.
class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final u = _utilisateurDemo;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(CampusSpacing.m),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                child: Text(u.nom.substring(0, 1)),
              ),
              title: Text(u.nom),
              subtitle: Text(u.email),
            ),
          ),
          const SizedBox(height: CampusSpacing.s),
          Card(
            child: ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text('Cours suivis'),
              trailing: Text('${u.coursIds.length}'),
            ),
          ),
          const SizedBox(height: CampusSpacing.l),
          FilledButton.icon(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}
