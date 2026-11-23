import 'package:campusflow_models/campusflow_models.dart';

/// Le contrat d'accès aux tâches : ce que l'on peut demander, pas comment.
/// Les écrans et l'état ne connaissent que ce contrat, jamais Dio.
abstract class TaskRepository {
  Future<List<Task>> lister();
  Future<Task> ajouter(Task tache);

  /// Coche ou décoche la tâche et renvoie la version enregistrée.
  Future<Task> basculer(Task tache);
  Future<void> supprimer(String id);
}
