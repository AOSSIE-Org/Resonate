import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/friends/model/friend_call_state.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/features/friends/model/pair_chat_state.dart';
import 'package:resonate/features/friends/data/services/friend_call_coordinator.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/friends/viewmodel/pair_chat_notifier.dart';
import 'package:resonate/features/activity_status/model/call_blocked_by_activity_status.dart';
import 'package:resonate/features/shell/viewmodel/tabview_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/resonate_user.dart';
import 'package:resonate/utils/enums/activity_status.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../helpers/test_root_container.dart';

export '../../helpers/test_root_container.dart';

export 'package:flutter_riverpod/misc.dart' show Override;

export 'package:resonate/utils/enums/activity_status.dart';

Widget friendsTestApp(Widget child) {
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
        return Scaffold(body: child);
      },
    ),
  );
}

Future<void> pumpFriendsPage(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
  ActivityStatus myStatus = ActivityStatus.online,
  Map<String, ActivityStatus> activityStatuses = const {},
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...activityStatusOverrides(myStatus: myStatus, others: activityStatuses),
        ...overrides,
      ],
      child: friendsTestApp(child),
    ),
  );
}

// Wraps the body in mockNetworkImagesFor so avatar NetworkImages don't fetch.
void testFriendsWidget(
  String description,
  Future<void> Function(WidgetTester tester) body,
) {
  testWidgets(
    description,
    (tester) => mockNetworkImagesFor(() => body(tester)),
  );
}

// Records setIndex calls and skips the real app-links init in build().
class FakeTabView extends TabView {
  final List<int> setIndexCalls = [];

  @override
  int build() => 0;

  @override
  void setIndex(int index) {
    setIndexCalls.add(index);
    state = index;
  }
}

class FakeFriendsNotifier extends FriendsNotifier {
  FakeFriendsNotifier({
    this.buildState = const FriendsState(),
    this.buildFuture,
    this.throwOnBuild = false,
    this.acceptFuture,
    this.declineFuture,
  });

  final FriendsState buildState;
  final Future<void>? buildFuture;
  final bool throwOnBuild;
  final Future<void> Function()? acceptFuture;
  final Future<void> Function()? declineFuture;

  final List<FriendsModel> accepted = [];
  final List<FriendsModel> declined = [];
  final List<FriendsModel> removed = [];
  int sendCount = 0;

  @override
  Future<FriendsState> build() async {
    if (throwOnBuild) throw StateError('boom');
    if (buildFuture != null) await buildFuture!;
    return buildState;
  }

  @override
  Future<void> acceptFriendRequest(FriendsModel friendModel) async {
    accepted.add(friendModel);
    if (acceptFuture != null) await acceptFuture!();
  }

  @override
  Future<void> declineFriendRequest(FriendsModel friendModel) async {
    declined.add(friendModel);
    if (declineFuture != null) await declineFuture!();
  }

  @override
  Future<void> removeFriend(FriendsModel friendModel) async {
    removed.add(friendModel);
  }

  @override
  Future<void> sendFriendRequest({
    required String recieverId,
    required String recieverProfileImageUrl,
    required String recieverUsername,
    required String recieverName,
    required double recieverRating,
  }) async {
    sendCount++;
  }
}

// Records call control invocations; optionally throws or stays pending on start.
class FakeFriendCallCoordinator extends FriendCallCoordinator {
  FakeFriendCallCoordinator({
    this.initial = const FriendCallState(),
    this.startFuture,
    this.throwError = false,
    this.blockedBy,
  });

  final FriendCallState initial;
  final Future<void> Function()? startFuture;
  final bool throwError;

  final ActivityStatus? blockedBy;

  final List<FriendsModel> started = [];
  int startCallCount = 0;
  int endCallCount = 0;
  int toggleMicCount = 0;
  int toggleLoudSpeakerCount = 0;

  @override
  FriendCallState build() => initial;

  @override
  Future<void> startCall(FriendsModel friend) async {
    startCallCount++;
    started.add(friend);
    if (startFuture != null) await startFuture!();
    if (blockedBy != null) throw CallBlockedByActivityStatus(blockedBy!);
    if (throwError) throw Exception('call failed');
  }

  @override
  Future<void> endCall() async => endCallCount++;

  @override
  Future<void> toggleMic() async => toggleMicCount++;

  @override
  Future<void> toggleLoudSpeaker() async => toggleLoudSpeakerCount++;
}

class FakePairChatNotifier extends PairChatNotifier {
  FakePairChatNotifier(this.initial, {this.throwOnSubmit = false});

  final PairChatState initial;
  final bool throwOnSubmit;

  int setAnonymousCount = 0;
  bool? lastAnonymous;
  int setLanguageCount = 0;
  String? lastLanguage;
  int quickMatchCount = 0;
  int choosePartnerCount = 0;
  int loadUsersCount = 0;
  int cancelRequestCount = 0;
  int convertToRandomCount = 0;
  final List<ResonateUser> pairedWith = [];
  final List<double> setRatingCalls = [];
  int submitCount = 0;
  int endChatCount = 0;
  int toggleMicCount = 0;
  int toggleLoudSpeakerCount = 0;

  @override
  PairChatState build() => initial;

  @override
  void setAnonymous(bool isAnonymous) {
    setAnonymousCount++;
    lastAnonymous = isAnonymous;
  }

  @override
  void setLanguage(String languageIso) {
    setLanguageCount++;
    lastLanguage = languageIso;
  }

  @override
  void setPairRating(double rating) {
    setRatingCalls.add(rating);
    state = state.copyWith(pairRating: rating);
  }

  @override
  Future<void> quickMatch() async => quickMatchCount++;

  @override
  Future<void> choosePartner() async => choosePartnerCount++;

  @override
  Future<void> loadUsers() async => loadUsersCount++;

  @override
  Future<void> cancelRequest() async => cancelRequestCount++;

  @override
  Future<void> convertToRandom() async => convertToRandomCount++;

  @override
  Future<void> pairWithSelectedUser(ResonateUser user) async {
    pairedWith.add(user);
  }

  @override
  Future<void> submitRating() async {
    submitCount++;
    if (throwOnSubmit) throw Exception('submit boom');
  }

  @override
  Future<void> endChat() async => endChatCount++;

  @override
  Future<void> toggleMic() async => toggleMicCount++;

  @override
  Future<void> toggleLoudSpeaker() async => toggleLoudSpeakerCount++;
}
