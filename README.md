# Soft Light

Soft Light is a Flutter app that turns a phone or browser into a soft, adjustable light for selfies, video calls, low-light scenes, and creator preview workflows.

## Features

- Soft light canvas with built-in warm, cool, pink, and neutral presets.
- Swipe gestures for mode switching and brightness adjustment.
- Custom color presets stored locally.
- Sleep timer and app-level brightness control on supported native platforms.
- Creator Glow mode with front camera preview and companion-light fallback.
- Flutter Web support for browser-based page light.

## Local Development

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Run the web app locally:

```bash
flutter build web --pwa-strategy=none --no-web-resources-cdn
python3 -m http.server 5173 --directory build/web
```

Then open:

```text
http://localhost:5173/
```

For another device on the same Wi-Fi, use the Mac's LAN IP, for example:

```text
http://192.168.222.7:5173/
```

## GitHub Pages

This repository ships with a GitHub Actions workflow at `.github/workflows/deploy-pages.yml`.

The workflow runs on every push to `main` and:

- installs Flutter `3.35.7`,
- runs `flutter analyze`,
- runs `flutter test`,
- builds Flutter Web with `--base-href /SoftLight-App/`,
- disables PWA caching for predictable fresh loads,
- disables CDN web resources so CanvasKit is served from the Pages artifact,
- deploys `build/web` to GitHub Pages.

Expected Pages URL:

```text
https://aceantimobi.github.io/SoftLight-App/
```

If Pages is not active yet, open the repository's **Settings > Pages** and make sure the source is set to **GitHub Actions**.
