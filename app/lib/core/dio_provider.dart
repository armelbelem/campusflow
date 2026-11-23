import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Adresse de l'API. Sur l'émulateur Android, la machine hôte s'appelle
/// 10.0.2.2 et non localhost. On peut forcer une autre adresse avec
/// `flutter run --dart-define=API_URL=http://192.168.1.10:3000`.
String urlApi() {
  const forcee = String.fromEnvironment('API_URL');
  if (forcee.isNotEmpty) return forcee;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:3000';
  }
  return 'http://localhost:3000';
}

/// Le client HTTP, configuré une seule fois pour toute l'application.
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: urlApi(),
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
    ),
  );
});
