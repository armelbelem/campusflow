import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api_exception.dart';
import '../../../core/dio_provider.dart';
import '../../taches/data/donnees_demo.dart';
import '../domain/cours_repository.dart';

/// Lit les cours sur l'API REST.
class ApiCoursRepository implements CoursRepository {
  ApiCoursRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Course>> lister() async {
    try {
      final r = await _dio.get<List<dynamic>>('/cours');
      return [
        for (final j in r.data!) Course.fromJson(j as Map<String, dynamic>),
      ];
    } on DioException catch (e) {
      throw ApiException.depuis(e);
    }
  }
}

/// Cours en mémoire pour les tests.
class FakeCoursRepository implements CoursRepository {
  @override
  Future<List<Course>> lister() async => coursDemo;
}

final coursRepositoryProvider = Provider<CoursRepository>(
  (ref) => ApiCoursRepository(ref.watch(dioProvider)),
);
