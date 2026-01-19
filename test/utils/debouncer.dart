import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('executes action after debounce duration', () async {
      bool called = false;
      final debouncer = Debouncer(milliseconds: 100);

      debouncer.run(() {
        called = true;
      });

      await Future.delayed(const Duration(milliseconds: 200));

      expect(called, true);
    });

    test('cancels previous action when run is called again', () async {
      int count = 0;
      final debouncer = Debouncer(milliseconds: 100);

      debouncer.run(() {
        count++;
      });

      debouncer.run(() {
        count++;
      });

      await Future.delayed(const Duration(milliseconds: 200));

      expect(count, 1);
    });

    test('dispose cancels pending action', () async {
      bool called = false;
      final debouncer = Debouncer(milliseconds: 100);

      debouncer.run(() {
        called = true;
      });

      debouncer.dispose();

      await Future.delayed(const Duration(milliseconds: 200));

      expect(called, false);
    });
  });
}
