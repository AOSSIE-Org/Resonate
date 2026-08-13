# Maintainers

This file lists the people responsible for reviewing and merging changes to Resonate.

## Current maintainers

| Maintainer | GitHub | Focus |
| --- | --- | --- |
| Chandan S Gowda | [@chandansgowda](https://github.com/chandansgowda) | Project direction, releases, backend |
| Madhav Gupta | [@M4dhav](https://github.com/M4dhav) | Flutter app, CI — default code owner |
| Mayank | [@Mayank4352](https://github.com/Mayank4352) | Flutter app, features, tooling, Arhitecture |

[@M4dhav](https://github.com/M4dhav) is the default owner for the whole repository in
[.github/CODEOWNERS](.github/CODEOWNERS), so review is requested automatically on every pull
request.

## What maintainers do

- Triage incoming issues and apply labels.
- Review pull requests against [CONTRIBUTING.md](CONTRIBUTING.md) — conventional commit messages,
  tests for new functionality, and a clean `flutter analyze`.
- Merge into `dev`. Only maintainers merge `dev` into `master` and cut releases.
- Respond to vulnerability reports per [SECURITY.md](SECURITY.md).
- Keep the Appwrite backend and Play Store listing in sync with the app.

## Getting a review

1. Open your pull request against **`dev`** — PRs to `master` are closed unreleased.
2. CODEOWNERS requests a review automatically; no need to @-mention.
3. If a PR sits for more than a week without a response, comment on it or raise it in
   [Discord](https://discord.gg/MMZBadkYFm).

Do not email maintainers directly for routine questions — use the issue tracker or Discord so the
answer stays searchable for everyone. Security reports are the exception; follow
[SECURITY.md](SECURITY.md).


Resonate is an [AOSSIE](https://aossie.org) project. Reach the wider organisation at
[aossie.oss@gmail.com](mailto:aossie.oss@gmail.com) or on
[Discord](https://discord.gg/MMZBadkYFm).
