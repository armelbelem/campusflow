# Séance 1 · Fiche comparative Android / iOS

**Cas réel étudié :** une application étudiante (CampusFlow) destinée aux universités d'Afrique francophone.

## Le contexte en chiffres

| Mesure | Android | iOS | Source |
|---|---|---|---|
| Monde, septembre 2026 | 69,17 % | 30,81 % | StatCounter Global Stats, part des pages web vues sur mobile |
| Afrique, début 2026 | 83 % | 15,8 % | StatCounter, relevé MobiLoud « Android vs iOS Market Share » |
| Amérique du Nord, début 2026 | 41 % | 58,7 % | Même source |

Ces chiffres mesurent l'**usage web** (pages vues), pas le nombre d'appareils ni les ventes. Ils montrent quand même un écart très net : en Afrique, plus de 8 utilisateurs mobiles sur 10 sont sur Android, alors qu'en Amérique du Nord iOS est majoritaire. Une fiche comparative « générale » ne suffit donc pas : il faut la relire avec notre public.

## Les 14 critères, relus pour l'Afrique francophone

| # | Critère | Android | iOS | Ce qui change pour CampusFlow en Afrique francophone |
|---|---|---|---|---|
| 1 | Philosophie | Open source (AOSP), nombreux constructeurs | Fermé, matériel et logiciel intégrés | Les étudiants utilisent surtout des Android d'entrée et de milieu de gamme, vendus par beaucoup de marques. Le modèle ouvert d'Android correspond à leur budget. |
| 2 | Architecture | Noyau Linux, ART | Darwin / XNU, Cocoa Touch | Aucun impact direct pour l'étudiant. Pour nous, Flutter masque cette différence : un seul code au-dessus des deux. |
| 3 | Environnement | Android Studio (Windows, macOS, Linux) | Xcode (macOS uniquement) | Nos postes de travail sont des PC Windows. On peut développer et tester Android tout de suite ; iOS demande un Mac, rare et cher ici. |
| 4 | Langage | Kotlin (Java), Jetpack Compose | Swift, SwiftUI / UIKit | Apprendre deux langages pour une petite équipe étudiante est coûteux. Dart avec Flutter évite ce double effort. |
| 5 | Modèle d'application | Activités, services, paquet APK / AAB | Scènes et vues, paquet IPA | Un APK peut être installé hors magasin : pratique pour un test pilote dans une université, mais à encadrer pour la sécurité. |
| 6 | Cycle de vie | onCreate → onResume → onPause → onDestroy | Active → inactive → arrière-plan → suspendue | Les téléphones avec peu de mémoire ferment souvent les applis en arrière-plan. Il faut sauvegarder l'état (un brouillon de tâche) et recharger proprement. |
| 7 | Matériel | Nombreux constructeurs et gammes | Quelques modèles, un seul constructeur | Petits écrans, 2 à 4 Go de mémoire, stockage limité : l'appli doit rester légère et être testée sur un téléphone de 360 dp de large. |
| 8 | Permissions | Demandées à l'exécution, une par une | À l'exécution, avec un texte justificatif | Ne demander que l'essentiel (les notifications pour les rappels) et expliquer pourquoi, sinon l'étudiant refuse ou désinstalle. |
| 9 | Stockage | Bac à sable, stockage cloisonné, Keystore | Bac à sable, Keychain | Le stockage est souvent plein : cache léger. Le jeton de connexion va dans le Keystore ou la Keychain (flutter_secure_storage). |
| 10 | Sécurité | Signature, Play Protect, bac à sable | Signature, revue, bac à sable | Les téléphones sont parfois prêtés ou perdus : jeton qui expire, déconnexion facile, aucun secret en clair. |
| 11 | Distribution | Google Play, autres magasins, installation directe | App Store, ouverture variable selon la région | Google Play en priorité. Le compte développeur Google coûte 25 $ une seule fois, celui d'Apple 99 $ par an : un vrai frein pour un projet étudiant. |
| 12 | Fragmentation | Forte : versions d'OS, constructeurs, tailles d'écran | Faible : adoption rapide des nouvelles versions | Très forte ici : beaucoup d'anciennes versions d'Android et d'écrans différents. Il faut tester plusieurs tailles et ne pas viser seulement les derniers modèles. |
| 13 | Mises à jour | Selon le constructeur et l'opérateur | Directes par Apple, sur les appareils compatibles | Beaucoup d'appareils ne reçoivent plus de mises à jour : on évite de dépendre des API les plus récentes. |
| 14 | Contraintes développeur | Tester sur de nombreux appareils | Mac obligatoire, revue App Store | Avec un PC et l'émulateur Android, on peut tout tester. iOS demanderait un Mac et un compte payant dès le départ. |

## Contraintes propres au contexte

- **Données mobiles chères et réseau instable :** l'appli doit afficher quelque chose sans réseau (cache) et ne pas télécharger de gros fichiers.
- **Public francophone :** interface, dates et messages en français (format de date `lundi 3 novembre`).
- **Usage à une main, souvent dans les transports :** actions principales en bas de l'écran, cibles d'au moins 48 dp.

## Conclusion de la fiche

Android est la plateforme prioritaire pour notre public. iOS reste minoritaire mais présent (environ 16 %) : il ne faut pas l'exclure, seulement ne pas commencer par lui. Une approche qui couvre les deux avec un seul code est la plus adaptée.

*Sources : diapositives de la séance 1 (StatCounter Global Stats ; relevé MobiLoud, 2026). Tarifs des comptes développeurs : Google Play Console et Apple Developer Program. Consulté le 23 novembre 2026.*
