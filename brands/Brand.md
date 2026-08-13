# Resonate — Brand Guide

Resonate is an open-source social voice platform built by [AOSSIE](https://aossie.org). Voice is
the product, so the brand is built around a single idea: **sound made visible**. Concentric ripples,
a warm amber signal against near-black, and a wordless mark that reads as both an `R` and a
waveform.

This document is the single source of truth for the logo, icons, colour and typography that ship
with the app. Every value below is taken from the code or the asset files in this repository — if
you change one, change it here too.

| | |
| --- | --- |
| **Name** | Resonate (always capital `R`, never "ReSonate" or "resonate" in prose) |
| **Parent org** | AOSSIE |
| **Platform label** | `Resonate` (Android `android:label`, iOS `CFBundleDisplayName`) |
| **Bundle id** | `com.resonate.resonate` |
| **Positioning** | An open-source social voice platform — rooms, stories, pair chat, voice calls |
| **Licence** | GPL-3.0 — the marks are part of the repo, see [COPYRIGHT.md](../COPYRIGHT.md) |

---

## 1. Logo

### The mark

The Resonate mark is a monogram `R` drawn as three nested sound ripples, flanked by two dots that
read as the endpoints of a wave. It is a **single-path, single-colour** mark — there is no
wordmark lockup, no gradient version, and no alternate orientation.

The master artwork is the SVG:

- [`brands/svg/resonate_logo_white.svg`](svg/resonate_logo_white.svg) — `viewBox="0 0 100 178"`,
  one `<path>`, `fill="white"`, transparent background.

The same file ships to the app at
[`assets/svg/resonate_logo_white.svg`](../assets/svg/resonate_logo_white.svg) and is declared under
the `assets/svg/` entry in [`pubspec.yaml`](../pubspec.yaml).

### Why the source is white

The SVG is authored white **on purpose** so it can be recoloured at runtime to whatever the active
theme's primary colour is. Both places the logo appears in the app do exactly this:

```dart
SvgPicture.asset(
  'assets/svg/resonate_logo_white.svg',
  height: UiSizes.height_30,
  fit: BoxFit.contain,
  colorFilter: ColorFilter.mode(
    Theme.of(context).colorScheme.primary,
    BlendMode.srcIn,
  ),
)
```

Used in [`landing_page.dart:23`](../lib/features/auth/view/pages/landing_page.dart#L23) and
[`welcome_page.dart:30`](../lib/features/auth/view/pages/welcome_page.dart#L30).

**Do not** hard-code amber into a new SVG copy. Recolour the existing one with `srcIn` so the mark
follows the six themes.

### Raster fallback

- [`brands/images/resonate_logo.png`](images/resonate_logo.png) — 500×500, amber `#FFC107` mark on
  `#19191B`, safe-margined square. Also at
  [`assets/images/resonate_logo.png`](../assets/images/resonate_logo.png) and referenced as
  `AppImages.resonateLogoImage` in [`app_images.dart`](../lib/utils/app_images.dart).
- [`assets/images/proxy_image.png`](../assets/images/proxy_image.png) — 500×500, the splash-screen
  variant (solid `#19191B`), consumed by
  [`flutter_native_splash.yaml`](../flutter_native_splash.yaml).

Use the SVG anywhere it will be scaled, tinted or printed. Use the PNG only where SVG is not an
option (README badges, stores, third-party embeds).

### Usage rules

**Do**

- Keep the mark's aspect ratio (`100 : 178`, i.e. tall and narrow) — scale, never stretch.
- Leave clear space of at least the width of one ripple stroke (≈ 10% of the mark's height) on all
  sides.
- Render it in a single flat colour: theme `primary`, brand amber, pure white, or pure black.
- Minimum legible size: **24 dp / 24 px tall**. Below that the three ripples merge — use the
  app icon instead.

**Don't**

- Don't add a wordmark, tagline or container shape to the mark and call it a lockup.
- Don't apply gradients, shadows, outlines, or per-ripple colouring.
- Don't rotate, mirror, skew or re-space the dots.
- Don't place the mark on a busy photograph, or on a mid-tone where amber loses contrast.
- Don't recreate the path by hand — reuse the SVG.

### Partner marks

[`brands/images/aossie_logo.png`](images/aossie_logo.png) (449×425) is the AOSSIE parent-org mark. It
appears beside the Resonate logo in the README and in-app credits. It is **not** a Resonate asset —
do not restyle or recolour it.

---

## 2. Icons & favicons

### App icon

The app icon is the same ripple `R`, amber on a dark plum-black field, filling the square with no
padding ring. Two things differ from the in-app logo and both are intentional in the generated
artwork:

| | Mark colour | Background |
| --- | --- | --- |
| App icon (iOS/Android) | `#FFBA06` | `#1B121A` |
| Logo PNG / splash | `#FFC107` | `#19191B` |

> **Known drift:** three ambers exist in the project — `#FFBA06` (app icon), `#FFC107` (logo PNG and
> the `amber` theme's primary) and `#FDD51F` (`AppColor.yellowColor`, the utility token). They are
> close enough to pass at a glance but they are not the same colour. If the icons are ever
> regenerated, standardise on `#FFC107` and update this table.

### Icon inventory

**Android** — [`android/app/src/main/res/`](../android/app/src/main/res/)

| Density | File | Size |
| --- | --- | --- |
| mdpi | `mipmap-mdpi/ic_launcher.png` | 48×48 |
| hdpi | `mipmap-hdpi/ic_launcher.png` | 72×72 |
| xhdpi | `mipmap-xhdpi/ic_launcher.png` | 96×96 |
| xxhdpi | `mipmap-xxhdpi/ic_launcher.png` | 144×144 |
| xxxhdpi | `mipmap-xxxhdpi/ic_launcher.png` | 192×192 |
| notification/legacy | `drawable/ic_launcher.png` | 72×72 |

Wired up in [`AndroidManifest.xml`](../android/app/src/main/AndroidManifest.xml) via
`android:icon="@mipmap/ic_launcher"`.

**iOS** — [`ios/Runner/Assets.xcassets/AppIcon.appiconset/`](../ios/Runner/Assets.xcassets/AppIcon.appiconset/)

25 PNGs indexed by `Contents.json`, named by pixel size:
`16, 20, 29, 32, 40, 50, 57, 58, 60, 64, 72, 76, 80, 87, 100, 114, 120, 128, 144, 152, 167, 180,
256, 512, 1024`. The 1024×1024 is the App Store / master raster.

**Splash** — generated, do not hand-edit. `dart run flutter_native_splash:create` regenerates
`drawable-*/splash.png`, `drawable-*/android12splash.png`, `drawable-night-*/…` and the iOS
`LaunchImage.imageset` from [`flutter_native_splash.yaml`](../flutter_native_splash.yaml)
(background `#19191B`, image `assets/images/proxy_image.png`).

### Favicons

Resonate has no Flutter **web** target, so there is no `web/` directory and no `favicon.ico` or web
app manifest checked in. The favicon-sized artwork already exists, though — the small square PNGs in
the iOS `AppIcon.appiconset` are the canonical sources:

| Favicon role | Source file |
| --- | --- |
| `favicon.ico` (16/32/48 multi-res) | `AppIcon.appiconset/16.png`, `32.png` |
| `favicon-32x32.png` | `AppIcon.appiconset/32.png` |
| `apple-touch-icon.png` (180) | `AppIcon.appiconset/180.png` |
| Android Chrome 192 / 512 | `mipmap-xxxhdpi/ic_launcher.png`, `AppIcon.appiconset/512.png` |
| PWA maskable / store | `AppIcon.appiconset/1024.png` |

Anything that needs a Resonate favicon (docs site, landing page, GitHub Pages) should be generated
from these, not redrawn. Because the mark is amber on a dark field, it survives both light and dark
browser chrome without an inverted variant.

### In-app iconography

- **System icons:** Material Icons (`uses-material-design: true`) plus
  [`font_awesome_flutter`](../pubspec.yaml) for the handful of brand/social glyphs.
- **Theme icons:** each of the six themes carries its own Material glyph, defined in the
  `ThemeIcons` enum in [`theme_enums.dart`](../lib/features/theme/model/theme_enums.dart) —
  Classic `diamond`, Vintage `temple_buddhist_rounded`, Forest `forest`, Cream `nights_stay`,
  Amber `local_fire_department`, Time `access_time_outlined`.
- **Illustrations:** empty and error states use flat SVG/PNG spot art —
  [`no_room.svg`](../assets/images/no_room.svg),
  [`no_connection.svg`](../assets/images/no_connection.svg),
  [`empty_box.png`](../assets/images/empty_box.png), addressed through the `AppImages` constants in
  [`app_images.dart`](../lib/utils/app_images.dart). Reference images through `AppImages`, never as
  a raw string literal.

---

## 3. Colour

Resonate is a **themed** app, not a single-palette app. The user picks one of six themes, and every
surface derives from that theme's `ColorScheme`. Two rules follow:

1. **Read colour from the theme, not from a constant.** `Theme.of(context).colorScheme.primary`,
   never a hard-coded hex — that is what lets one mark and one screen serve six palettes.
2. **Fixed constants are for things that mean the same in every theme** — status dots, category
   tags, password strength. Those live in typed collections, listed below.

### Theme palettes

Defined in [`theme_list.dart`](../lib/features/theme/model/theme_list.dart); assembled into
`ThemeData` by [`theme_modes.dart`](../lib/features/theme/model/theme_modes.dart).

| Theme | Mode | Primary | On primary | Secondary | On secondary | Surface | On surface |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Classic** *(default)* | Light | `#292C31` | `#FFFFFF` | `#DEE0DF` | black 45% | `#FFFFFF` | `#000000` |
| **Vintage** | Light | `#503C3C` | `#FFFFFF` | `#E2E0E0` | black 45% | `#FFFFFF` | `#000000` |
| **Forest** | Light | `#183D3D` | `#FFFFFF` | `#D9DEDA` | black 45% | `#FFFFFF` | `#000000` |
| **Time** | Dark | `#F20073` | `#FFFFFF` | `#21252F` | white 38% | `#181B22` | `#FFFFFF` |
| **Amber** | Dark | `#FFC107` | `#000000` | `#21252F` | white 38% | `#181B22` | `#FFFFFF` |
| **Cream** | Dark | `#F6B17A` | `#000000` | `#424769` | white 38% | `#2D3250` | `#FFFFFF` |

Classic is the fallback: `Themes.fromName()` returns `classic` for an unknown or missing stored
value, and the selection persists to GetStorage under the `theme` key
([`theme_notifier.dart`](../lib/features/theme/viewmodel/theme_notifier.dart)).

Shared scheme slots, applied on top of every theme:

| Slot | Light | Dark |
| --- | --- | --- |
| `surfaceContainerHighest` | `#7A7A7A` | `#424242` |
| `onSurfaceVariant` | `#616161` | `#BDBDBD` |
| `secondaryContainer` | `#EEEEEE` | `#616161` |
| `surfaceTint` | transparent | transparent |
| Divider | black 54% | white 54% |

### Activity status colours

Semantic, theme-independent, and shipped as a `ThemeExtension` so they lerp with theme animations —
[`activity_status_colors.dart`](../lib/features/theme/model/activity_status_colors.dart). Read them
with `ActivityStatusColors.of(context)`.

| Status | Light | Dark | Meaning |
| --- | --- | --- | --- |
| Online | `#3BA55D` | `#43B581` | Available |
| Do not disturb | `#ED4245` | `#F04747` | Available but not to be called |
| In room | `#FAA81A` | `#FAA61A` | Currently in a live room |
| Invisible | `#80848E` | `#949BA4` | Appears offline by choice |
| Offline | `#80848E` | `#949BA4` | Not connected |

Invisible and offline are deliberately the same colour — the difference is private to the user.

### Story category colours

Fixed hues keyed by category name, in
[`AppColor.categoryColorList`](../lib/utils/colors.dart#L18):

| Category | Hex | | Category | Hex |
| --- | --- | --- | --- | --- |
| Drama | `#ED1D9A` | | Thriller | `#2653D7` |
| Horror | `#15B288` | | Romance | `#8CCC25` |
| Comedy | `#8E10EE` | | Spiritual | `#DA5353` |

### Utility colours

[`AppColor`](../lib/utils/colors.dart) — small, deliberately non-themed set:

| Token | Value | Used for |
| --- | --- | --- |
| `yellowColor` | `#FDD51F` | Brand amber token; mid password strength |
| `greenColor` | `#44AA32` | Strong password / success |
| `orangeColor` | `#FF9800` (`Colors.orange`) | Weak password warning |
| `redColor` | `#F44336` (`Colors.red`) | Very weak / error |
| `greyShadeColor` | `#E0E0E0` (`grey.shade300`) | Inactive strength bars |
| `bgBlackColor` | `#19191B` | Splash + bottom-nav background — the brand's "off" black |
| `gradientBg` | `Colors.amber → #FDD51F` | Accent gradient |

### Contrast

Light themes pair a `#FFFFFF` surface with near-black text; dark themes pair `#181B22`/`#2D3250`
with white. All six clear WCAG AA for body text as shipped. The one to watch is **Amber** — amber
`#FFC107` as `primary` requires **black** `onPrimary` (which is how it is configured); never put
white text on the amber fill.

---

## 4. Typography

### Typeface

**Poppins** is the app typeface, set once as `ThemeData.fontFamily` in
[`theme_modes.dart`](../lib/features/theme/model/theme_modes.dart) for both the light and dark
builders:

```dart
ThemeData(
  fontFamily: GoogleFonts.poppins().fontFamily,
  ...
)
```

Poppins is a geometric sans — round, open counters, near-circular `o` — which echoes the ripple
geometry of the mark. It comes from the [`google_fonts`](../pubspec.yaml) package, so it is fetched
and cached at runtime rather than bundled.

Because it is set at the `ThemeData` level, **individual widgets should not set `fontFamily`**. The
only places that legitimately restate it are the `ElevatedButton` and `OutlinedButton` themes, where
a `TextStyle` is constructed from scratch and would otherwise fall back to the platform default.

> **Montserrat** is declared as a bundled family in [`pubspec.yaml`](../pubspec.yaml#L136) with
> `assets/fonts/Montserrat-Regular.ttf`, but no code references the family. It is a leftover from
> before the Poppins switch. Treat Poppins as the only brand typeface; Montserrat can be dropped
> when someone is doing asset cleanup.

### Weights

Only three weights are in use. Keep it that way — more weights read as a different brand.

| Weight | Where |
| --- | --- |
| Regular `w400` | Body copy, list tiles, secondary labels (theme default) |
| Medium `w500` | Buttons — set explicitly in the elevated/outlined button themes |
| Bold `w700` | Screen titles, speaker names, emphasis inside body text |

### Type roles

The `textTheme` overrides only the two roles that need an explicit colour; everything else inherits
Material 3 defaults recoloured by the scheme.

| Role | Light | Dark | Typical use |
| --- | --- | --- | --- |
| `bodyLarge` | `#000000` | `#FFFFFF` | Primary body copy |
| `titleMedium` | black 54% | white 54% | Subtitles, muted labels |
| `headlineMedium` | inherited | inherited | Page headings (login, signup, forgot password) |
| `bodyMedium` | inherited | inherited | List tiles, story and friend rows |
| `bodySmall` | inherited | inherited | Captions, helper text |

Read them as `Theme.of(context).textTheme.<role>` and `copyWith` for local tweaks.

### Sizing

Font sizes are **responsive, not fixed**. [`UiSizes`](../lib/utils/ui_sizes.dart) computes every
dimension from `MediaQuery` at startup via `UiSizes.init(context)`; the `size_*` family blends screen
width and height so type scales on both axes:

```dart
size_16 = 0.02187 * screenWidth + 0.01095 * screenHeight;
```

The name is the size at the reference device, so `UiSizes.size_16` ≈ 16 sp there. The practical
ladder:

| Token | Role |
| --- | --- |
| `size_12` – `size_13` | Captions, timestamps, chips |
| `size_14` – `size_16` | Body, list tiles, buttons |
| `size_17` – `size_20` | Subtitles, section headers |
| `size_23` – `size_28` | Screen headlines, onboarding titles |
| `size_32`+ | Display numerals, empty-state headings |

Use a `UiSizes` token rather than a raw number, and use `height_*` / `width_*` for spacing so
layout and type scale together. Button height is the one fixed value: `Size.fromHeight(48)`.

### Shape

Not typography, but it travels with it: inputs and buttons use a **12 px** corner radius
(`BorderRadius.circular(12)` in `inputDecorationTheme`), fields are filled with the theme's
`secondary`, and the focused border is the theme's `primary`. Match that radius for new surfaces.

---

## 5. Asset map

```
brands/
├── Brand.md                       ← this file
├── svg/
│   └── resonate_logo_white.svg    ← logo master (100×178, single path, white)
└── images/
    ├── resonate_logo.png          ← 500×500 raster logo, #FFC107 on #19191B
    ├── aossie_logo.png            ← 449×425 parent-org mark
    ├── no_room.svg                ← empty-state illustration
    ├── landing_first.png          ← onboarding art 1/3
    ├── landing_second.png         ← onboarding art 2/3
    └── landing_third.png          ← onboarding art 3/3

assets/                            ← shipped copies consumed by the app
├── svg/resonate_logo_white.svg
├── images/{resonate_logo, proxy_image, aossie_logo, empty_box, user}.png|jpeg
├── images/{no_room, no_connection}.svg
├── images/landing_{first,second,third}.png
└── fonts/Montserrat-Regular.ttf   ← declared, unused

android/app/src/main/res/          ← launcher icons + generated splash
ios/Runner/Assets.xcassets/        ← AppIcon.appiconset + LaunchImage/LaunchBackground
docs/store_listing/                ← Play Store copy, poster, screenshots
```

`brands/` is the brand kit — the masters you hand to a designer or a press page. `assets/` is what
Flutter bundles. When a mark changes, update `brands/` first, then copy into `assets/` and
regenerate the platform icons; the two must not drift.

---

## 6. Where the brand lives in code

| Concern | File |
| --- | --- |
| Theme palettes | [`lib/features/theme/model/theme_list.dart`](../lib/features/theme/model/theme_list.dart) |
| `ThemeData` assembly | [`lib/features/theme/model/theme_modes.dart`](../lib/features/theme/model/theme_modes.dart) |
| Theme enum + icons | [`lib/features/theme/model/theme_enums.dart`](../lib/features/theme/model/theme_enums.dart) |
| Theme selection + persistence | [`lib/features/theme/viewmodel/theme_notifier.dart`](../lib/features/theme/viewmodel/theme_notifier.dart) |
| Status colours (`ThemeExtension`) | [`lib/features/theme/model/activity_status_colors.dart`](../lib/features/theme/model/activity_status_colors.dart) |
| Utility + category colours | [`lib/utils/colors.dart`](../lib/utils/colors.dart) |
| Responsive size tokens | [`lib/utils/ui_sizes.dart`](../lib/utils/ui_sizes.dart) |
| Image asset constants | [`lib/utils/app_images.dart`](../lib/utils/app_images.dart) |
| Splash generation | [`flutter_native_splash.yaml`](../flutter_native_splash.yaml) |
| Store copy | [`docs/store_listing/description.md`](../docs/store_listing/description.md) |

### Changing something

1. **A colour** → edit `theme_list.dart` (theme palette), `activity_status_colors.dart` (status) or
   `colors.dart` (utility). Update the tables in §3 in the same commit.
2. **The logo** → replace `brands/svg/resonate_logo_white.svg`, re-export the 500×500 PNG, copy both
   into `assets/`, regenerate launcher icons and splash, update §1 and §2.
3. **The typeface** → change the `GoogleFonts.*` call in `theme_modes.dart` (four call sites: the
   two `fontFamily` lines and the two button `TextStyle`s) and update §4.
4. **A new illustration** → drop it in `assets/images/`, add a constant to `AppImages`, and
   reference it through that constant.

Adding a colour, size or image constant anywhere other than these files is the thing to avoid — the
theming only works because there is exactly one place each value is declared.
