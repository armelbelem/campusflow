# Séance 1 · Décision de plateforme pour CampusFlow

**Cible.** CampusFlow s'adresse aux étudiants de licence et de master des universités d'Afrique francophone, en commençant par l'U-AUBEN au Burkina Faso. Ces étudiants utilisent surtout un smartphone Android d'entrée ou de milieu de gamme, souvent d'une seule main, avec des données mobiles chères et une connexion parfois instable.

**Plateformes.** Android est la plateforme prioritaire : en Afrique, il représente environ 83 % de l'usage web mobile (StatCounter, début 2026), contre 15,8 % pour iOS. iOS vient en second, car une partie des étudiants l'utilise. Le web sert pour les démonstrations.

**Approche.** Nous retenons une approche **cross-platform avec Flutter**. Une seule base de code en Dart couvre Android et iOS avec un rendu identique. Le hot reload accélère le développement. Tout se fait sur nos PC Windows avec l'émulateur Android. Le natif est écarté : deux applications (Kotlin et Swift) coûteraient le double pour une petite équipe, et iOS demanderait un Mac et un compte Apple payant dès le départ. Les limites de Flutter, une application plus lourde et des plugins parfois manquants, sont acceptables : CampusFlow n'utilise que des fonctions courantes (listes, formulaires, rappels, stockage sécurisé, appels d'API).

**Leçon de l'autopsie.** BlackBerry n'a pas disparu à cause de sa technique, mais parce qu'il a raté le passage au tactile, réagi trop tard et perdu son écosystème. Pour CampusFlow, cela veut dire : une interface tactile simple, une présence immédiate sur la plateforme majoritaire de nos utilisateurs, et un choix technique que l'on garde jusqu'au bout.
