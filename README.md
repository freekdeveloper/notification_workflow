# Notification Workflow

Flutter app that contains a 'notification workflow'
that allows users to keep track of the work that needs to be done.  

## Platforms

The Flutter project supports ios, android, web and windows officially. Other platforms are .gitignored so can only be used locally.

## Flutter version (FVM)

The Flutter SDK version is pinned in [`.fvmrc`](.fvmrc) and managed via [FVM](https://fvm.app). 

```bash
dart pub global activate fvm
fvm install
fvm use

fvm flutter pub get
fvm flutter run
fvm flutter test integration_test/
```

Fvm has ways to change the flutter command to always use fvm. You could also setup an alias for 'fvm flutter'

To bump the SDK, update the version in **two places** and commit both:

1. [`.fvmrc`](.fvmrc) — used locally by FVM.
2. The `FLUTTER_VERSION` env var at the top of [`.github/workflows/app-ci.yml`](.github/workflows/app-ci.yml) — used by CI.

Then run `fvm install` locally.

## Running

```bash
fvm flutter pub get
dart run environment_config:generate   # creates .env (gitignored)
fvm flutter run
```

A `.env` file at the project root is loaded at startup — without it, the app won't start. See **Configuration** below for how it's generated.

## Configuration (`.env`)

Configuration is read via [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv) from a `.env` file in the project root. The file is bundled as a Flutter asset — without it, the app fails to start.


## Architecture notes for new contributors

### Localization

Localized strings live in [lib/src/localization/app_en.arb](lib/src/localization/app_en.arb) and [lib/src/localization/app_nl.arb](lib/src/localization/app_nl.arb). After editing an `.arb` file, regenerate the Dart bindings(this is also done by flutter pub get or doing a hot restart):

```bash
flutter gen-l10n
```

**Key naming convention:** `{feature}{Screen}{Purpose}` in camelCase.

- Feature- and screen-scoped: `notificationOverviewTitle`, `notificationDetailComplete`, `notificationDetailStatusOpen`
- Cross-cutting / shared: short, standalone names like `dateToday`, `dateYesterday`

Keys with placeholders (e.g. `notificationDetailTitle: "Melding {organization}"`) declare their placeholder type in the matching `@notificationDetailTitle` metadata block. Mirror every key in both `.arb` files — the generator will fail if a translation is missing.

### Theming

All visual styling is centralized in `getTheme()` in [lib/src/config/theme.dart](lib/src/config/theme.dart): the primary color seed, scaffold background, and the `appBarTheme` / `tabBarTheme` / `cardTheme` overrides. To change look-and-feel app-wide, edit those component themes rather than styling widgets in place. Per-widget overrides (e.g. forcing a foreground color on a specific `TextButton`) are acceptable for one-offs but should move into the theme once they're used in more than one place.

### Routing

Routes are declared in [lib/src/routing/router.dart](lib/src/routing/router.dart). The router itself is exposed as a Riverpod `Provider<GoRouter>` (`routerProvider`) so future routes can depend on app state (auth, feature flags) by `watch`-ing other providers.


### State management

[Riverpod](https://pub.dev/packages/hooks_riverpod) Services are exposed as `Provider`s and overridden in tests. Domain state lives in `AsyncNotifier`s (`NotificationsNotifier`). 


## Release builds

The Github Action will create a release build after all previous steps have succeeded. Currently this is done with a debugkey and your phone will recognize it as a new app and remove the data of the old app. This should be updated to use a signing key that is used by everyone.
