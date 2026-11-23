# CampusFlow

Application mobile de suivi des cours, des échéances et des tâches d'un étudiant.

TP de Programmation mobile, Master 1 MSI, année 2026-2027 (enseignant : M. Moctar Compaoré).
Auteur : **Belem Armel**, Master 1 MSI.

Le projet grandit séance par séance : décision de plateforme, conception, modèles Dart, projet Flutter, écrans, navigation et état partagé, puis connexion à une API avec authentification. L'historique des commits suit cet ordre, avec un commit par TP.

## Organisation du dépôt

| Dossier | Contenu |
|---|---|
| [`docs/`](docs) | Livrables de conception (séances 1 et 2), notes d'installation, captures |
| [`campusflow_models/`](campusflow_models) | Package Dart des modèles `Task`, `Course`, `User` (séance 3) |
| [`app/`](app) | Application Flutter CampusFlow (séances 4 à 7) |
| [`server/`](server) | API REST simulée avec json-server, et faux `/login` (séance 7) |

## Livrables par séance

| Séance | Livrables | Où les trouver |
|---|---|---|
| 1 · Écosystème mobile | Fiche comparative des 14 critères pour l'Afrique francophone, autopsie de BlackBerry (3 causes sourcées), décision pour CampusFlow | [`docs/seance1/`](docs/seance1) |
| 2 · UX/UI | Persona et 2 job stories, parcours « suivre mes échéances », 5 wireframes, 3 variantes de l'écran Échéances et choix justifié, design system v1 (contrastes vérifiés) | [`docs/seance2/`](docs/seance2) |
| 3 · Dart | Package `campusflow_models` : `Task`, `Course`, `User` (attributs `final`, `copyWith`, `fromJson`, `toJson`), dépôt simulé avec `Future.delayed`, tests | [`campusflow_models/`](campusflow_models), [`docs/captures/seance3/`](docs/captures/seance3) |
| 4 · Flutter | Installation et `flutter doctor`, `flutter create`, thème centralisé (`ThemeData`), package `intl` et logo en asset | [`docs/seance4/`](docs/seance4), [`app/lib/core/theme.dart`](app/lib/core/theme.dart) |
| 5 · Écrans | Échéances (`ListView.builder`, bouton flottant, `NavigationBar`), Détail (`Card`, `FilledButton`), Formulaire (`Form`, `validator`, `SnackBar`, défilant), tablette à 840 dp (`LayoutBuilder`) | [`app/lib/features/taches/presentation/`](app/lib/features/taches/presentation) |
| 6 · Navigation et état | `go_router` (`/login`, `/taches`, `/taches/nouvelle`, `/taches/:id`, `/cours`, `/profil`, `ShellRoute`), Riverpod (`TachesNotifier`, état immuable, `watch` / `read`), filtres à faire / faites / en retard | [`app/lib/core/router.dart`](app/lib/core/router.dart), [`app/lib/features/taches/application/`](app/lib/features/taches/application) |
| 7 · API et architecture | json-server, Dio dans `core`, contrat `TaskRepository` avec `ApiTaskRepository` et `FakeTaskRepository`, `AsyncNotifier` (chargement, erreur + Réessayer, données), POST / PATCH / DELETE, connexion avec jeton en stockage sécurisé, intercepteur, redirection sur 401 | [`server/`](server), [`app/lib/`](app/lib) |

## Lancer le projet

Prérequis : Flutter 3.47 (Dart 3.13) et Node.js 22.

**1. L'API simulée**

```bash
cd server
npm install
npm run api:auth
```

L'API écoute sur `http://localhost:3000`. Toutes les routes demandent un jeton, sauf `POST /login`.
Pour voir le JSON brut dans le navigateur (sans connexion), lancer plutôt `npm run api` puis ouvrir <http://localhost:3000/taches>.

**2. L'application**

```bash
cd app
flutter pub get
flutter run
```

Sur l'émulateur Android, l'application appelle l'API par `10.0.2.2:3000`. Sur le web ou le bureau, elle utilise `localhost:3000`. Une autre adresse peut être donnée avec `--dart-define=API_URL=http://192.168.1.10:3000`.

**Compte de démonstration** : `ibrahim.sawadogo@campus.bf`, mot de passe `campus2026`. Ce compte n'existe que dans l'API simulée.

## Tests

| Projet | Commande | Résultat |
|---|---|---|
| `campusflow_models` | `dart test` | 4 tests : `copyWith`, `fromJson`, erreur attendue, aller-retour `toJson` |
| `app` | `flutter test` | 20 tests : écrans, routes, filtres, état Riverpod, repository Dio, intercepteur et 401, connexion |

Les tests de l'application n'utilisent pas le réseau : les repositories sont remplacés par `FakeTaskRepository` et `FakeCoursRepository`.

## Architecture de l'application

```text
app/lib/
├── main.dart                      ProviderScope, MaterialApp.router
├── core/                          partagé : thème, routes, Dio, session, erreurs
└── features/
    ├── accueil/                   écran de titre (démarrage)
    ├── auth/                      connexion : data, application, presentation
    ├── cours/                     cours : domain, data, presentation
    ├── profil/                    profil et déconnexion
    └── taches/
        ├── domain/                contrat TaskRepository
        ├── data/                  ApiTaskRepository (Dio), FakeTaskRepository
        ├── application/           TachesNotifier (AsyncNotifier), filtres
        └── presentation/          Échéances, Détail, Formulaire
```

## Captures

Les captures de l'application sur l'émulateur Android sont dans [`docs/captures/`](docs/captures).
