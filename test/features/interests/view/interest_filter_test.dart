import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/interests/data/repositories/interests_repository.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/interests/view/widgets/interest_filter_button.dart';
import 'package:resonate/features/interests/view/widgets/interest_filter_panel.dart';
import 'package:resonate/features/interests/view/widgets/interest_profile_tile.dart';

import '../../../helpers/pump_widget.dart';
import '../../../helpers/test_root_container.dart';
import '../interests_test_helpers.dart';

void main() {
  late FakeInterestsRepository repo;

  // Mirrors how the explore page composes them: the button lives in the search
  // field and toggles whether the picker or the results fill the screen.
  Future<void> pumpFilter(WidgetTester tester) async {
    await pumpTestApp(
      tester,
      const _FilterHarness(),
      overrides: [
        interestsRepositoryProvider.overrideWithValue(repo),
        currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
      ],
    );
    await tester.pumpAndSettle();
  }

  Future<void> openPicker(WidgetTester tester) async {
    await tester.tap(find.byType(InterestFilterButton));
    await tester.pumpAndSettle();
  }

  setUp(() {
    repo = FakeInterestsRepository();
    repo.matches = (interests) => [
      fakeResonateUser(
        uid: 'u1',
        userName: 'match_one',
        name: 'Match One',
      ).copyWith(interests: Interest.toWireList(interests)),
    ];
  });

  testAppWidget('the search field carries the filter button, picker closed', (
    tester,
  ) async {
    await pumpFilter(tester);

    expect(find.byType(InterestFilterButton), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    expect(find.byType(InterestFilterPanel), findsNothing);
    expect(find.byType(FilterChip), findsNothing);
  });

  testAppWidget('pressing it opens the picker in the screen', (tester) async {
    await pumpFilter(tester);

    await openPicker(tester);

    expect(find.byType(InterestFilterPanel), findsOneWidget);
    expect(find.byType(FilterChip), findsNWidgets(Interest.values.length));
    // the picker replaces the screen's content rather than expanding under it
    expect(find.text('search results'), findsNothing);
  });

  testAppWidget('pressing it again closes the picker', (tester) async {
    await pumpFilter(tester);
    await openPicker(tester);

    await openPicker(tester);

    expect(find.byType(InterestFilterPanel), findsNothing);
  });

  testAppWidget('picking a tag lists the matching profiles once done', (
    tester,
  ) async {
    await pumpFilter(tester);
    await openPicker(tester);

    await tester.tap(find.text(interestLabelInEnglish(Interest.music)));
    await tester.pumpAndSettle();
    expect(repo.calls.single.interests, {Interest.music});

    await tester.ensureVisible(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.byType(InterestFilterPanel), findsNothing);
    expect(find.byType(InterestProfileTile), findsOneWidget);
    expect(find.text('match_one'), findsOneWidget);
    // the tile names the interest that matched
    expect(find.text('Music'), findsWidgets);
  });

  testAppWidget('the button shows how many tags are selected', (tester) async {
    await pumpFilter(tester);
    await openPicker(tester);

    await tester.tap(find.text(interestLabelInEnglish(Interest.music)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(interestLabelInEnglish(Interest.ai)));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(InterestFilterButton),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );
  });

  testAppWidget('says so when nothing matches', (tester) async {
    repo.matches = (_) => const [];
    await pumpFilter(tester);
    await openPicker(tester);

    await tester.tap(find.text(interestLabelInEnglish(Interest.music)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('No profiles match those interests yet.'), findsOneWidget);
    expect(find.byType(InterestProfileTile), findsNothing);
  });

  testAppWidget('reports a failed lookup', (tester) async {
    repo.error = Exception('offline');
    await pumpFilter(tester);
    await openPicker(tester);

    await tester.tap(find.text(interestLabelInEnglish(Interest.music)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('Could not load matching profiles.'), findsOneWidget);
  });

  testAppWidget('clear drops the filter and its results', (tester) async {
    await pumpFilter(tester);
    await openPicker(tester);
    await tester.tap(find.text(interestLabelInEnglish(Interest.music)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.byType(InterestProfileTile), findsNothing);
    expect(find.text('search results'), findsOneWidget);
  });
}

class _FilterHarness extends StatefulWidget {
  const _FilterHarness();

  @override
  State<_FilterHarness> createState() => _FilterHarnessState();
}

class _FilterHarnessState extends State<_FilterHarness> {
  bool _isPicking = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              suffixIcon: InterestFilterButton(
                isOpen: _isPicking,
                onPressed: () => setState(() => _isPicking = !_isPicking),
              ),
            ),
          ),
          if (_isPicking)
            InterestFilterPanel(
              onDone: () => setState(() => _isPicking = false),
            )
          else ...[
            const InterestFilterResults(),
            const Text('search results'),
          ],
        ],
      ),
    );
  }
}
