import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api_exception.dart';
import '../../../core/dio_provider.dart';
import '../domain/task_repository.dart';

/// Implémentation qui parle à l'API REST (json-server) avec Dio.
class ApiTaskRepository implements TaskRepository {
  ApiTaskRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Task>> lister() => _appel(() async {
    final r = await _dio.get<List<dynamic>>('/taches');
    return [for (final j in r.data!) Task.fromJson(j as Map<String, dynamic>)];
  });

  @override
  Future<Task> ajouter(Task tache) => _appel(() async {
    final r = await _dio.post<Map<String, dynamic>>(
      '/taches',
      data: tache.toJson(),
    );
    return Task.fromJson(r.data!);
  });

  @override
  Future<Task> basculer(Task tache) => _appel(() async {
    final r = await _dio.patch<Map<String, dynamic>>(
      '/taches/${tache.id}',
      data: {'terminee': !tache.terminee},
    );
    return Task.fromJson(r.data!);
  });

  @override
  Future<void> supprimer(String id) =>
      _appel(() => _dio.delete<void>('/taches/$id'));

  /// Traduit les erreurs Dio en ApiException lisible.
  Future<T> _appel<T>(Future<T> Function() requete) async {
    try {
      return await requete();
    } on DioException catch (e) {
      throw ApiException.depuis(e);
    }
  }
}

/// Le repository utilisé par l'application. Remplacé par un Fake en test.
final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => ApiTaskRepository(ref.watch(dioProvider)),
);
