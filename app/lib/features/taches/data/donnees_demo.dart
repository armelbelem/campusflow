import 'package:campusflow_models/campusflow_models.dart';

/// Données de démonstration locales. Elles seront remplacées par l'API à la
/// séance 7. Les dates sont relatives à aujourd'hui pour que les filtres
/// « en retard » et « à faire » aient toujours un contenu.
const coursDemo = [
  Course(
    id: 'c1',
    intitule: 'Programmation mobile',
    enseignant: 'M. Compaoré',
    credits: 4,
    salle: 'B12',
  ),
  Course(
    id: 'c2',
    intitule: 'Bases de données',
    enseignant: 'Mme Kaboré',
    credits: 3,
  ),
  Course(
    id: 'c3',
    intitule: 'Réseaux',
    enseignant: 'M. Ouédraogo',
    credits: 3,
    salle: 'A04',
  ),
];

List<Task> tachesDemo() {
  final now = DateTime.now();
  DateTime jour(int decalage, int heure) =>
      DateTime(now.year, now.month, now.day + decalage, heure);

  return [
    Task(
      id: 't1',
      titre: 'TP Dart : modèles et tests',
      echeance: jour(1, 18),
      coursId: 'c1',
      description: 'Task, Course, User avec fromJson et trois tests.',
    ),
    Task(
      id: 't2',
      titre: 'Projet Flutter : les trois écrans',
      echeance: jour(4, 17),
      coursId: 'c1',
    ),
    Task(
      id: 't3',
      titre: 'Rapport SQL',
      echeance: jour(-2, 23),
      coursId: 'c2',
      description: 'Modèle relationnel et requêtes de la base Scolarité.',
    ),
    Task(
      id: 't4',
      titre: 'Exposé sur le routage IP',
      echeance: jour(9, 10),
      coursId: 'c3',
    ),
    Task(
      id: 't5',
      titre: 'QCM séances 1, 2 et 4',
      echeance: jour(-5, 10),
      coursId: 'c1',
      terminee: true,
    ),
  ]..sort((a, b) => a.echeance.compareTo(b.echeance));
}
