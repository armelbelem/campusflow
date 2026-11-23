import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// Écran de titre de CampusFlow (séance 4).
class TitreScreen extends StatelessWidget {
  const TitreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(CampusSpacing.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_available,
                  size: 96,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: CampusSpacing.m),
                Text('CampusFlow', style: theme.textTheme.headlineMedium),
                const SizedBox(height: CampusSpacing.s),
                Text(
                  'Ne ratez plus aucun rendu',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
