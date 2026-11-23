import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../taches/data/donnees_demo.dart';

/// Écran Cours : la liste des cours suivis.
class CoursScreen extends StatelessWidget {
  const CoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cours')),
      body: ListView.builder(
        padding: const EdgeInsets.all(CampusSpacing.m),
        itemCount: coursDemo.length,
        itemBuilder: (context, i) {
          final c = coursDemo[i];
          final details = [
            c.enseignant,
            '${c.credits} crédits',
            if (c.salle case final salle?) 'salle $salle',
          ].join(' · ');
          return Padding(
            padding: const EdgeInsets.only(bottom: CampusSpacing.s),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(c.intitule),
                subtitle: Text(details),
              ),
            ),
          );
        },
      ),
    );
  }
}
