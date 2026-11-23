import 'dart:convert';
import 'dart:typed_data';

import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campusflow/core/api_exception.dart';
import 'package:campusflow/features/taches/data/api_task_repository.dart';

/// Faux serveur HTTP : enregistre les requêtes et renvoie une réponse fixée.
class ServeurSimule implements HttpClientAdapter {
  ServeurSimule(this.repondre);

  final (int, Object?) Function(RequestOptions options) repondre;
  final requetes = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requetes.add(options);
    final (statut, corps) = repondre(options);
    return ResponseBody.fromString(
      jsonEncode(corps),
      statut,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiTaskRepository repository(ServeurSimule serveur) {
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..httpClientAdapter = serveur;
  return ApiTaskRepository(dio);
}

const tacheJson = {
  'id': 't1',
  'titre': 'TP Dart',
  'echeance': '2026-11-24T18:00:00',
  'terminee': false,
  'description': null,
  'coursId': 'c1',
};

void main() {
  test('lister : GET /taches et conversion du JSON en Task', () async {
    final serveur = ServeurSimule((_) => (200, [tacheJson]));

    final taches = await repository(serveur).lister();

    expect(serveur.requetes.single.method, 'GET');
    expect(serveur.requetes.single.path, '/taches');
    expect(taches.single.titre, 'TP Dart');
    expect(taches.single.echeance, DateTime(2026, 11, 24, 18));
  });

  test('basculer : PATCH /taches/:id avec {"terminee": true}', () async {
    final serveur = ServeurSimule(
      (_) => (200, {...tacheJson, 'terminee': true}),
    );
    final tache = Task.fromJson(tacheJson);

    final maj = await repository(serveur).basculer(tache);

    expect(serveur.requetes.single.method, 'PATCH');
    expect(serveur.requetes.single.path, '/taches/t1');
    expect(serveur.requetes.single.data, {'terminee': true});
    expect(maj.terminee, isTrue);
  });

  test('ajouter : POST /taches, puis supprimer : DELETE /taches/:id', () async {
    final serveur = ServeurSimule(
      (o) => (o.method == 'POST' ? 201 : 200, tacheJson),
    );
    final repo = repository(serveur);

    await repo.ajouter(Task.fromJson(tacheJson));
    await repo.supprimer('t1');

    expect(serveur.requetes.map((r) => r.method), ['POST', 'DELETE']);
    expect(serveur.requetes.last.path, '/taches/t1');
  });

  test(
    'une réponse 401 devient une ApiException « non authentifié »',
    () async {
      final serveur = ServeurSimule((_) => (401, {'message': 'Jeton absent'}));

      expect(
        repository(serveur).lister(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.nonAuthentifie,
            'nonAuthentifie',
            isTrue,
          ),
        ),
      );
    },
  );
}
