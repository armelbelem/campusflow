import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/cours/presentation/cours_screen.dart';
import '../features/profil/presentation/profil_screen.dart';
import '../features/taches/data/donnees_demo.dart';
import '../features/taches/presentation/detail_tache_screen.dart';
import '../features/taches/presentation/echeances_screen.dart';
import '../features/taches/presentation/formulaire_tache_screen.dart';
import 'app_shell.dart';

final _racine = GlobalKey<NavigatorState>(debugLabel: 'racine');

/// Les adresses de CampusFlow. Chaque écran est atteignable par son chemin.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _racine,
    initialLocation: '/taches',
    routes: [
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
                parentNavigatorKey: _racine,
                builder: (_, _) => FormulaireTacheScreen(
                  cours: coursDemo,
                  onEnregistrer: (_) async {},
                ),
              ),
              GoRoute(
                path: ':id',
                parentNavigatorKey: _racine,
                builder: (_, state) => DetailTachePage(
                  id: state.pathParameters['id']!,
                  initiale: state.extra as Task?,
                ),
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
