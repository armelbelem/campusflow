import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme.dart';

/// Écran de titre de CampusFlow (séance 4).
class TitreScreen extends StatelessWidget {
  const TitreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aujourdhui = DateFormat(
      'EEEE d MMMM',
      'fr_FR',
    ).format(DateTime.now());
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(CampusSpacing.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  semanticLabel: 'Logo CampusFlow',
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
                const SizedBox(height: CampusSpacing.l),
                Text(
                  'Nous sommes le $aujourdhui',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
