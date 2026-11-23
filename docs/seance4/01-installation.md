# Séance 4 · Installation et diagnostic

## Environnement installé

| Élément | Version / état |
|---|---|
| Flutter SDK | 3.47.9 (canal stable), dans `C:\src\flutter`, `bin` ajouté au PATH |
| Dart | 3.13.7 (fourni avec Flutter) |
| Android Studio | Installé, avec les extensions Flutter et Dart |
| Android SDK | Version 36.0.0 |
| Émulateur | `Medium_Phone_API_37.0` (Device Manager) |
| Système | Windows 11 |

## Sortie de `flutter doctor`

```text
[√] Flutter (Channel stable, 3.47.9, on Microsoft Windows, locale fr-CA)
[√] Windows Version (Windows 11 or higher)
[!] Android toolchain - develop for Android devices (Android SDK version 36.0.0)
    X cmdline-tools component is missing.
    X Android license status unknown.
[√] Chrome - develop for the web
[!] Visual Studio - develop Windows apps
    X Visual Studio is missing necessary components.
[√] Connected device (3 available)
[√] Network resources
```

## Lecture et corrections

| Ligne | Gravité | Correction |
|---|---|---|
| Flutter | Corrigée | Un second SDK Dart (installé à part) passait avant celui de Flutter dans le PATH. Il a été désinstallé : `dart` pointe maintenant vers le SDK de Flutter. |
| Android toolchain : cmdline-tools | Bloquant | Android Studio → *More Actions* → *SDK Manager* → onglet *SDK Tools* → cocher **Android SDK Command-line Tools (latest)** → *Apply*. |
| Android toolchain : licences | Bloquant | Après l'installation des cmdline-tools : `flutter doctor --android-licenses`, puis répondre `y` à chaque licence. |
| Visual Studio | Avertissement sans impact | Sert seulement à compiler des applications Windows de bureau. CampusFlow vise Android (et le web) : non bloquant, comme indiqué dans la consigne. |

La capture finale de `flutter doctor` sans erreur est dans `docs/captures/seance4/`.
