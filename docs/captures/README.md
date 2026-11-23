# Captures

## Séance 3 · package Dart

| Capture | Ce qu'elle montre |
|---|---|
| [`seance3/dart-test.png`](seance3/dart-test.png) | `dart test` : les 3 tests passent |
| [`seance3/dart-test-et-run.png`](seance3/dart-test-et-run.png) | `dart run` : chargement simulé avec `Future.delayed` |

## Séance 7 · application sur l'émulateur Android (API json-server)

Émulateur `Medium_Phone_API_37.0`, API lancée avec `npm run api:auth`, appelée par `10.0.2.2:3000`.

| Capture | Ce qu'elle montre |
|---|---|
| [`01-connexion.png`](seance7/01-connexion.png) | Écran de connexion (logo en asset, thème du design system) |
| [`02-echeances.png`](seance7/02-echeances.png) | Liste chargée depuis l'API (`GET /taches`), filtres, bouton flottant, barre de navigation |
| [`03-detail.png`](seance7/03-detail.png) | Route `/taches/:id` : `Card` et `FilledButton` « Marquer comme fait » |
| [`04-detail-marquee-faite.png`](seance7/04-detail-marquee-faite.png) | Après `PATCH /taches/t2` : le détail se met à jour depuis l'état partagé |
| [`05-formulaire-titre-obligatoire.png`](seance7/05-formulaire-titre-obligatoire.png) | Route `/taches/nouvelle` : le `validator` refuse un titre vide |
| [`07-tache-ajoutee.png`](seance7/07-tache-ajoutee.png) | Après `POST /taches` et redémarrage de l'appli : la tâche est sur le serveur et la session est conservée |
| [`08-filtre-en-retard.png`](seance7/08-filtre-en-retard.png) | Filtre « En retard » (fournisseur dérivé) |
| [`09-filtre-faites.png`](seance7/09-filtre-faites.png) | Filtre « Faites » |
| [`10-cours.png`](seance7/10-cours.png) | Route `/cours` : cours chargés depuis l'API |
| [`11-profil.png`](seance7/11-profil.png) | Route `/profil` : utilisateur connecté, déconnexion |
| [`12-tablette-liste-et-detail.png`](seance7/12-tablette-liste-et-detail.png) | Largeur ≥ 840 dp : rail de navigation, liste et détail côte à côte |
| [`13-erreur-serveur-reessayer.png`](seance7/13-erreur-serveur-reessayer.png) | API arrêtée : état « erreur » avec bouton Réessayer |
| [`14-jeton-expire-401-retour-connexion.png`](seance7/14-jeton-expire-401-retour-connexion.png) | API redémarrée, ancien jeton refusé (401) : retour automatique à `/login` |

Remarque : sur certains émulateurs, le moteur de rendu Impeller peut laisser l'écran blanc. Dans ce cas, lancer l'application avec `flutter run --no-enable-impeller`.
