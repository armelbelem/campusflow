import 'dart:convert';
import 'dart:typed_data';

import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campusflow/core/dio_provider.dart';
import 'package:campusflow/core/session_storage.dart';
import 'package:campusflow/features/auth/application/auth_notifier.dart';

/// Faux serveur : répond toujours avec le même statut.
class Serveur implements HttpClientAdapter {
  Serveur(this.statut);

  final int statut;
  final requetes = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requetes.add(options);
    return ResponseBody.fromString(
      jsonEncode(statut == 200 ? [] : {'message': 'Jeton absent ou expiré.'}),
      statut,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<(ProviderContainer, MemoireSessionStorage)> conteneur() async {
  final session = MemoireSessionStorage(
    jeton: 'abc123',
    utilisateur: User(id: 'u1', nom: 'Ibrahim', email: 'i@campus.bf'),
  );
  final c = ProviderContainer(
    overrides: [sessionStorageProvider.overrideWithValue(session)],
    retry: (_, _) => null,
  );
  addTearDown(c.dispose);
  await c.read(authProvider.future);
  return (c, session);
}

void main() {
  test("l'intercepteur ajoute « Authorization: Bearer <jeton> »", () async {
    final (c, _) = await conteneur();
    final serveur = Serveur(200);
    final dio = c.read(dioProvider)..httpClientAdapter = serveur;

    await dio.get<List<dynamic>>('/taches');

    expect(serveur.requetes.single.headers['Authorization'], 'Bearer abc123');
  });

  test('une réponse 401 efface la session et déconnecte', () async {
    final (c, session) = await conteneur();
    final dio = c.read(dioProvider)..httpClientAdapter = Serveur(401);

    await expectLater(dio.get<void>('/taches'), throwsA(isA<DioException>()));

    expect(session.jeton, isNull);
    expect(c.read(authProvider).value, isNull);
  });
}
