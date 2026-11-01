import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/rooms/view/widgets/search_rooms.dart';

import '../rooms_test_helpers.dart';

void main() {
  group('SearchOverlay', () {
    testRoomsWidget('renders SizedBox.shrink and nothing when not visible', (
      tester,
    ) async {
      await pumpRoomsPage(
        tester,
        Stack(
          children: [
            SearchOverlay(
              onSearchChanged: (_) {},
              onClose: () {},
              isVisible: false,
            ),
          ],
        ),
      );
      await tester.pump();

      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(TextField), findsNothing);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
      expect(find.byType(Positioned), findsNothing);
    });

    testRoomsWidget('renders the text field and back button when visible', (
      tester,
    ) async {
      await pumpRoomsPage(
        tester,
        Stack(
          children: [
            SearchOverlay(
              onSearchChanged: (_) {},
              onClose: () {},
              isVisible: true,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testRoomsWidget('typing fires onSearchChanged with the entered text', (
      tester,
    ) async {
      String? received;
      await pumpRoomsPage(
        tester,
        Stack(
          children: [
            SearchOverlay(
              onSearchChanged: (text) => received = text,
              onClose: () {},
              isVisible: true,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'jazz');
      await tester.pump();

      expect(received, 'jazz');
    });

    testRoomsWidget('clear button is hidden until text is entered', (
      tester,
    ) async {
      await pumpRoomsPage(
        tester,
        Stack(
          children: [
            SearchOverlay(
              onSearchChanged: (_) {},
              onClose: () {},
              isVisible: true,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // No text yet -> no clear icon.
      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(find.byType(TextField), 'jazz');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testRoomsWidget('tapping clear empties the field and reports empty text', (
      tester,
    ) async {
      String? received;
      await pumpRoomsPage(
        tester,
        Stack(
          children: [
            SearchOverlay(
              onSearchChanged: (text) => received = text,
              onClose: () {},
              isVisible: true,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'jazz');
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Cleared: controller listener reports empty and icon disappears.
      expect(received, '');
      expect(find.byIcon(Icons.clear), findsNothing);
      expect(find.text('jazz'), findsNothing);
    });

    testRoomsWidget('isSearching shows a spinner instead of the clear button', (
      tester,
    ) async {
      await pumpRoomsPage(
        tester,
        Stack(
          children: [
            SearchOverlay(
              onSearchChanged: (_) {},
              onClose: () {},
              isVisible: true,
              isSearching: true,
            ),
          ],
        ),
      );
      // Spinner animates forever, so settle the slide-in with a fixed pump.
      await tester.pump(const Duration(milliseconds: 400));

      await tester.enterText(find.byType(TextField), 'jazz');
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testRoomsWidget('tapping back fires onClose after the reverse animation', (
      tester,
    ) async {
      var closed = false;
      await pumpRoomsPage(
        tester,
        Stack(
          children: [
            SearchOverlay(
              onSearchChanged: (_) {},
              onClose: () => closed = true,
              isVisible: true,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      // onClose only fires once the ~300ms reverse animation completes.
      await tester.pumpAndSettle();

      expect(closed, isTrue);
    });
  });
}
