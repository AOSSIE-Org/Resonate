# AGENTS.md

Instructions for AI coding agents working in this repository. Humans should read
[CONTRIBUTING.md](CONTRIBUTING.md) and [ONBOARDING.md](ONBOARDING.md) — this file assumes those and
adds what an agent needs to avoid breaking things.

## Project snapshot

Resonate is an open-source social voice platform: a **Flutter** app (Android + iOS) on **Appwrite**
(auth, database, storage, functions), **LiveKit** (WebRTC audio), Firebase Cloud Messaging (push)
and optionally Meilisearch (search). There is no web target. The backend is a separate repository,
[Resonate-Backend](https://github.com/AOSSIE-Org/Resonate-Backend).

- Dart SDK `>=3.9.0 <4.0.0`, Flutter 3.35.2 (the version CI pins).
- Default branch for contributions: **`dev`**. Never open a PR against `master`.

## Commands

```bash
flutter pub get                                     # dependencies
dart run build_runner build --delete-conflicting-outputs   # codegen (freezed, json, riverpod)
flutter test                                        # full suite (~700 tests)
flutter test test/features/settings                 # one area
flutter analyze                                     # base lints
dart run custom_lint                                # riverpod_lint — analyze does NOT run these
dart format lib test                                # formatting
flutter gen-l10n                                    # regenerate localizations
```

Run the app against a backend by passing the host at build time:

```bash
flutter run --dart-define=APPWRITE_BASE_DOMAIN=<host>
```

**Both lint commands must pass.** `flutter analyze` does not execute analyzer plugins, so
`riverpod_lint` violations are invisible to it.

## Architecture

The app follows Flutter's official app-architecture guidance — MVVM, feature-first. Every feature
under `lib/features/<name>/` uses the same layers:

```
lib/features/<feature>/
├── view/            widgets and pages only — no business logic, no direct service calls
│   ├── pages/
│   └── widgets/
├── viewmodel/       Riverpod notifiers holding per-screen UI state
├── model/           immutable data classes (freezed) and enums
├── data/
│   ├── repositories/    app-wide state, caching, and the public API for viewmodels
│   └── services/        raw I/O — Appwrite, LiveKit, storage, platform channels
└── **/generated/    build_runner output — never hand-edit
```

Shared code lives in `lib/core/` (providers, services, errors), `lib/shared/` (models, widgets),
`lib/routes/` (go_router), `lib/utils/` (constants, colors, sizes, asset paths) and `lib/l10n/`.

Rules that matter:

- **Dependencies point one way:** view → viewmodel → repository → service. A view never imports a
  service; a service never imports a viewmodel.
- **Durable, app-wide state belongs in a repository**, not a viewmodel. The discriminator: if the
  state must survive the screen being popped, it is repository state. Auth/session state lives in
  `AuthRepository` for exactly this reason.
- **Read theme values from `Theme.of(context)`**, never a hard-coded colour — the app ships six
  user-selectable themes. Fixed constants exist only for things that mean the same in every theme
  (`ActivityStatusColors`, category colours, `AppColor`).
- **Sizes come from `UiSizes`** (`lib/utils/ui_sizes.dart`), not raw numbers — they are computed
  from `MediaQuery` at startup.
- **Images come from `AppImages`** constants, not string literals.

## Code generation

`build.yaml` redirects generated output into a `generated/` sibling directory rather than beside the
source. So a file declares:

```dart
part 'generated/my_notifier.g.dart';
```

After changing anything annotated with `@riverpod`, `@freezed` or `@JsonSerializable`, run
build_runner. Generated files (`**/*.g.dart`, `**/*.freezed.dart`) are excluded from analysis and
must never be edited by hand — the edit will be silently overwritten.

## Localization

Ten locales: `en` (template), `bn`, `gu`, `hi`, `kn`, `ml`, `mr`, `pa`, `raj`, `ta`. Add new strings
to `lib/l10n/app_en.arb`, run `flutter gen-l10n`, and reference them as
`AppLocalizations.of(context)!.myKey`. Never hard-code user-facing text.

`untranslated.txt` is generated output — do not edit it by hand. A CI workflow
(`translation-check.yml`) checks translation coverage on PRs.

## Testing

Tests live under `test/`, mirroring `lib/`. New functionality requires tests — this is project
policy, not a preference. Use `mockito` for services and `ProviderContainer` overrides for Riverpod.
`network_image_mock` is available for widget tests that render remote images.

Run the full suite before declaring work done. `flutter test` runs in debug mode, so framework
assertions are active and will catch lifecycle misuse.

## Conventions

- **Commits:** conventional format — `<type>: <short summary>`, lowercase, no trailing period.
  Types: `docs|feat|fix|perf|refactor|test`.
- **Formatting:** `dart format` before committing.
- **Comments:** match the density of surrounding code. Explain intent, not mechanics.

## Things that will bite you

- **Never run a bulk find-and-replace across `.dart` files.** Regex sweeps over this codebase have
  broken generated `part` directives and freezed constructors before. Edit files individually.
- **Never hand-edit anything under a `generated/` directory**, `untranslated.txt`, or
  `project_structure.txt` — all are produced by tooling.
- **The `Score Summary` table in `BestPracticesChecklist.md` is generated** by
  `.github/scripts/checklist_score.py`. Edit the checkboxes; let the script write the table.
- **Appwrite realtime echo is unreliable.** Do not assume your own write will come back as a
  realtime event; update local state optimistically and reconcile.
- **Timestamps are stored in UTC.** Convert at the presentation layer only.
- **`freezed` classes cannot declare a member named `call`** — it collides with generated code.
- **Never run a blanket `appwrite push`** when working with the backend. It deploys every function
  and collection, including ones unrelated to the change. Push only what you touched.
- **Endpoints are `http://` by construction** in `lib/utils/constants.dart`, with only the host
  overridable via `--dart-define`. This is a known issue tracked in
  [BestPracticesChecklist.md](BestPracticesChecklist.md); don't "fix" it incidentally inside an
  unrelated PR.

## Scope

Do what was asked. Don't opportunistically reformat unrelated files, bump dependencies, or refactor
adjacent code — it makes reviews harder and this project reviews by diff. If you spot a real problem
outside the current task, mention it rather than fixing it silently.

Ask before: changing the Appwrite schema, adding a dependency, altering the release pipeline, or
touching auth. Those are hard to reverse once shipped to the store — raise them with a
[maintainer](MAINTAINERS.md) rather than deciding unilaterally.
