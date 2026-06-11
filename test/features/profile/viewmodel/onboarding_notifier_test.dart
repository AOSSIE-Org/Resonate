import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/profile/data/profile_repository.dart';
import 'package:resonate/features/profile/model/onboarding_state.dart';
import 'package:resonate/features/profile/viewmodel/onboarding_notifier.dart';

import '../../../helpers/test_root_container.dart';
import '../fake_profile_repository.dart';

void main() {
  late FakeProfileRepository repo;
  late FakeAuthRepository auth;
  late ProviderContainer container;

  setUp(() async {
    repo = FakeProfileRepository();
    auth = FakeAuthRepository(
      AuthState.needsOnboarding(
        fakeAuthUser(
          uid: 'u1',
          email: 'new@test.com',
          isProfileComplete: false,
        ),
      ),
    );
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        profileRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authProvider.future);
  });

  Onboarding notifier() => container.read(onboardingProvider.notifier);

  Future<OnboardingResult> save() => notifier().saveProfile(
        name: 'New User',
        username: 'newuser',
        dob: '01-01-2000',
        fallbackImageUrl: 'http://placeholder',
      );

  test('returns usernameUnavailable and skips creation when taken', () async {
    repo.usernameAvailableReturn = false;
    final result = await save();
    expect(result.status, OnboardingStatus.usernameUnavailable);
    expect(repo.createUsernameRowArgs, isNull);
    expect(container.read(onboardingProvider).usernameAvailable, false);
  });

  test('happy path without a picture uses the fallback url', () async {
    final before = auth.loadCount;
    final result = await save();

    expect(result.status, OnboardingStatus.success);
    expect(repo.createUsernameRowArgs?.username, 'newuser');
    expect(repo.updateAccountNameArg, 'New User');
    expect(repo.createUserRowUid, 'u1');
    expect(repo.createUserRowData?['profileImageUrl'], 'http://placeholder');
    expect(repo.createUserRowData?['profileImageID'], isNull);
    expect(repo.markProfileCompleteCount, 1);
    expect(auth.loadCount, before + 1);
  });

  test('happy path with a picture uploads and uses the returned url/id',
      () async {
    notifier().setProfileImagePath('local.jpg');
    final result = await save();

    expect(result.status, OnboardingStatus.success);
    expect(repo.uploadProfileImageCount, 1);
    expect(repo.createUserRowData?['profileImageUrl'], 'https://img/u1');
    expect(repo.createUserRowData?['profileImageID'], 'imgid-u1');
  });

  test('maps the invalid-documentId error to invalidUsernameFormat', () async {
    repo.createUsernameRowError = Exception('Invalid `documentId` param');
    final result = await save();
    expect(result.status, OnboardingStatus.invalidUsernameFormat);
  });

  test('maps other errors to a generic error with a message', () async {
    repo.createUsernameRowError = Exception('boom');
    final result = await save();
    expect(result.status, OnboardingStatus.error);
    expect(result.message, contains('boom'));
    expect(container.read(onboardingProvider).isLoading, false);
  });
}
