import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../auth/application/auth_notifier.dart';

/// Écran Profil : l'utilisateur connecté et la déconnexion.
class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final u = ref.watch(authProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(CampusSpacing.m),
        children: [
          if (u != null) ...[
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
          ],
          const SizedBox(height: CampusSpacing.s),
          const Card(
            child: ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Session'),
              subtitle: Text('Jeton conservé dans le stockage chiffré'),
            ),
          ),
          const SizedBox(height: CampusSpacing.l),
          FilledButton.icon(
            // Le routeur renvoie vers /login dès que la session est vide.
            onPressed: () => ref.read(authProvider.notifier).deconnecter(),
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}
