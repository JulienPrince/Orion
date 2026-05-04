# Hermes

App native macOS et iOS — wrapper WebView pour accéder à n'importe quel WebUI depuis le dock ou l'écran d'accueil.

## Fonctionnalités

- **URL configurable** — saisie au premier lancement, modifiable depuis les paramètres ⚙️
- **Session persistante** — les cookies sont conservés entre les relances
- **Déconnexion** — efface cookies, cache et localStorage en un clic
- **Liens externes** — s'ouvrent dans le navigateur système, pas dans l'app
- **Raccourcis clavier** — `⌘R` / `Ctrl+R` pour recharger
- **Fenêtre mémorisée** — taille et position restaurées à chaque lancement (macOS)
- **SafeArea iOS** — contenu respecte le notch et la status bar

## Stack

| | |
|---|---|
| Framework | Flutter 3.x |
| WebView | `webview_flutter` ^4.7 |
| Plateformes | macOS, iOS |

## Installation

### macOS

```bash
flutter build macos --release
cp -R build/macos/Build/Products/Release/hermes_app.app /Applications/Hermes.app
```

### iOS

Ouvrir dans Xcode et lancer sur le device :

```bash
open ios/Runner.xcworkspace
```

Sélectionner le device → **▶ Run**

## Développement

```bash
flutter pub get
flutter run -d macos        # macOS
flutter run -d <device-id>  # iPhone
```

## Structure

```
lib/
├── main.dart                    # Init window_manager (desktop) + runApp
├── app/
│   ├── app.dart                 # Routing setup ↔ home
│   └── theme.dart               # Thème dark (#141425)
├── screens/
│   ├── home_screen.dart         # WebView principale + raccourcis
│   └── setup_screen.dart        # Saisie / modification de l'URL
├── widgets/
│   ├── navigation_bar.dart      # Barre (Reload · Hermes · Déconnexion)
│   └── loading_indicator.dart   # Progress bar 2px
└── services/
    ├── app_preferences.dart     # Persistance URL (shared_preferences)
    └── window_preferences.dart  # Persistance taille/position fenêtre
```
