import 'dart:convert';

import '../models/course.dart';
import '../models/task.dart';
import '../models/user.dart';

/// Contrat d'accès aux données. Une vraie API l'implémentera plus tard.
abstract class CampusRepository {
  Future<User> chargerUtilisateur();
  Future<List<Course>> chargerCours();
  Future<List<Task>> chargerTaches();
}

/// Dépôt simulé : renvoie du JSON écrit en dur après un délai, comme un serveur.
class FakeCampusRepository implements CampusRepository {
  /// Durée de la fausse requête réseau.
  final Duration delai;

  /// Si `true`, chaque appel échoue comme si le réseau était coupé.
  final bool echec;

  const FakeCampusRepository({
    this.delai = const Duration(seconds: 1),
    this.echec = false,
  });

  @override
  Future<User> chargerUtilisateur() async {
    final json = await _appeler(_utilisateurJson) as Map<String, dynamic>;
    return User.fromJson(json);
  }

  @override
  Future<List<Course>> chargerCours() async {
    final json = await _appeler(_coursJson) as List<dynamic>;
    return json.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Task>> chargerTaches() async {
    final json = await _appeler(_tachesJson) as List<dynamic>;
    return json.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<dynamic> _appeler(String reponse) async {
    await Future.delayed(delai);
    if (echec) {
      throw Exception('Réseau indisponible');
    }
    return jsonDecode(reponse);
  }
}

const _utilisateurJson = '''
{
  "id": "u1",
  "nom": "Awa Ouédraogo",
  "email": "awa.ouedraogo@campus.bf",
  "coursIds": ["c1", "c2"]
}
''';

const _coursJson = '''
[
  {"id": "c1", "intitule": "Programmation mobile", "enseignant": "M. Sawadogo", "credits": 4, "salle": "B12"},
  {"id": "c2", "intitule": "Bases de données", "enseignant": "Mme Kaboré", "credits": 3}
]
''';

const _tachesJson = '''
[
  {"id": "t1", "titre": "TP Dart", "echeance": "2026-11-03T18:00:00", "coursId": "c1"},
  {"id": "t2", "titre": "Projet CampusFlow", "echeance": "2026-12-15T23:59:00", "coursId": "c1", "description": "Maquettes et modèles"},
  {"id": "t3", "titre": "QCM SQL", "echeance": "2026-10-20T10:00:00", "coursId": "c2", "terminee": true}
]
''';
