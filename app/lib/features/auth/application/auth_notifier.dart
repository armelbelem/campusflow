import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session_storage.dart';
import '../data/auth_repository.dart';

/// L'utilisateur connecté, ou `null`. Au démarrage, la session est relue
/// dans le stockage chiffré.
class AuthNotifier extends AsyncNotifier<User?> {
  SessionStorage get _session => ref.read(sessionStorageProvider);

  @override
  Future<User?> build() async {
    final session = ref.watch(sessionStorageProvider);
    if (await session.lireJeton() == null) return null;
    return session.lireUtilisateur();
  }

  /// Lance une ApiException si les identifiants sont refusés.
  Future<void> connecter(String email, String motDePasse) async {
    final r = await ref
        .read(authRepositoryProvider)
        .connecter(email, motDePasse);
    await _session.enregistrer(r.jeton, r.utilisateur);
    state = AsyncData(r.utilisateur);
  }

  Future<void> deconnecter() async {
    await _session.effacer();
    state = const AsyncData(null);
  }

  /// Appelé par l'intercepteur quand le serveur répond 401.
  Future<void> sessionExpiree() async {
    if (state.value == null) return;
    await deconnecter();
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);
