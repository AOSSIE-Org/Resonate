import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/shared/widgets/session_control_bar.dart';
import 'package:resonate/utils/ui_sizes.dart';

void main() {
  Finder control(SessionControlKind kind) =>
      find.byKey(ValueKey('session-control-${kind.name}'));

  Color? discColor(WidgetTester tester, SessionControlKind kind) =>
      tester.widget<Material>(control(kind)).color;

  ColorScheme scheme(WidgetTester tester) =>
      Theme.of(tester.element(find.byType(SessionControlBar))).colorScheme;

  Future<void> pumpBar(
    WidgetTester tester,
    List<SessionControl> controls,
  ) async {
    tester.view.physicalSize = const Size(2400, 1200);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            UiSizes.init(context);
            return Scaffold(
              body: Center(child: SessionControlBar(controls: controls)),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders only the controls it was asked for', (tester) async {
    await pumpBar(tester, const [
      SessionControl(SessionControlKind.leave),
      SessionControl(SessionControlKind.mic),
    ]);

    expect(control(SessionControlKind.leave), findsOneWidget);
    expect(control(SessionControlKind.mic), findsOneWidget);
    expect(control(SessionControlKind.chat), findsNothing);
    expect(control(SessionControlKind.record), findsNothing);
  });

  testWidgets('the mic icon follows its active state', (tester) async {
    await pumpBar(tester, const [
      SessionControl(SessionControlKind.mic, active: true),
    ]);
    expect(find.byIcon(Icons.mic), findsOneWidget);
    expect(find.byIcon(Icons.mic_off), findsNothing);

    await pumpBar(tester, const [SessionControl(SessionControlKind.mic)]);
    expect(find.byIcon(Icons.mic_off), findsOneWidget);
    expect(find.byIcon(Icons.mic), findsNothing);
  });

  testWidgets('an active control takes the primary colour', (tester) async {
    await pumpBar(tester, const [
      SessionControl(SessionControlKind.raiseHand, active: true),
    ]);
    expect(
      discColor(tester, SessionControlKind.raiseHand),
      scheme(tester).primary,
    );
  });

  testWidgets('an inactive control does not', (tester) async {
    await pumpBar(tester, const [SessionControl(SessionControlKind.raiseHand)]);
    expect(
      discColor(tester, SessionControlKind.raiseHand),
      isNot(scheme(tester).primary),
    );
  });

  testWidgets('leaving is always the error colour', (tester) async {
    await pumpBar(tester, const [SessionControl(SessionControlKind.leave)]);
    expect(discColor(tester, SessionControlKind.leave), scheme(tester).error);
  });

  testWidgets('a running recording reads as error, not as selected', (
    tester,
  ) async {
    await pumpBar(tester, const [
      SessionControl(SessionControlKind.record, active: true),
    ]);
    expect(discColor(tester, SessionControlKind.record), scheme(tester).error);
    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);

    await pumpBar(tester, const [SessionControl(SessionControlKind.record)]);
    expect(
      discColor(tester, SessionControlKind.record),
      isNot(scheme(tester).error),
    );
    expect(find.byIcon(Icons.fiber_manual_record), findsOneWidget);
  });

  // There is no separate speakerphone toggle any more: the picker owns the
  // speaker icon, and routing to the loudspeaker is a device choice inside it.
  testWidgets('the device picker carries the speaker icon', (tester) async {
    await pumpBar(tester, const [
      SessionControl(SessionControlKind.audioDevice),
    ]);

    expect(find.byIcon(Icons.volume_up), findsOneWidget);
    expect(find.byIcon(Icons.settings_voice), findsNothing);
  });

  testWidgets('controls are laid out in the order they were given', (
    tester,
  ) async {
    await pumpBar(tester, const [
      SessionControl(SessionControlKind.leave),
      SessionControl(SessionControlKind.mic),
      SessionControl(SessionControlKind.chat),
    ]);

    final xs = [
      SessionControlKind.leave,
      SessionControlKind.mic,
      SessionControlKind.chat,
    ].map((kind) => tester.getCenter(control(kind)).dx).toList();

    expect(xs, orderedEquals([...xs]..sort()));
  });

  testWidgets('leaving is drawn larger than the rest', (tester) async {
    await pumpBar(tester, const [
      SessionControl(SessionControlKind.leave),
      SessionControl(SessionControlKind.mic),
    ]);

    final leave = tester.getSize(control(SessionControlKind.leave));
    final mic = tester.getSize(control(SessionControlKind.mic));
    expect(leave.width, greaterThan(mic.width));
  });

  testWidgets('a control with no handler is dimmed and inert', (tester) async {
    var taps = 0;
    await pumpBar(tester, [
      const SessionControl(SessionControlKind.mic),
      SessionControl(SessionControlKind.chat, onTap: () => taps++),
    ]);

    final dimmed = tester.widget<Icon>(
      find.descendant(
        of: control(SessionControlKind.mic),
        matching: find.byType(Icon),
      ),
    );
    final live = tester.widget<Icon>(
      find.descendant(
        of: control(SessionControlKind.chat),
        matching: find.byType(Icon),
      ),
    );
    expect(dimmed.color!.a, lessThan(live.color!.a));

    await tester.tap(control(SessionControlKind.mic));
    await tester.pump();
    expect(taps, 0);
  });

  testWidgets('each control invokes its own handler', (tester) async {
    var mic = 0, hand = 0, device = 0, leave = 0;
    await pumpBar(tester, [
      SessionControl(SessionControlKind.mic, onTap: () => mic++),
      SessionControl(SessionControlKind.raiseHand, onTap: () => hand++),
      SessionControl(SessionControlKind.audioDevice, onTap: () => device++),
      SessionControl(SessionControlKind.leave, onTap: () => leave++),
    ]);

    await tester.tap(control(SessionControlKind.mic));
    await tester.tap(control(SessionControlKind.raiseHand));
    await tester.tap(control(SessionControlKind.audioDevice));
    await tester.tap(control(SessionControlKind.leave));
    await tester.pumpAndSettle();

    expect([mic, hand, device, leave], [1, 1, 1, 1]);
  });
}
