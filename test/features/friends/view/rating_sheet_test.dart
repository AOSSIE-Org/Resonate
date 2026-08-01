import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/model/pair_chat_state.dart';
import 'package:resonate/features/friends/view/widgets/rating_sheet.dart';
import 'package:resonate/features/friends/data/services/pair_chat_session.dart';

import '../friends_test_helpers.dart';

// Builds the current-user + fake pair-chat notifier overrides.
List<Override> buildOverrides(FakePairChat fake) {
  return [
    requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
    currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
    pairChatProvider.overrideWith(() => fake),
  ];
}

// Pushes RatingSheet as a route so Navigator.pop() has a route to remove.
Future<void> pumpSheet(WidgetTester tester, List<Override> overrides) async {
  await pumpFriendsPage(
    tester,
    Builder(
      builder: (context) => ElevatedButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const RatingSheet())),
        child: const Text('open'),
      ),
    ),
    overrides: overrides,
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('displays the rating text from pairChatProvider.pairRating', (
    tester,
  ) async {
    final fake = FakePairChat(const PairChatState(pairRating: 3.0));
    await pumpSheet(tester, buildOverrides(fake));

    expect(find.text('Rating: 3.0/5.0'), findsOneWidget);
    expect(find.text('Rate your experience'), findsOneWidget);
  });

  testWidgets('tapping a star calls setPairRating with the new rating', (
    tester,
  ) async {
    final fake = FakePairChat(const PairChatState(pairRating: 2.5));
    await pumpSheet(tester, buildOverrides(fake));

    // Each star is a GestureDetector; tapping the first fires onChanged(1.0).
    final firstStar = find.byType(GestureDetector).first;
    await tester.tap(firstStar);
    await tester.pumpAndSettle();

    expect(fake.setRatingCalls, contains(1.0));
    expect(find.text('Rating: 1.0/5.0'), findsOneWidget);
  });

  testWidgets('submit calls submitRating and pops the sheet', (tester) async {
    final fake = FakePairChat(const PairChatState(pairRating: 2.5));
    await pumpSheet(tester, buildOverrides(fake));

    expect(find.byType(RatingSheet), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pumpAndSettle();

    expect(fake.submitCount, 1);
    // Sheet popped, back to the launcher button.
    expect(find.byType(RatingSheet), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets(
    'submit still pops and reports an error when submitRating throws',
    (tester) async {
      final fake = FakePairChat(
        const PairChatState(pairRating: 2.5),
        throwOnSubmit: true,
      );
      await pumpSheet(tester, buildOverrides(fake));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
      await tester.pumpAndSettle();

      expect(fake.submitCount, 1);
      // finally block still pops the sheet even after the error.
      expect(find.byType(RatingSheet), findsNothing);
      expect(find.text('open'), findsOneWidget);
    },
  );
}
