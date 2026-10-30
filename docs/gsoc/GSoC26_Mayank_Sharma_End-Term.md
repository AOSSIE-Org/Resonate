![Google Summer of Code](https://summerofcode.withgoogle.com/assets/media/logo.svg)

<p align="center">
    <img src="https://github.com/AOSSIE-Org/Resonate/blob/1cc1dca874891966fab3eb02884eed260cbacb95/assets/images/aossie_logo.png?raw=true" alt="AOSSIE Logo" style="width: 150px; height: auto; margin-right: 20px;">
    <img src="https://github.com/AOSSIE-Org/Resonate/blob/1cc1dca874891966fab3eb02884eed260cbacb95/assets/images/resonate_logo.png?raw=true" alt="Resonate Logo" style="width: 150px; height: auto;">
</p>

# Google Summer of Code 2026 End Term Eval

# Project Details

Project: [Resonate](https://github.com/AOSSIE-Org/Resonate)

Idea: Resonate Version 4

Project Size: Large (360 Hours)

Project Length: 22 Weeks

# Personal Information

## Contact Information:

Name: Mayank Sharma

Discord Username: Mayank4352

GitHub Profile URL: [https://github.com/Mayank4352](https://github.com/Mayank4352)

# Work Done during GSoC 2026

### 35 PRs across both Repositories

### 87 Commits across both Repositories

### \_\_\_ Lines of Code Contributed

## Key Tools and Technologies Used and Learned

- Riverpod and the feature-first MVVM architecture from Flutter's official app-architecture guidance
- Code generation at scale with `freezed`, `json_serializable` and `riverpod_generator` via `build_runner`
- Declarative routing and deep linking with `go_router` and Android App Links
- Appwrite as a full-stack BaaS, including relationships, indexes, per-execution API keys, cloud functions and a major version upgrade
- Self-hosting and operating a production Appwrite instance behind HTTPS
- LiveKit's client SDK beyond audio transport, including active-speaker events and the native FFT audio visualizer
- Android platform work: Picture-in-Picture, manifest merging, network security configuration and app-link verification
- iOS release preparation: App Store privacy manifests, ATS, usage descriptions and background modes
- Writing unit, widget and architecture tests at scale, and measuring line coverage from raw `lcov` data
- Meilisearch hybrid and semantic search, and designing a feature that degrades gracefully when its infrastructure is absent
- On-device AI, reusing OpenAI Whisper for transcription off the critical path
- Maintaining a ten-locale internationalized application

## State Management Overhaul: GetX to Riverpod, Feature-Based MVVM, Freezed and Deep Linking

Resonate was built on GetX, which coupled UI and business logic tightly enough that most of the app
could not be tested without rendering a widget, and which made every piece of state implicitly
global. The single largest piece of my project was migrating the entire application to Riverpod
under a feature-first MVVM architecture, following Flutter's official app-architecture guidance.

The migration was done incrementally, feature by feature, so that the app remained buildable and
shippable at every step: Auth, then Profile, then Rooms, then Friends and Calls, then Stories and
Chapters, and finally the leftover theme, settings and shell controllers. Every feature now lives
under `lib/features/<name>/` with the same four layers. `view/` holds widgets and pages only,
`viewmodel/` holds the Riverpod notifiers that own per-screen state, `model/` holds immutable
Freezed data classes, and `data/` holds repositories for app-wide state and caching alongside
services for raw I/O. Shared code moved into `lib/core/`, `lib/shared/`, `lib/routes/` and
`lib/utils/`.

By the end of the migration GetX was removed from the codebase entirely. `GetMaterialApp` was
replaced with `MaterialApp.router`, `Obx` and `Get.put` were gone, locale handling moved to a
provider that persists to secure storage, and the `get` dependency was deleted from `pubspec.yaml`.
The global `ProviderContainer` that had been used as a GetX substitute during the transition was
also removed, so the app now has exactly one `ProviderScope` at the root and no ambient container
for anything to read from.

Alongside this I converted the core models (`User`, `Room`, `Story`, `Chapter` and every state
object) to Freezed for immutability, `copyWith` and union states, and moved navigation to GoRouter
with declarative, state-driven routes including an auth redirect and a protected-route list. Deep
linking was implemented on top of this (Issue #708). Room share links of the form
`https://resonate.aossie.org/room/<id>` are registered as verified Android App Links, parsed by
the shell, resolved against the backend and surfaced as a join dialog.

Beyond the mechanical migration, the architecture is now enforced rather than documented. A suite
of architecture tests (`test/architecture/feature_boundaries_test.dart`) fails the build if a view
model imports another feature's view model, if a view imports a platform SDK, if a data-layer
service imports a repository, or if a view reads more than one view model. Those rules caught real
violations repeatedly during the rest of the project.

## Controller Decoupling and MVVM Enforcement

Migrating the state management was only half the problem. The other half was that business logic
was spread across widgets, controllers and services with no consistent ownership. I ran a full layer
audit of every non-generated Dart file in the app and fixed each violation it turned up.

Views no longer perform platform I/O. Five pages that were calling `ImagePicker`, `ImageCropper`
and `FilePicker` directly now go through a `MediaPickerService` in `core/services/` that returns
plain paths, so `XFile` and `PlatformFile` never reach the UI. A service that imported a view model
was inverted, a view model that imported the Appwrite SDK just to generate an ID now asks its
repository for one, and six "services" that were actually calling repositories were moved up into
the data layer, so `data/services/` became a true leaf that only imports SDKs and models. An app
bootstrap notifier that was a view model with no screen became shell data. The remaining
cross-feature cycles were reduced from thirteen to eleven, with the rest being legitimate
page-to-page navigation.

The hardest judgement call was where state lives. The rule the project settled on, and which is now
written down, is a discriminator: if state must survive the screen being popped, it is repository
state, not view-model state. That is why auth session state lives in `AuthRepository`, why room
chat messages, polls and voter profiles live in `rooms/data/` rather than in a screen's view model,
and why teardown that must outlive its screen runs on a keepAlive service. This was not academic.
Two user-visible bugs (logout requiring two taps, and room teardown silently not running) were both
caused by an `autoDispose` provider's `Ref` dying across an `await`, and both were fixed by moving
the work to the right layer.

Finally, where features genuinely had a screen but no view model, I added them: `InterestsEditor`,
`FriendsList` and `FriendRequests`, which turned `FriendListTile` into a purely presentational
widget and converted its behaviour tests into view-model unit tests.

## Backend Refactor: Appwrite Schema, Query Optimization and a Major Version Upgrade

The backend started as five Appwrite databases with twenty-six tables, almost no relationships, and
a read pattern that fetched related data one row at a time. The proposal asked for relationships,
indexes and fewer round trips. The work ended up being that plus an Appwrite major upgrade, because
the index work ran into limits only the 2.x line lifts.

**Relationships and indexes.** I added eight two-way relationships with `onDelete: cascade`
(rooms to participants, messages and polls; polls to votes; messages to replies; stories to
chapters, likes and live chapters) and nine indexes. The headline finding was that the `messages`
table had no index at all, while every room open queried it by `roomId` and ordered by `index`.
Three columns were also resized. One uid column was declared as a 10,000-character string, which is
past InnoDB's 768-byte index key limit and therefore made its index impossible rather than merely
slow. Cascade deletion was verified live on the server: deleting only a room row removes its
participants and messages.

One finding is worth recording because it is counter-intuitive. Appwrite relationships cannot cross
databases, and a relationship sub-select takes no limit or ordering, so expanding `participants.*`
on a room list pulls every participant when the UI wants three. Relationships are therefore used
here for referential integrity and cascade cleanup, while reads use batched
`Query.equal('$id', chunk)` with `Query.select` instead.

**Query optimization in the app.** The N+1 patterns were removed measurably:

| Call site | Before | After |
| --- | --- | --- |
| `RoomChatRepository.loadMessages` | 1 + 100 sequential reads | **2** |
| `RoomsRepository.loadRooms` | 1 + 4R sequential (20 rooms = 81 round trips) | **3** |
| `RoomsRepository.loadParticipants` | 1 + N sequential | **2** |
| `StoriesRepository.fetchLikedStories` | 1 + N sequential | **2** |
| `ProfileRepository.fetchProfileSummary` | every follower row, to call `.length` | 2 parallel reads, `.total` only |
| `StoriesRepository.loadStoryDetail` | 4 reads in series | 1 round trip |

Room participant counts and story likes also moved to Appwrite's atomic increment and decrement
operations, which removed a read-before-write and a client-held counter. Nine tests assert the
query-count contract directly, so a regression here fails the suite rather than just being slower.

**Database consolidation.** On the mentor's reasoning that fewer databases are easier to back up, I
merged the five databases into a single database named `main`. The real argument turned out to be
restore rather than backup. Appwrite's backup policies are project-level and already covered all
five, but restoration is database-scoped, so restoring one database is one operation while
restoring five means orchestrating five and hoping they are mutually consistent. The merge touched
575 references across the app and backend, including function event triggers that embed the
database id in their trigger string and would have silently stopped firing if missed.

**Appwrite 1.8.0 to 2.3.0.** The upgrade was done as a clean install rather than a five-step
migration chain. It forced five changes the schema file had to absorb (lowercase index orders, no
null orders, no indexes on array columns, no bulk writes on tables carrying relationships, and a
substantially changed CLI surface), moved every function from the `node-16` to the `node-24`
runtime, and most importantly let me remove the manual `APPWRITE_API_KEY` entirely. All fifteen
functions that talk to Appwrite now authenticate with the ephemeral key Appwrite mints per
execution and passes in the `x-appwrite-key` header, with per-function scopes declared in the
config. The server-write-only integrity model used by the achievements system survives this, which
I proved by emptying a write-protected table and having a scheduled function re-seed it.

**Production deployment.** A production Appwrite instance now exists at
`https://appwrite.mayank4352.me`, as a separate project from local development, with all
twenty-two functions deployed and their variables verified against the config file one by one.
Documenting how function environment actually reaches the server (two tiers, only one of which the
config file can express) turned up two functions that were missing variables they declare in
`throwIfMissing` and would have thrown on their first execution.

## Polling System

Polls are now a first-class, real-time interaction inside a room's chat. A host creates a poll, it
is announced inline in the chat as an interactive card, everyone votes once, results update live
with animated share bars, and the voters' avatars stack up WhatsApp-style under each option with a
"+N" overflow. Because rooms are ephemeral, poll rows cascade away with the room, so there is no
separate lifecycle to manage, and one-vote-per-user is enforced by a unique `(pollId, uid)` index
rather than by a function.

Architecturally this is where the MVVM rules were first stress-tested. The chat message list is
long-lived, realtime-backed and shared between the chat page and the poll feature, so it moved into
the data layer, leaving the chat view model owning only the transient "replying to" state. Polls
announce themselves through the chat *message store* rather than through the chat view model, which
removed the last view-model-to-view-model edge in the codebase. Voter avatars are resolved by
reference and batched, never denormalized, and only the five actually rendered per option are
fetched.

This feature also surfaced a bug that affected the entire app, not just polls. New messages, polls
and votes only appeared after closing and reopening a screen. The cause was that the server exposes
both the TablesDB and the legacy Collections realtime APIs, so every event lists both channel forms
with the longer one first. The existing code computed a substring offset from the subscribed
channel and sliced the wrong string, producing a garbage action that matched no branch. **Every
realtime event in the application was being silently dropped.** The fix was a
format-and-order-agnostic `realtimeAction(events)` helper applied at all eight realtime call sites:
chat, polls, votes, participants, pair chat, friend calls and live chapters.

## Availability Status System

Users can now set themselves **Online**, **Do Not Disturb** or **Invisible**, and are shown
automatically as **In a room** or **Offline**. Status appears as a coloured dot on avatars
throughout the app, with a dedicated sheet in Settings for changing it.

The design decision I am most satisfied with is that activity status is **derived, not stored**.
The value written to the backend is a function of the user's chosen status, their live LiveKit
session and the app lifecycle. Choosing DND and then joining a room publishes `inroom` and reverts
to `dnd` on leaving; backgrounding while Online publishes `offline`; backgrounding while DND or
Invisible changes nothing, because dropping to offline there would silently stop blocking calls.
Writes happen only on real transitions and are de-duplicated, so there is no polling and no
heartbeat, which was the proposal's scalability requirement.

Call blocking is enforced in two layers. The client does a free pre-check against its cached copy
so no orphan call row is created, and the `start-friend-call` cloud function is the authoritative
gate, running before the callee's device rings and before either side is issued a LiveKit token.
Only `dnd` and `inroom` block. `invisible` deliberately does not, because it hides availability
without restricting the user. The gate **fails open**, so if the user row cannot be read the call
goes through and a database hiccup degrades to pre-gate behaviour rather than silently swallowing
every call. Blocked calls return HTTP 200 with a reason rather than a 4xx, because the shared
function-execution helper throws on any status at or above 400 and the client needs to read the
reason.

Status colours are a registered `ThemeExtension` rather than `ColorScheme` slots, because Resonate
ships six user-selectable themes and semantic status colours must survive all of them.

## Audio Wave Animations

Speaking participants now have a glowing waveform ring around their avatar, driven by **real audio
spectrum data** rather than a synthetic animation.

The chain runs from LiveKit's `ActiveSpeakersChangedEvent` through a controller-owned broadcast
stream, into a throttled notifier, and out through a `speakingLevelProvider(uid)` family to the
avatar widget. That family is the performance trick. A derived per-uid provider recomputes on every
map change but only notifies when *that* user's level moves, so one person talking repaints one
avatar rather than the whole grid. LiveKit's participant `identity` is the app's uid, verified
across every token-minting function in the backend, so no mapping table is needed.

The spectrum itself comes from `livekit_client`'s `createVisualizer`, a native per-track FFT. Its
payload is documented nowhere, so I read the Kotlin and Swift sources to establish that values are
normalized 0 to 1 and that the native code subtracts a floor constant before rescaling. That last
detail mattered. Real speech lands in a narrow slice near zero, so normalizing by maximum alone
preserves the squash and every band renders at the same height. Contrast-stretching each frame
against its own minimum *and* maximum is what makes the ring read as a voice. Analysers are
attached only to participants with a live, unmuted microphone, with a three-second linger so
turn-taking does not thrash the native side, because the event channel fires on the order of a
hundred times per second per track.

Two performance details are load-bearing. Silent avatars run no ticker at all, since the phase
animation only repeats while the level is above zero, so a room of twelve with one speaker runs one
ticker instead of twelve. And the painter repaints off a merged `Listenable`, so a talking avatar
repaints without rebuilding a single widget. The trap worth recording is that content painted
outside a `RepaintBoundary`'s bounds is not reliably retained, because the cull rect is a hint
rather than a clip promise, so the ring is given a real paint box via `OverflowBox` while its
layout footprint stays the avatar's size.

There is deliberately **no synthetic fallback**. The app ships Android and iOS, both of which
implement the native analyser, and a convincing fake is indistinguishable from working data, which
is exactly how a dead FFT went unnoticed for two rounds of testing. When bands are absent, nothing
is drawn.

## Feature Flag System

Users can now hide features they do not want, from **Settings → Features**. The flags are entirely
local, so nothing is sent to the backend, and they currently cover pair chat and live chapters.

Each flag is an enum value carrying an explicit storage key (spelled out rather than derived from
the enum name, so renaming a value cannot reset everyone's preference) and the list of routes the
feature owns. Flags are persisted through synchronous storage initialized in `main`, so the first
frame and the router redirect have no async gap, and the default is always *enabled*, so shipping a
new flag never hides anything from an existing user. Adding a flag requires two gates: hiding every
entry point, and a router redirect that bounces the feature's routes so deep links and programmatic
pushes are covered too. Both the settings screen and the router iterate the enum, and the UI uses
exhaustive switch expressions, so a new flag fails to compile until it has a title, description and
icon.

The decision worth recording is *why* local-only is sufficient for these two features: both are
pull-based. You enter the pair-chat pool only by creating a request, and live chapters only appear
on a story page you open. Neither has a passive inbound surface. A feature with an inbound surface,
friend calls for instance, would need backend support instead, and the activity status system is
how that case is handled.

Building this feature also turned up four `RenderFlex` overflows on 360dp phones that the existing
widget tests had been hiding by pumping at wider viewports. All four were fixed, and a regression
test now pumps the profile page at 360dp, where an overflow fails the test by itself.

## User Discovery via Interest-Based Search

Users can pick up to five interests from sixteen during onboarding or later from a Preferences
screen, and find people who share them through a filter button built into the Explore search bar.
Stories gained free-form creator-authored tags, rendered as chips and searchable alongside titles
and descriptions.

Interest selection is optional and revisable, which was the privacy requirement in the proposal.
Unknown wire values are dropped when parsing rather than throwing, so a tag added server-side can
never break an existing profile. The filter is deliberately uncapped even though a profile's own
interests are capped at five, because with a `contains` query every extra tag widens the search and
capping the filter would only hide people. Results name the *shared* interests on each row, so the
user can see why a profile matched. The filter is an `autoDispose` provider holding a generation
counter, so a slow response for a stale selection is discarded rather than overwriting a newer tap.

The interests feature is structured as a "service feature", with data, model and view but no view
model, because it is consumed by three different features: profile (onboarding), settings
(preferences) and stories (the explore search bar).

**Semantic story search** was added on top. `StoriesRepository` walks a four-step ladder that
degrades rather than depending on configuration: a Meilisearch hybrid query with an embedder and a
ranking-score threshold, falling back to keyword-only on the same index if no embedder is
configured, falling back to the Appwrite tag query if the index is unreachable, and finally to an
empty result rather than an exception. The switch is the presence of a Meilisearch client, not a
boolean flag inside the repository, which also meant the repository stopped constructing its own
network client and tests stopped creating real ones. A runbook for activating it (embedder
configuration, backfill, build flags, tuning and rollback) is documented, and the app-side README
gained a Search section.

This is also the one deliverable with a real caveat, stated plainly: **semantic ranking is inert
until a Meilisearch server with a configured embedder exists**, which AOSSIE does not currently
host. Additionally, Appwrite 2.3 does not support indexes on array columns, so interest filtering
and story-tag search are correct but unindexed. Both were verified to return correct results, since
`Query.contains` does not require an index, and both are documented for the mentor.

## User Stats Tracking and Gamification

Users now accumulate verified activity statistics and earn badges across five categories: Hosting
(Welcomer, Icon, Maestro), Moderation (Guard, Sentinel, Warden), Echo (interactions), Rhythm
(streaks) and Core (active days). Each category holds at most one badge, the highest tier the
metric qualifies for. Users showcase two badges as pills beside their name and wear one on their
avatar, which is the proposal's "three achievements simultaneously".

The principle behind the whole system is that **a badge is evidence, not a claim**. The `user_stats`
table is `read("any")` and write-nobody, and the only writer is a cloud function holding the key.
Contrast that with every other table in the project, which is openly writable. Room credit is
client-*triggered* but server-*verified*: the app calls when it observes more than five
participants, and the function independently re-reads the room's admin, the caller's participant
row and the live head count before granting anything. The client only says *when* to look.
Idempotency comes from a deterministic row id derived from `(roomId, uid, role)`, and the credit
row is written *before* the counter moves, so a concurrent duplicate loses on the conflict.

Thresholds live in a configurable table rather than being hardcoded, badges are never revoked, and
Rhythm measures the longest streak rather than the current one so a broken streak needs no special
case. Interactions cannot be server-verified the way room roles can, so they are capped at a
hundred per UTC day, which bounds the damage rather than pretending the problem does not exist. A
nightly reconciler seeds the thresholds table on a fresh install, repairs missed awards and prunes
an unearned showcase.

On the presentation side, the badge shares the activity dot's corner rather than adding a second
mark to the avatar, with the status colour as a backdrop and the badge glyph drawn on top, so the
activity status feature stays entirely ignorant of achievements. Badge colours are a
`ThemeExtension` for the same reason status colours are. No new pages were added, since everything
lands on existing surfaces plus a bottom sheet opened from Settings.

## Rooms Screen and Friends Call UI Revamp, Miniplayer and Picture-in-Picture

The room screen was rebuilt around a featured host card and a three-column participant grid, with a
floating pill toolbar instead of a full-width footer, tag chips in the header, role labels, a
microphone status dot on the avatar and the speaking ring from the waveform feature. The friend
call screen was reworked to a focused single-party stage with a compact self tile. Both got a
proper avatar fallback, since the previous code passed a possibly-empty URL straight to
`NetworkImage`.

Two data-layer bugs were fixed along the way. Participant ordering is now a *stable* sort, because
Dart's `List.sort` is not stable and the old comparator returned equal for same-rank participants,
so tiles reshuffled on every realtime event. And role changes now apply an optimistic local update,
because Appwrite's realtime echo of your own write cannot be relied upon.

**The miniplayer** lets a user minimise an ongoing room or call into a persistent bar and keep
talking while browsing the rest of the app, and on Android it extends into **Picture-in-Picture** so
the session survives leaving the app entirely. Closing the room sheet is minimise, not leave, a
product rule that is now pinned by a test. The session that the miniplayer presents is chosen
globally (a connected call first, otherwise an active room), it shows the loudest current speaker,
and a host who taps Leave from the miniplayer gets the room sheet restored so the confirm dialog
appears in context rather than as a bare dialog over an unrelated screen.

**The profile pop-out** completes the proposal's third item here. Long-pressing a participant opens
a read-only card with their avatar, handle, showcase badges, follower count and rating, so a host
can size someone up for a moderator role without leaving the conversation. Tap and long-press were
split. Before this, a listener's long press opened the role menu with an empty item list, which
rendered as a blurred overlay containing nothing.

Ten distinct bugs were found and fixed on top of this feature, each with a test. The ones worth
naming: entering Picture-in-Picture twice (once armed automatically, once manually) crashed the
Android system UI and took the app with it; the miniplayer flashed over the ringing screen because
a call is marked connected a beat before its page is pushed; minimising a call landed the user on
the "Calling…" screen whose Cancel button ended the call; the room list still offered "Join" for the
room you were already in, which would have written a second participant row; and avatars were stale
everywhere outside rooms because `profileImageUrl` is copied into the friends row and again into the
call row and never refreshed.

Later in the project the user-facing session screens were consolidated. The room, live chapter,
friend call and pair chat screens now share one declarative `SessionControlBar`, a
`SessionParticipantCard`, a `SessionStage` and a single exit-confirmation flow, which took
`participant_block.dart` from 440 lines to 229 and the live chapter attendee block from 240 to 51.
I did not reuse `RoomPage` itself, and said why: the two pages read differently-shaped providers,
have different lifecycles and different moderation, and rendering one from the other would force a
cross-feature import the architecture tests forbid.

## Improve Test Coverage

Resonate's test suite grew from roughly 270 tests at the end of the state migration to **1,486
tests**, with measured line coverage of **88.7%** excluding generated localizations.

That exclusion is the honest number and deserves explaining. `lib/l10n/` is about 6,000 lines of
`flutter gen-l10n` output across ten locales which nothing can meaningfully test, and counting it
drags the raw figure down to 65.5% permanently. Any coverage gate on this project should exclude
that directory.

Coverage was raised in deliberate passes rather than by chasing line count. The first pass targeted
untested *logic*, and the pattern across all of it was the same. The uncovered lines were almost
entirely the best-effort `try`/`catch` arms that decide whether a failed push, upload, delete or
realtime hiccup is allowed to surface to the user. Those are exactly the contracts worth pinning,
and nobody had. Later passes covered the form pages, the shared widgets and the long tail of views.

The practical ceiling here is about 95%. Of the remaining gap, roughly 14% is generated code and
15% is platform-bound: the LiveKit session wrapper and the native FFT tracker cannot be unit tested
without a live room, which is why those were verified from device logs instead.

The tests paid for themselves. **Eight real bugs** were found and fixed by writing them, all in
view code: a date picker that was completely unreachable because its only entry point painted
outside its hit-test box; an edit-profile screen that silently discarded a name-only edit because
the unsaved-changes guard never rebuilt; a back gesture on any non-home tab exiting the app
entirely; a search overlay calling `setState` during build; a search result row that force-unwrapped
four nullable fields and took the whole explore list down on a partial row; a `launchUrl` call that
was not awaited inside a `try`/`catch`, so a failed launch escaped as an unhandled async error; and
two layout overflows on ordinary phone widths.

Architecture tests were added as part of this work and are the enforcement mechanism for everything
in the MVVM sections above.

## Recorded Live Chapters Tracking System

Live chapter recordings already existed on disk with no metadata persisted anywhere. The transcript
only lived in memory between the session ending and the verify screen, and a recording abandoned at
that screen was orphaned forever with no way to see or delete it. This feature makes them a managed
archive.

Recordings are now indexed when the live chapter *ends*, not when it is published, precisely so that
abandoned recordings remain visible and deletable. A Recorded Chapters screen (reachable from
Settings, and gated on the live-chapter feature flag) lists them newest-first, dropping and
rewriting the index for entries whose audio has been removed. A detail screen plays the recording
with a scrubber, renders the transcript as tappable lines that seek the player with the active line
highlighted, and allows editing the details or deleting the recording and its audio files.

The most valuable change here was not the UI. The author had reported "a very big delay after
ending a live chapter before actually being out of it", and the logs showed exactly why.
`endLiveChapter()` awaited ffmpeg conversion and the entire Whisper transcription pass *before*
deleting the room, disconnecting and navigating away. The author sat on a dead screen, still
connected, for roughly as long as the recording was. Transcription now runs off the teardown path
entirely: the session tears down and returns immediately, and transcription and archiving continue
in the background on a keepAlive provider that outlives the screen, reporting progress into the
state. The verify screen primes its lyrics field from whatever has arrived and listens for the rest,
filling the field only while it is still empty so it never overwrites the author's edits, and the
Create button is disabled while transcription is in flight so a chapter cannot be filed without
lyrics that are seconds away.

## Work Beyond the Proposal

### Documentation, governance and contributor experience

I updated the project's expired documentation and added the governance files a maintained
open-source project is expected to have: a `MAINTAINERS.md`, an `AGENTS.md` describing the
architecture, commands and the project's real hazards for anyone (human or tooling) working in the
repo, a brand guide, and an OpenSSF-style `BestPracticesChecklist.md` with a GitHub Actions workflow
and scoring script that regenerates its score table automatically. The README was brought up to
date and the contributor setup scripts were ported to the current Appwrite CLI.

### Social notifications

Likes, follows and room subscriptions now notify the person they concern. The blocker that shaped
this was that **there was no user-to-token mapping anywhere in the system**. FCM tokens were only
ever written as per-row copies readable by a function that already had the row, and the one stored
on a followers row belongs to the *follower*, which is the wrong direction. This required a new
`fcmTokens` column on the users table, a `send-social-notification` function that targets one user
rather than fanning out, and token pruning on the recognised "not registered" error codes so dead
devices are not retried forever. All three trigger points are best-effort, because the row is
already written and a failed push must never surface as a failed like, follow or subscribe.

### Security and transport hardening

The Appwrite endpoint scheme is now configurable, release builds pass HTTPS, and cleartext traffic
is permitted only in the debug and profile manifests, so a release build cannot be downgraded to
HTTP. This was verified against the *merged* manifests rather than assumed. `setSelfSigned` is now
`kDebugMode`-only; it previously shipped unconditionally, which defeats HTTPS for every user.
`allowBackup` and `fullBackupContent` are off, so a session cannot be pulled off an unlocked device.
Two pre-existing bugs were fixed while collapsing the URL-construction sites: every placeholder
avatar and cover URL hardcoded the project id as the literal string `resonate`, and one of them
carried the parameter twice.

One consequence was accepted deliberately and should be stated. Rows written before the switch hold
absolute `http://` URLs, so pre-existing avatars, covers and chapter audio do not load in a release
build. The data was stale and the mentor's call was not to migrate it.

### Performance work

Beyond the query optimization above, I established CPU-profiling readiness (verifying that profile
builds reach the backend, that `--dart-define`s carry over, and that all heavy native work already
runs off the UI isolate), fixed the "wave lags the voice" complaint by warming up FFT analysers from
live microphone state rather than from speech, bounded four unbounded per-uid provider caches that
were leaking a provider for every user ever rendered, removed two feature dependency cycles, and ran
a project-wide dead-code audit that removed 21 unused size constants, 55 unused localization keys
across ten locales, two orphaned assets and five unreferenced declarations.

The discipline I adopted here is worth recording, because I got it wrong first. I converted the
Explore page to slivers to fix a `shrinkWrap` anti-pattern, then checked the actual bounds and found
the page renders at most six suggestion rows, sixteen search results and twenty-five interest
matches. It was incapable of being slow. The change was reverted, and the rule since has been to
establish the bound (the server limit, the frequency, the N) *before* implementing a performance
fix, and to say so or ask rather than writing the code first.

### Deep links and release engineering

Room sharing now includes the link in all ten locales, with the URL segment read by both the builder
and the parser so they cannot drift. I diagnosed why those links currently 404. The website
publishes only the Play app-signing fingerprint, so locally-signed builds fail App Links
verification, and the site has no `/room` route. I specified the exact website-side change needed,
which is a redirect rule rather than a hosted page.

For iOS, I audited the App Store gap list and wrote and committed the pieces that can be written
from Windows: a `PrivacyInfo.xcprivacy` manifest with each collected data type grounded in a real
field and the required-reason API declarations, real `NS*UsageDescription` strings replacing the
placeholders Apple rejects, and the `remote-notification` background mode. The `voip` background
mode was deliberately *not* added, because App Review rejects a declared background mode the app
does not use and the iOS CallKit side is unimplemented.

### Bug fixing and stabilization

A substantial amount of the back half of the project was finding and fixing bugs that the new
features exposed in old code. The ones with the widest blast radius: every realtime event in the app
being silently dropped (described under Polling); new participants being invisible after the
relationship migration, because a row carrying a relationship is reported by Appwrite as both a
create *and* an update and only one branch handled it; the live rooms list having no realtime
subscription at all; pull-to-refresh being present but structurally unable to fire, because the
empty and error states were not scrollable; new stories never appearing in the recommended list
because that query had no ordering at all and returned the oldest ten; logout requiring two taps;
rooms resurrecting themselves after being ended because an in-flight list reload resolved with a
pre-delete snapshot; and everyone in a room seeing "you have been reported or removed" when a host
simply ended it.

Every Material `SnackBar` in the app was also replaced with the project's own overlay snackbar for
consistency, and the two cases where a departure showed the wrong message were fixed properly rather
than by suppressing the toast.

## Acting as an Active Maintainer

Throughout the project I worked as part of the maintenance of the Resonate repositories alongside my
own deliverables, keeping documentation current, adding the governance and quality-checklist
tooling, fixing contributor-facing breakage in the setup scripts and workflows, and keeping the
backend's configuration honest so that a new contributor can provision a working instance from a
clean clone. I intend to keep contributing to Resonate and AOSSIE after GSoC.

# PRs before Mid Term Evaluation

## Frontend Repo

| Pull Request # | Pull Request Title | Status | Pull Request Contributions |
| --- | --- | --- | --- |
| [PR #816](https://github.com/AOSSIE-Org/Resonate/pull/816) | Fixed the state error in app prefs page | Merged | Fixes a state-handling error on the app preferences page |
| [PR #818](https://github.com/AOSSIE-Org/Resonate/pull/818) | Refactored Auth feature to Riverpod and MVVM | Merged | First feature migrated off GetX, establishing the feature-based MVVM layering, Riverpod providers and Freezed models that every later migration follows |
| [PR #820](https://github.com/AOSSIE-Org/Resonate/pull/820) | fix: fixed broken workflow | Merged | Repairs the repository's CI workflow |
| [PR #822](https://github.com/AOSSIE-Org/Resonate/pull/822) | Refactored Profile Logic to Feature based MVVM with Riverpod | Merged | Migrates profile and onboarding, including the repository that owns durable user state |
| [PR #824](https://github.com/AOSSIE-Org/Resonate/pull/824) | Refactored Rooms logic to feature based MVVM with Riverpod | Merged | Migrates the rooms feature (participants, roles, lifecycle and realtime) to Riverpod view models and repositories |
| [PR #827](https://github.com/AOSSIE-Org/Resonate/pull/827) | Refactored Friends and Call logic to feature based MVVM architecture | Merged | Migrates friends, friend calls and pair chat, including the call coordinators that outlive any screen |
| [PR #829](https://github.com/AOSSIE-Org/Resonate/pull/829) | Refactored Stories and Chapter logic to feature based MVVM architecture | Merged | Migrates stories, chapters and live chapters |
| [PR #833](https://github.com/AOSSIE-Org/Resonate/pull/833) | Refactored the leftover logic to feature based MVVM architecture | Merged | Migrates theme, settings, network and shell; swaps `GetMaterialApp` for `MaterialApp.router`; removes the `get` dependency and the global `ProviderContainer` |
| [PR #836](https://github.com/AOSSIE-Org/Resonate/pull/836) | Added the leftover tests and cleaning any inconsistencies | Merged | Post-migration cleanup pass and the tests the migration made possible |
| [PR #838](https://github.com/AOSSIE-Org/Resonate/pull/838) | Removed unwanted assets files and redundancy | Merged | Removes dead assets, unused dependencies and duplicated code uncovered by the migration |
| [PR #839](https://github.com/AOSSIE-Org/Resonate/pull/839) | Migrate Resonate to Feature Based MVVM with Riverpod | Open | The integration PR that merges the completed migration branch into `dev`; every later feature PR is stacked on it |

# PRs after Mid Term Evaluation

All feature work after the migration is stacked on the `state_migration` integration branch, so each
PR below is opened against it rather than directly against `dev` and reviews as a clean, isolated
diff.

## Frontend Repo

| Pull Request # | Pull Request Title | Status | Pull Request Contributions |
| --- | --- | --- | --- |
| [PR #841](https://github.com/AOSSIE-Org/Resonate/pull/841) | Implemented polling feature | Open | Chat-integrated live polls with one vote per user, live result bars and voter avatars; also contains the app-wide realtime-event fix |
| [PR #843](https://github.com/AOSSIE-Org/Resonate/pull/843) | Architectural design flaw in api_service.dart | Open | Splits a core god-service into a shared execute helper, one genuinely shared service, and per-feature repository methods |
| [PR #845](https://github.com/AOSSIE-Org/Resonate/pull/845) | Implement presence states (Online, InRoom, DND, Invisible) | Open | Activity status system with derived status, a server-side call gate and themed status indicators |
| [PR #847](https://github.com/AOSSIE-Org/Resonate/pull/847) | Audio-Wave animation around the speaker's avatar | Open | Real-audio-spectrum speaking rings driven by LiveKit's native FFT |
| [PR #849](https://github.com/AOSSIE-Org/Resonate/pull/849) | Updating Expired Documentation and adding Workflows | Open | `AGENTS.md`, `MAINTAINERS.md`, brand guide, best-practices checklist with an automated scoring workflow, README refresh |
| [PR #851](https://github.com/AOSSIE-Org/Resonate/pull/851) | Implemented local feature flags to dynamically enable/disable features | Open | User-controlled local feature flags with entry-point and router gating |
| [PR #855](https://github.com/AOSSIE-Org/Resonate/pull/855) | Implement badge system using threshold-based logic | Open | User statistics and the five-category badge system, server-verified and write-protected |
| [PR #857](https://github.com/AOSSIE-Org/Resonate/pull/857) | Added Onboarding interest selection and filtering logic for profiles | Open | Interest selection, interest-based profile filtering, free-form story tags and the hybrid/semantic story search ladder |
| [PR #859](https://github.com/AOSSIE-Org/Resonate/pull/859) | Redesigned and Implemented Rooms screen UI | Open | Featured host card, participant grid, floating toolbar, mic dot, stable participant ordering and optimistic role updates |
| [PR #861](https://github.com/AOSSIE-Org/Resonate/pull/861) | Bugs and improvements in Logout, Room creation and Room exit | Open | Fixes logout needing two taps, room teardown not running, rooms resurrecting after being ended, and the create-room keyboard |
| [PR #863](https://github.com/AOSSIE-Org/Resonate/pull/863) | Improved Friend Call screen UI with mini-player addition and profile Pop-Out function | Open | Friend call stage, miniplayer, Android Picture-in-Picture, long-press profile card, and ten bugs fixed on top |
| [PR #865](https://github.com/AOSSIE-Org/Resonate/pull/865) | Optimized data schemas to improve app performance | Open | App-side half of the schema work: N+1 removal, atomic counters, and the database consolidation |
| [PR #869](https://github.com/AOSSIE-Org/Resonate/pull/869) | Implement UI for viewing, and deleting recorded sessions | Open | Recorded Chapters archive with playback and transcript seeking; moves transcription off the teardown path; consolidates the live-session screens |
| [PR #871](https://github.com/AOSSIE-Org/Resonate/pull/871) | Improved room performance and improved app test coverage | Open | Rebuild-churn reduction, dead-code removal, the coverage programme to 88.7%, and the eight view-layer bugs it found |
| [PR #873](https://github.com/AOSSIE-Org/Resonate/pull/873) | Updated the build scripts and improved feature implementation | Open | MVVM audit fixes and enforcement tests, social notifications, HTTPS and security hardening, room deep links and the iOS release groundwork |

## Backend Repo

| Pull Request # | Pull Request Title | Status | Pull Request Contributions |
| --- | --- | --- | --- |
| [PR #175](https://github.com/AOSSIE-Org/Resonate-Backend/pull/175) | feat: implemented polling feature | Open | Poll and vote tables, the unique one-vote-per-user index, and poll cleanup in the room lifecycle |
| [PR #177](https://github.com/AOSSIE-Org/Resonate-Backend/pull/177) | Implement presence states (Online, Idle, DND, Invisible) | Open | The `status` column and the `start-friend-call` presence gate; also repairs eight invalid SDK calls and thirteen stale environment keys left by the 1.8.0 upgrade |
| [PR #179](https://github.com/AOSSIE-Org/Resonate-Backend/pull/179) | Added tracking metrics for users | Open | `user_stats`, `achievement_thresholds` and `room_credits` tables, the write-protected `record-activity` function and the nightly reconciler |
| [PR #181](https://github.com/AOSSIE-Org/Resonate-Backend/pull/181) | Added Onboarding interest selection and filtering logic | Open | Interest and tag columns with their indexes |
| [PR #183](https://github.com/AOSSIE-Org/Resonate-Backend/pull/183) | Optimizing data schemas to improve app performance | Open | Relationships, indexes and column resizes; the Appwrite 1.8 to 2.3 upgrade; the move onto per-execution API keys; the five-database consolidation into `main` |
| [PR #186](https://github.com/AOSSIE-Org/Resonate-Backend/pull/186) | Addition of Social Notification feature | Open | The `users.fcmTokens` column and the `send-social-notification` function with stale-token pruning |


## For using and experiencing the features implemented by me as part of GSoC 2026, please download the Resonate App:

<p align="center">
    <a href="https://play.google.com/store/apps/details?id=com.resonate.resonate&pcampaignid=web_share">
        <img src="../store_listing/download-from-google-play.svg" alt="Download from Google Play" style="width: 250px; height: auto;">
    </a>
</p>

# Conclusion

My GSoC 2026 project set out to do two things that usually pull against each other: add substantial
user-facing features, and rebuild the architecture underneath them. Resonate now runs on Riverpod
with a feature-first MVVM structure whose rules are enforced by tests rather than by convention, on
an Appwrite backend with real relationships, real indexes and a single consolidated database, and
with a test suite that grew from roughly 270 tests to 1,486 at 88.7% line coverage. On top of that
foundation it gained live polls, presence and call gating, real-audio speaking rings, local feature
flags, interest-based discovery, a verified achievements system, a redesigned room and call
experience with a miniplayer and Picture-in-Picture, and a managed archive for recorded live
chapters.

Every feature and improvement proposed as part of the project was delivered. The two items my
proposal listed as optional, to be attempted only if time permitted, were not taken up: RNNoise
noise suppression, which needs the ability to replace the outgoing audio stream before LiveKit
publishes it and runs into the same upstream `flutter_webrtc` limitation that blocked the
accessibility work in the previous cycle, and live room reactions, which is the lowest-risk of the
two and the most natural next contribution, since the data-channel plumbing it needs is already in
place and the in-room poll card establishes the overlay patterns it would follow.

The work that I did not plan for taught me the most: that every realtime event in the application
had been silently discarded for months, that a performance fix is worthless until you have measured
the bound it is supposed to improve, and that a convincing fallback can hide a dead data source
indefinitely. Those lessons are written into the repository's documentation so the next contributor
does not have to rediscover them.

I am grateful to Google, to AOSSIE and to my mentors for the opportunity, and I intend to keep
contributing to Resonate and to open source well beyond this program.
