import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/rooms/model/user_report_model.dart';
import 'package:resonate/features/rooms/view/widgets/report_widget.dart';
import 'package:resonate/utils/enums/report_type_enum.dart';

import '../../../helpers/pump_widget.dart';

void main() {
  late ReportDraft? popped;
  late bool didPop;

  setUp(() {
    popped = null;
    didPop = false;
  });

  Future<void> openReport(WidgetTester tester) async {
    await pumpTestApp(
      tester,
      Builder(
        builder: (context) => ElevatedButton(
          onPressed: () async {
            popped = await showDialog<ReportDraft>(
              context: context,
              builder: (_) => const ReportWidget(
                participantName: 'Bob',
                participantId: 'bob-1',
              ),
            );
            didPop = true;
          },
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.ensureVisible(
      find.widgetWithText(ElevatedButton, 'Submit Report'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Report'));
    await tester.pumpAndSettle();
  }

  Future<void> choose(WidgetTester tester, String label) async {
    final tile = find.widgetWithText(RadioListTile<ReportTypeEnum>, label);
    await tester.ensureVisible(tile);
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pumpAndSettle();
  }

  testAppWidget('names the participant being reported', (tester) async {
    await openReport(tester);

    expect(find.text('Report Participant Bob'), findsOneWidget);
  });

  testAppWidget('offers every report type', (tester) async {
    await openReport(tester);

    expect(
      find.byType(RadioListTile<ReportTypeEnum>),
      findsNWidgets(ReportTypeEnum.values.length),
    );
    expect(find.text('Harassment / Hate Speech'), findsOneWidget);
    expect(find.text('Spam / Scams / Fraud'), findsOneWidget);
  });

  testAppWidget('starts with nothing selected', (tester) async {
    await openReport(tester);

    final group = tester.widget<RadioGroup<ReportTypeEnum>>(
      find.byType(RadioGroup<ReportTypeEnum>),
    );
    expect(group.groupValue, isNull);
  });

  // A report with no category is not actionable, so the sheet stays open.
  testAppWidget('submitting without a type keeps the sheet open', (
    tester,
  ) async {
    await openReport(tester);

    await submit(tester);

    expect(didPop, isFalse);
    expect(find.byType(ReportWidget), findsOneWidget);
  });

  testAppWidget('returns the chosen type', (tester) async {
    await openReport(tester);

    await choose(tester, 'Spam / Scams / Fraud');
    await submit(tester);

    expect(popped?.type, ReportTypeEnum.spam);
  });

  // The details box is optional; an empty one must come back as null rather
  // than an empty string, which would be stored as a blank report body.
  testAppWidget('returns null details when the box is empty', (tester) async {
    await openReport(tester);

    await choose(tester, 'Illegal Activities');
    await submit(tester);

    expect(popped?.type, ReportTypeEnum.illegal);
    expect(popped?.details, isNull);
  });

  testAppWidget('returns the details that were typed', (tester) async {
    await openReport(tester);

    await choose(tester, 'Harassment / Hate Speech');
    await tester.enterText(find.byType(TextField), 'they kept shouting');
    await submit(tester);

    expect(popped?.type, ReportTypeEnum.harassment);
    expect(popped?.details, 'they kept shouting');
  });

  testAppWidget('a changed mind reports the last choice', (tester) async {
    await openReport(tester);

    await choose(tester, 'Spam / Scams / Fraud');
    await choose(tester, 'Impersonation / Fake Accounts');
    await submit(tester);

    expect(popped?.type, ReportTypeEnum.impersonation);
  });
}
