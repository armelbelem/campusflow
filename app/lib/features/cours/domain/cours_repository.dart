import 'package:campusflow_models/campusflow_models.dart';

/// Contrat d'accès aux cours.
abstract class CoursRepository {
  Future<List<Course>> lister();
}
