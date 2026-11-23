import 'package:campusflow_models/campusflow_models.dart';

Future<void> main(List<String> arguments) async {
  const repo = FakeCampusRepository();

  print('Chargement...');
  try {
    final utilisateur = await repo.chargerUtilisateur();
    final cours = await repo.chargerCours();
    final taches = await repo.chargerTaches();

    print(
      'Bonjour ${utilisateur.nom} : ${cours.length} cours, '
      '${taches.length} tâche(s)',
    );
    for (final tache in taches) {
      print('- $tache');
    }

    final faite = taches.first.copyWith(terminee: true);
    print('Après copyWith : $faite');
  } catch (e) {
    print('Erreur : $e');
  } finally {
    print('Fin du chargement');
  }
}
