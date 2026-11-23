import 'dart:convert';

import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Où l'on range la session : le jeton n'est jamais stocké en clair.
abstract class SessionStorage {
  Future<String?> lireJeton();
  Future<User?> lireUtilisateur();
  Future<void> enregistrer(String jeton, User utilisateur);
  Future<void> effacer();
}

/// Stockage chiffré : Keystore sur Android, Keychain sur iOS.
class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage([FlutterSecureStorage? stockage])
    : _stockage = stockage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _stockage;
  static const _cleJeton = 'jeton';
  static const _cleUtilisateur = 'utilisateur';

  @override
  Future<String?> lireJeton() => _stockage.read(key: _cleJeton);

  @override
  Future<User?> lireUtilisateur() async {
    final texte = await _stockage.read(key: _cleUtilisateur);
    if (texte == null) return null;
    return User.fromJson(jsonDecode(texte) as Map<String, dynamic>);
  }

  @override
  Future<void> enregistrer(String jeton, User utilisateur) async {
    await _stockage.write(key: _cleJeton, value: jeton);
    await _stockage.write(
      key: _cleUtilisateur,
      value: jsonEncode(utilisateur.toJson()),
    );
  }

  @override
  Future<void> effacer() async {
    await _stockage.delete(key: _cleJeton);
    await _stockage.delete(key: _cleUtilisateur);
  }
}

/// Session en mémoire, pour les tests.
class MemoireSessionStorage implements SessionStorage {
  MemoireSessionStorage({this.jeton, this.utilisateur});

  String? jeton;
  User? utilisateur;

  @override
  Future<String?> lireJeton() async => jeton;

  @override
  Future<User?> lireUtilisateur() async => utilisateur;

  @override
  Future<void> enregistrer(String jeton, User utilisateur) async {
    this.jeton = jeton;
    this.utilisateur = utilisateur;
  }

  @override
  Future<void> effacer() async {
    jeton = null;
    utilisateur = null;
  }
}

final sessionStorageProvider = Provider<SessionStorage>(
  (ref) => SecureSessionStorage(),
);
