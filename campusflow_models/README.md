# campusflow_models

Modèles de données de CampusFlow en Dart pur (séance 3, atelier).

- `lib/src/models/` : `Task`, `Course`, `User` (attributs `final`, constructeur, `copyWith`, `fromJson`)
- `lib/src/data/campus_repository.dart` : contrat `CampusRepository` et dépôt simulé `FakeCampusRepository` (`Future.delayed`)
- `test/` : trois tests (copyWith, fromJson, erreur attendue)

```bash
dart run    # charge les données simulées
dart test   # lance les tests
```
