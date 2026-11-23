import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/accueil/titre_screen.dart';
import '../features/auth/application/auth_notifier.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/cours/presentation/cours_screen.dart';
import '../features/profil/presentation/profil_screen.dart';
import '../features/taches/presentation/detail_tache_screen.dart';
import '../features/taches/presentation/echeances_screen.dart';
import '../features/taches/presentation/formulaire_tache_screen.dart';
import 'app_shell.dart';

/// Les adresses de CampusFlow. Chaque écran est atteignable par son chemin ;
/// sans session, toute adresse redirige vers /login.
final routerProvider = Provider<GoRouter>((ref) {
  final racine = GlobalKey<NavigatorState>(debugLabel: 'racine');

  // Le routeur réévalue ses redirections à chaque changement de session
  // (connexion, déconnexion, jeton expiré).
  final session = ValueNotifier(0);
  ref.listen(authProvider, (_, _) => session.value++);
  ref.onDispose(session.dispose);

  return GoRouter(
    navigatorKey: racine,
    initialLocation: '/taches',
    refreshListenable: session,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final ici = state.matchedLocation;
      if (!auth.hasValue && !auth.hasError) {
        // Lecture de la session au démarrage : écran de titre.
        return ici == '/demarrage' ? null : '/demarrage';
      }
      final connecte = auth.value != null;
      if (!connecte) return ici == '/login' ? null : '/login';
      if (ici == '/login' || ici == '/demarrage') return '/taches';
      return null;
    },
    routes: [
      GoRoute(path: '/demarrage', builder: (_, _) => const TitreScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      // La barre de navigation entoure les trois destinations principales.
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(chemin: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/taches',
            builder: (_, _) => const EcheancesScreen(),
            routes: [
              // « nouvelle » est déclarée avant « :id », sinon elle serait
              // lue comme un identifiant.
              GoRoute(
                path: 'nouvelle',
                parentNavigatorKey: racine,
                builder: (_, _) => const NouvelleTachePage(),
              ),
              GoRoute(
                path: ':id',
                parentNavigatorKey: racine,
                builder: (_, state) =>
                    DetailTachePage(id: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(path: '/cours', builder: (_, _) => const CoursScreen()),
          GoRoute(path: '/profil', builder: (_, _) => const ProfilScreen()),
        ],
      ),
    ],
  );
});
