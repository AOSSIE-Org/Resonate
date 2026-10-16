import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/profile/view/pages/edit_profile_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';

import '../../../helpers/test_root_container.dart';
import '../profile_test_helpers.dart';

class _FailingProfileRepository extends FakeProfileRepository {
  @override
  Future<void> updateDisplayName({
    required String uid,
    required String name,
  }) async => throw Exception('network down');
}

// The username field debounces its availability check by 800ms.
const _pastDebounce = Duration(milliseconds: 900);

void main() {
  late FakeProfileRepository repo;

  setUp(() => repo = FakeProfileRepository());

  Future<void> pumpEditProfile(
    WidgetTester tester, {
    String displayName = 'Test User',
    String? userName = 'TestUser',
    String? profileImageUrl = 'https://example.com/image.jpg',
    String? profileImageID = 'image123',
  }) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(
            AuthState.authenticated(
              fakeAuthUser(
                displayName: displayName,
                userName: userName,
                profileImageUrl: profileImageUrl,
                profileImageID: profileImageID,
              ),
            ),
          ),
        ),
        profileRepositoryProvider.overrideWithValue(repo),
        storiesRepositoryProvider.overrideWithValue(FakeStoriesRepository()),
        ...activityStatusOverrides(),
        ...achievementOverrides(),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authSessionProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: profileTestApp(const EditProfilePage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder nameField() => find.byType(TextFormField).at(0);
  Finder usernameField() => find.byType(TextFormField).at(1);
  Finder saveButton() => find.widgetWithText(ElevatedButton, 'Save changes');

  bool saveEnabled(WidgetTester tester) =>
      tester.widget<ElevatedButton>(saveButton()).onPressed != null;

  // The form scrolls; the button sits below the fold at the test viewport.
  Future<void> tapSave(WidgetTester tester) async {
    await tester.ensureVisible(saveButton());
    await tester.pumpAndSettle();
    await tester.tap(saveButton());
    await tester.pumpAndSettle();
  }

  group('initial state', () {
    testWidgets('prefills the name and username of the signed-in user', (
      tester,
    ) async {
      await mockNetworkImagesFor(
        () => pumpEditProfile(tester, displayName: 'Ada', userName: 'ada_dev'),
      );

      expect(find.text('Ada'), findsOneWidget);
      expect(find.text('ada_dev'), findsOneWidget);
    });

    testWidgets('offers the name, username and change-email controls', (
      tester,
    ) async {
      await mockNetworkImagesFor(() => pumpEditProfile(tester));

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(
        find.widgetWithText(OutlinedButton, 'Change Email'),
        findsOneWidget,
      );
      expect(saveButton(), findsOneWidget);
    });

    // The username starts out as the user's own, so it is available by
    // definition and the form opens ready to save.
    testWidgets('starts available, so saving is enabled', (tester) async {
      await mockNetworkImagesFor(() => pumpEditProfile(tester));

      expect(find.byIcon(Icons.verified_outlined), findsOneWidget);
      expect(saveEnabled(tester), isTrue);
    });
  });

  group('username validation', () {
    testWidgets('a short username is rejected by the field', (tester) async {
      await mockNetworkImagesFor(() => pumpEditProfile(tester));

      await tester.enterText(usernameField(), 'abc');
      await tester.pump();

      expect(
        find.text('Username should contain more than 7 characters.'),
        findsOneWidget,
      );
    });

    testWidgets('an illegal character is rejected by the field', (
      tester,
    ) async {
      await mockNetworkImagesFor(() => pumpEditProfile(tester));

      await tester.enterText(usernameField(), 'not a username!');
      await tester.pump();

      expect(
        find.textContaining('Only letters, numbers, dots'),
        findsOneWidget,
      );
    });

    // A malformed username must not reach the backend at all — the check is
    // skipped rather than run and rejected.
    testWidgets('a malformed username is never looked up', (tester) async {
      await mockNetworkImagesFor(() => pumpEditProfile(tester));

      await tester.enterText(usernameField(), 'short');
      await tester.pump(_pastDebounce);

      expect(repo.isUsernameAvailableArg, isNull);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(saveEnabled(tester), isFalse);
    });
  });

  group('the availability check', () {
    testWidgets('shows a spinner while it is in flight', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);

        await tester.enterText(usernameField(), 'available_name');
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(saveEnabled(tester), isFalse, reason: 'still checking');

        await tester.pump(_pastDebounce);
      });
    });

    testWidgets('marks a free username available', (tester) async {
      repo.usernameAvailableReturn = true;
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);

        await tester.enterText(usernameField(), 'available_name');
        await tester.pump(_pastDebounce);
        await tester.pumpAndSettle();
      });

      expect(repo.isUsernameAvailableArg, 'available_name');
      expect(repo.isUsernameAvailableCurrent, 'TestUser');
      expect(find.byIcon(Icons.verified_outlined), findsOneWidget);
      expect(saveEnabled(tester), isTrue);
    });

    testWidgets('marks a taken username unavailable and blocks saving', (
      tester,
    ) async {
      repo.usernameAvailableReturn = false;
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);

        await tester.enterText(usernameField(), 'taken_name');
        await tester.pump(_pastDebounce);
        await tester.pumpAndSettle();
      });

      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(saveEnabled(tester), isFalse);
    });

    // Only the last keystroke should cost a round trip.
    testWidgets('debounces a burst of typing into one lookup', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);

        await tester.enterText(usernameField(), 'first_name');
        await tester.pump(const Duration(milliseconds: 100));
        await tester.enterText(usernameField(), 'second_name');
        await tester.pump(const Duration(milliseconds: 100));
        await tester.enterText(usernameField(), 'third_name');
        await tester.pump(_pastDebounce);
        await tester.pumpAndSettle();
      });

      expect(repo.isUsernameAvailableArg, 'third_name');
      expect(repo.isUsernameAvailableCalls, 1);
    });
  });

  group('saving', () {
    testWidgets('writes a changed display name', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester, displayName: 'Old Name');

        await tester.enterText(nameField(), 'New Name');
        await tapSave(tester);
      });

      expect(repo.updateDisplayNameArgs?.name, 'New Name');
      expect(repo.changeUsernameArgs, isNull, reason: 'username untouched');
    });

    testWidgets('writes a changed username', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester, userName: 'old_username');

        await tester.enterText(usernameField(), 'new_username');
        await tester.pump(_pastDebounce);
        await tester.pumpAndSettle();
        await tapSave(tester);
      });

      expect(repo.changeUsernameArgs?.oldUsername, 'old_username');
      expect(repo.changeUsernameArgs?.newUsername, 'new_username');
    });

    // Nothing was edited, so nothing should be written.
    testWidgets('an untouched form writes nothing', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);

        await tapSave(tester);
      });

      expect(repo.updateDisplayNameArgs, isNull);
      expect(repo.changeUsernameArgs, isNull);
    });

    testWidgets('an empty name fails validation and writes nothing', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);

        await tester.enterText(nameField(), '');
        await tapSave(tester);
      });

      expect(find.text('Required field'), findsOneWidget);
      expect(repo.updateDisplayNameArgs, isNull);
    });
  });

  group('the profile picture sheet', () {
    Future<void> openSheet(WidgetTester tester) async {
      await tester.tap(find.bySemanticsLabel('Upload profile picture'));
      await tester.pumpAndSettle();
    }

    testWidgets('offers camera, gallery and remove', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);
        await openSheet(tester);
      });

      expect(find.text('Change profile picture'), findsOneWidget);
      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
    });

    // There is nothing to remove when the user never set a picture.
    testWidgets('hides remove when there is no picture', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester, profileImageUrl: null);
        await openSheet(tester);
      });

      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Remove'), findsNothing);
    });

    testWidgets('removing the picture queues the deletion on save', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);
        await openSheet(tester);

        // The label is not tappable; the IconButton above it is.
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();
        await tapSave(tester);
      });

      expect(repo.deletedImageId, 'image123');
      expect(repo.clearedImageRowUid, isNotNull);
    });
  });

  group('leaving with unsaved work', () {
    PopScope popScope(WidgetTester tester) =>
        tester.widgetList(find.byWidgetPredicate((w) => w is PopScope)).first
            as PopScope;

    testWidgets('an untouched form may be popped', (tester) async {
      await mockNetworkImagesFor(() => pumpEditProfile(tester));

      expect(popScope(tester).canPop, isTrue);
    });

    // A half-finished edit should not vanish on a back gesture.
    testWidgets('an edited form refuses the pop', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);
        await tester.enterText(nameField(), 'New Name');
        await tester.pumpAndSettle();
      });

      expect(popScope(tester).canPop, isFalse);
    });

    testWidgets('backing out offers to save first', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);
        await tester.enterText(nameField(), 'New Name');
        await tester.pumpAndSettle();

        popScope(tester).onPopInvokedWithResult!(false, null);
        await tester.pumpAndSettle();
      });

      expect(find.text('Save changes'), findsWidgets);
      expect(
        find.textContaining('any unsaved changes will be lost'),
        findsOneWidget,
      );
      expect(find.text('DISCARD'), findsOneWidget);
    });

    testWidgets('discarding writes nothing', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);
        await tester.enterText(nameField(), 'New Name');
        await tester.pumpAndSettle();
        popScope(tester).onPopInvokedWithResult!(false, null);
        await tester.pumpAndSettle();

        await tester.tap(find.text('DISCARD'));
        await tester.pumpAndSettle();
      });

      expect(repo.updateDisplayNameArgs, isNull);
    });

    testWidgets('choosing save writes the change', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpEditProfile(tester);
        await tester.enterText(nameField(), 'New Name');
        await tester.pumpAndSettle();
        popScope(tester).onPopInvokedWithResult!(false, null);
        await tester.pumpAndSettle();

        await tester.tap(find.text('SAVE'));
        await tester.pumpAndSettle();
      });

      expect(repo.updateDisplayNameArgs?.name, 'New Name');
    });
  });

  // The edit is still in the fields; the page must not close or wedge.
  testWidgets('a failed save leaves the form usable', (tester) async {
    repo = _FailingProfileRepository();
    await mockNetworkImagesFor(() async {
      await pumpEditProfile(tester);
      await tester.enterText(nameField(), 'New Name');
      await tapSave(tester);
    });

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('New Name'), findsOneWidget);
    expect(saveEnabled(tester), isTrue);
  });
}
