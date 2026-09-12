import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/activity_status.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../helpers/test_root_container.dart';
import '../stories/fake_stories_repository.dart';
import 'fake_profile_repository.dart';

export '../../helpers/test_root_container.dart' show fakeAuthUser;
export '../stories/fake_stories_repository.dart';
export 'fake_profile_repository.dart';

Widget profileTestApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],

    home: Builder(
      builder: (context) {
        UiSizes.init(context);
        return child;
      },
    ),
  );
}

Future<void> pumpProfilePage(
  WidgetTester tester,
  Widget child, {
  required AuthState authState,
  FakeProfileRepository? profileRepo,
  FakeStoriesRepository? storiesRepo,
  ActivityStatus myStatus = ActivityStatus.online,
  Map<String, ActivityStatus> activityStatuses = const {},
  UserStats myStats = UserStats.empty,
  Map<String, UserStats> otherStats = const {},
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...overrides,
        authRepositoryProvider.overrideWithValue(FakeAuthRepository(authState)),
        profileRepositoryProvider.overrideWithValue(
          profileRepo ?? FakeProfileRepository(),
        ),
        // The profile view reads its stories from the stories feature now.
        storiesRepositoryProvider.overrideWithValue(
          storiesRepo ?? FakeStoriesRepository(),
        ),
        ...activityStatusOverrides(
          myStatus: myStatus,
          others: activityStatuses,
        ),
        ...achievementOverrides(myStats: myStats, otherStats: otherStats),
      ],
      child: profileTestApp(child),
    ),
  );
  final container = ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp)),
  );
  await container.read(authSessionProvider.future);
  await tester.pumpAndSettle();
}
