import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:campusflow/core/router.dart';
import 'package:campusflow/core/session_storage.dart';
import 'package:campusflow/features/accueil/titre_screen.dart';
import 'package:campusflow/features/auth/data/auth_repository.dart';
import 'package:campusflow/features/cours/data/api_cours_repository.dart';
import 'package:campusflow/features/taches/data/api_task_repository.dart';
import 'package:campusflow/features/taches/data/fake_task_repository.dart';
import 'package:campusflow/main.dart';

/// Simule un téléphone de 360 × 780 dp.
void telephone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// Session déjà ouverte (par défaut, l'utilisateur est connecté).
MemoireSessionStorage sessionOuverte() => MemoireSessionStorage(
  jeton: 'jeton-de-test',
  utilisateur: User(
    id: 'u1',
    nom: 'Ibrahim Sawadogo',
    email: 'ibrahim.sawadogo@campus.bf',
    coursIds: const ['c1', 'c2', 'c3'],
  ),
);

/// Lance l'application avec des repositories en mémoire : aucun réseau.
Future<ProviderContainer> lancer(
  WidgetTester tester, {
  FakeTaskRepository? taches,
  SessionStorage? session,
}) async {
  final container = ProviderContainer(
    overrides: [
      taskRepositoryProvider.overrideWithValue(taches ?? FakeTaskRepository()),
      coursRepositoryProvider.overrideWithValue(FakeCoursRepository()),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      sessionStorageProvider.overrideWithValue(session ?? sessionOuverte()),
    ],
    retry: (_, _) => null,
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const CampusFlowApp(),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets("L'écran de titre affiche le logo et le nom de l'application", (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TitreScreen()));

    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Échéances : liste, case à cocher et barre de navigation', (
    tester,
  ) async {
    telephone(tester);
    await lancer(tester);

    expect(find.text('Rapport SQL'), findsOneWidget);
    expect(find.text('En retard'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    // Cocher la tâche en retard la fait sortir du filtre « À faire ».
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(find.text('Rapport SQL'), findsNothing);
    expect(find.text('En retard'), findsNothing);
  });

  testWidgets('Serveur en panne : message, puis Réessayer recharge la liste', (
    tester,
  ) async {
    telephone(tester);
    final repo = FakeTaskRepository(echec: true);
    await lancer(tester, taches: repo);

    expect(find.text('Serveur injoignable (simulation).'), findsOneWidget);
    expect(find.text('Rapport SQL'), findsNothing);

    repo.echec = false;
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();
    expect(find.text('Rapport SQL'), findsOneWidget);
  });

  testWidgets('Filtres : à faire, faites, en retard', (tester) async {
    telephone(tester);
    await lancer(tester);

    expect(find.text('À faire (4)'), findsOneWidget);
    expect(find.text('QCM séances 1, 2 et 4'), findsNothing);

    await tester.tap(find.text('Faites (1)'));
    await tester.pumpAndSettle();
    expect(find.text('QCM séances 1, 2 et 4'), findsOneWidget);
    expect(find.text('Rapport SQL'), findsNothing);

    await tester.tap(find.text('En retard (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Rapport SQL'), findsOneWidget);
    expect(find.text('TP Dart : modèles et tests'), findsNothing);
  });

  testWidgets('Routes : chaque écran est atteignable par son adresse', (
    tester,
  ) async {
    telephone(tester);
    final container = await lancer(tester);
    final router = container.read(routerProvider);

    router.go('/cours');
    await tester.pumpAndSettle();
    expect(find.text('Programmation mobile'), findsOneWidget);

    router.go('/profil');
    await tester.pumpAndSettle();
    expect(find.text('Se déconnecter'), findsOneWidget);

    router.go('/taches/t3');
    await tester.pumpAndSettle();
    expect(find.text('Rapport SQL'), findsOneWidget);
    expect(find.text('Marquer comme fait'), findsOneWidget);

    // Déjà connecté : /login renvoie vers les échéances.
    router.go('/login');
    await tester.pumpAndSettle();
    expect(find.text('Se connecter'), findsNothing);
    expect(router.state.matchedLocation, '/taches');
  });

  testWidgets('Connexion : sans session, /login, erreur, puis succès', (
    tester,
  ) async {
    telephone(tester);
    final session = MemoireSessionStorage();
    await lancer(tester, session: session);

    expect(find.text('Se connecter'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'ibrahim.sawadogo@campus.bf',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'mauvais');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();
    expect(find.text('E-mail ou mot de passe incorrect.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'campus2026');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();
    expect(find.text('Rapport SQL'), findsOneWidget);
    // Le jeton est rangé dans le stockage de session.
    expect(session.jeton, 'jeton-de-test');
  });

  testWidgets('Déconnexion : retour à l’écran de connexion', (tester) async {
    telephone(tester);
    final session = sessionOuverte();
    final container = await lancer(tester, session: session);

    container.read(routerProvider).go('/profil');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Se déconnecter'));
    await tester.pumpAndSettle();

    expect(find.text('Se connecter'), findsOneWidget);
    expect(session.jeton, isNull);
  });

  testWidgets('Détail : « Marquer comme fait » coche la tâche', (tester) async {
    telephone(tester);
    await lancer(tester);

    await tester.tap(find.text('TP Dart : modèles et tests'));
    await tester.pumpAndSettle();
    expect(find.text('Marquer comme fait'), findsOneWidget);

    await tester.tap(find.text('Marquer comme fait'));
    await tester.pumpAndSettle();
    // Le détail lit l'état partagé : il se met à jour sur place.
    expect(find.text('Remettre à faire'), findsOneWidget);

    // De retour sur la liste, la tâche est passée dans « Faites ».
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('TP Dart : modèles et tests'), findsNothing);
    await tester.tap(find.text('Faites (2)'));
    await tester.pumpAndSettle();
    expect(find.text('TP Dart : modèles et tests'), findsOneWidget);
  });

  testWidgets('Formulaire : titre obligatoire, puis ajout et SnackBar', (
    tester,
  ) async {
    telephone(tester);
    await lancer(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    expect(find.text('Le titre est obligatoire'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'Fiche de lecture',
    );
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(find.text('Tâche « Fiche de lecture » ajoutée'), findsOneWidget);
    expect(find.text('Fiche de lecture'), findsOneWidget);
  });

  testWidgets('Tablette (≥ 840 dp) : liste et détail côte à côte', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await lancer(tester);

    expect(find.text('Sélectionnez une tâche dans la liste.'), findsOneWidget);
    expect(find.byType(NavigationRail), findsOneWidget);

    await tester.tap(find.text('Rapport SQL'));
    await tester.pumpAndSettle();
    // Le détail s'affiche à droite, sans changer d'écran.
    expect(find.text('Marquer comme fait'), findsOneWidget);
  });
}
