import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';

import '../../../../core/formats.dart';
import '../../../../core/theme.dart';

/// Une ligne de la liste des échéances : case à cocher, titre, cours et date.
class TacheTile extends StatelessWidget {
  const TacheTile({
    super.key,
    required this.tache,
    required this.onBasculer,
    required this.onOuvrir,
    this.cours,
    this.selectionnee = false,
  });

  final Task tache;
  final Course? cours;
  final VoidCallback onBasculer;
  final VoidCallback onOuvrir;
  final bool selectionnee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sousTitre = [
      ?cours?.intitule,
      formatEcheance(tache.echeance),
    ].join(' · ');

    return Card(
      child: ListTile(
        selected: selectionnee,
        contentPadding: const EdgeInsets.symmetric(horizontal: CampusSpacing.s),
        leading: Checkbox(
          value: tache.terminee,
          onChanged: (_) => onBasculer(),
        ),
        title: Text(
          tache.titre,
          style: tache.terminee
              ? TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : null,
        ),
        subtitle: Text(sousTitre),
        trailing: tache.enRetard ? const BadgeRetard() : null,
        onTap: onOuvrir,
      ),
    );
  }
}

/// Badge rouge « En retard » du design system.
class BadgeRetard extends StatelessWidget {
  const BadgeRetard({super.key});

  @override
  Widget build(BuildContext context) {
    final couleur = Theme.of(context).colorScheme.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: couleur, width: 1.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'En retard',
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: couleur, fontWeight: FontWeight.w700),
      ),
    );
  }
}
