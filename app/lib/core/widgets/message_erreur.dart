import 'package:flutter/material.dart';

import '../theme.dart';

/// État « erreur » d'un écran : message et bouton Réessayer.
class MessageErreur extends StatelessWidget {
  const MessageErreur({
    super.key,
    required this.message,
    required this.onReessayer,
  });

  final String message;
  final VoidCallback onReessayer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(CampusSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 56, color: theme.colorScheme.error),
            const SizedBox(height: CampusSpacing.m),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: CampusSpacing.m),
            FilledButton.icon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lance une action asynchrone et affiche son erreur éventuelle en SnackBar.
Future<void> avecMessageErreur(
  BuildContext context,
  Future<void> Function() action,
) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await action();
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('$e')));
  }
}
