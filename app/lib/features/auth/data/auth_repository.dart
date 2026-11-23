import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api_exception.dart';
import '../../../core/dio_provider.dart';

/// Connexion : identifiants envoyés au serveur, jeton signé en retour.
abstract class AuthRepository {
  Future<({String jeton, User utilisateur})> connecter(
    String email,
    String motDePasse,
  );
}

/// POST /login sur l'API simulée.
class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._dio);

  final Dio _dio;

  @override
  Future<({String jeton, User utilisateur})> connecter(
    String email,
    String motDePasse,
  ) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(
        '/login',
        data: {'email': email, 'motDePasse': motDePasse},
      );
      final corps = r.data!;
      return (
        jeton: corps['jeton'] as String,
        utilisateur: User.fromJson(
          corps['utilisateur'] as Map<String, dynamic>,
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ApiException(
          'E-mail ou mot de passe incorrect.',
          statut: 401,
        );
      }
      throw ApiException.depuis(e);
    }
  }
}

/// Connexion simulée, pour les tests.
class FakeAuthRepository implements AuthRepository {
  @override
  Future<({String jeton, User utilisateur})> connecter(
    String email,
    String motDePasse,
  ) async {
    if (motDePasse != 'campus2026') {
      throw const ApiException(
        'E-mail ou mot de passe incorrect.',
        statut: 401,
      );
    }
    return (
      jeton: 'jeton-de-test',
      utilisateur: User(id: 'u1', nom: 'Ibrahim Sawadogo', email: email),
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => ApiAuthRepository(ref.watch(dioProvider)),
);
