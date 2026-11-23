import 'package:dio/dio.dart';

/// Erreur d'API traduite en message lisible pour l'utilisateur.
class ApiException implements Exception {
  const ApiException(this.message, {this.statut});

  final String message;
  final int? statut;

  bool get nonAuthentifie => statut == 401;

  factory ApiException.depuis(DioException e) {
    final statut = e.response?.statusCode;
    final message = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        'Le serveur met trop de temps à répondre.',
      DioExceptionType.connectionError => 'Serveur injoignable. Vérifiez votre connexion ou que l’API est lancée.',
      DioExceptionType.badResponse => switch (statut) {
        401 => 'Session expirée : reconnectez-vous.',
        404 => 'Élément introuvable sur le serveur.',
        final s? when s >= 500 => 'Erreur du serveur ($s).',
        _ => 'Requête refusée par le serveur ($statut).',
      },
      _ => 'Erreur réseau inattendue.',
    };
    return ApiException(message, statut: statut);
  }

  @override
  String toString() => message;
}
