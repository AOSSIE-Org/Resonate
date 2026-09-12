import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/interests/data/my_interests.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/interests/view/pages/interests_screen.dart';

import '../../../helpers/pump_widget.dart';
import '../interests_test_helpers.dart';

void main() {
  late FakeMyInterests myInterests;

  Future<void> pumpScreen(
    WidgetTester tester, {
    List<Interest> stored = const [],
    Size size = const Size(1080, 2340),
  }) async {
    myInterests = FakeMyInterests(stored);
    tester.view.physicalSize = size;
    await pumpTestApp(
      tester,
      const InterestsScreen(),
      overrides: [myInterestsProvider.overrideWith(() => myInterests)],
    );
    await tester.pumpAndSettle();
  }

  // The save button sits below the fold once the chip grid is rendered.
  Future<void> tapSave(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Save changes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
  }

  bool isSelected(WidgetTester tester, Interest interest) {
    final label = interestLabelInEnglish(interest);
    final chip = tester.widget<FilterChip>(
      find.ancestor(
        of: find.text(label),
        matching: find.byType(FilterChip),
      ),
    );
    return chip.selected;
  }

  testAppWidget('offers every predefined interest', (tester) async {
    await pumpScreen(tester);

    expect(find.byType(FilterChip), findsNWidgets(Interest.values.length));
    expect(find.text('Interests'), findsWidgets);
  });

  testAppWidget('shows the stored interests as already picked', (tester) async {
    await pumpScreen(tester, stored: [Interest.music, Interest.ai]);

    expect(isSelected(tester, Interest.music), isTrue);
    expect(isSelected(tester, Interest.ai), isTrue);
    expect(isSelected(tester, Interest.fitness), isFalse);
  });

  testAppWidget('saves the edited selection', (tester) async {
    await pumpScreen(tester, stored: [Interest.music]);

    await tester.tap(find.text(interestLabelInEnglish(Interest.fitness)));
    await tester.pump();
    await tapSave(tester);

    expect(myInterests.saveCalls, hasLength(1));
    expect(myInterests.saveCalls.single, [Interest.music, Interest.fitness]);
  });

  testAppWidget('deselecting removes the interest from the save', (
    tester,
  ) async {
    await pumpScreen(tester, stored: [Interest.music, Interest.ai]);

    await tester.tap(find.text(interestLabelInEnglish(Interest.music)));
    await tester.pump();
    await tapSave(tester);

    expect(myInterests.saveCalls.single, [Interest.ai]);
  });

  testAppWidget('refuses a selection past the cap', (tester) async {
    await pumpScreen(
      tester,
      stored: Interest.values.take(Interest.maxSelectable).toList(),
    );

    final extra = Interest.values[Interest.maxSelectable];
    await tester.tap(find.text(interestLabelInEnglish(extra)));
    await tester.pump();

    expect(isSelected(tester, extra), isFalse);
    await tapSave(tester);
    expect(
      myInterests.saveCalls.single,
      hasLength(Interest.maxSelectable),
    );
  });

  testAppWidget('clear empties the selection without saving', (tester) async {
    await pumpScreen(tester, stored: [Interest.music]);

    await tester.tap(find.text('Clear'));
    await tester.pump();

    expect(isSelected(tester, Interest.music), isFalse);
    expect(myInterests.saveCalls, isEmpty);
  });

  // A 360dp-wide phone is the tightest layout the app ships to.
  testAppWidget('lays out on a narrow phone without overflowing', (
    tester,
  ) async {
    await pumpScreen(tester, size: const Size(1080, 1920));

    expect(tester.takeException(), isNull);
  });
}
