import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/interests/model/interest.dart';

void main() {
  test('every wire value is unique and non-empty', () {
    final wires = Interest.values.map((i) => i.wire).toList();
    expect(wires.toSet(), hasLength(Interest.values.length));
    expect(wires.every((w) => w.isNotEmpty), isTrue);
  });

  test('wire values round-trip through fromWire', () {
    for (final interest in Interest.values) {
      expect(Interest.fromWire(interest.wire), interest);
    }
  });

  test('fromWire is null for unknown and missing values', () {
    expect(Interest.fromWire('quidditch'), isNull);
    expect(Interest.fromWire(null), isNull);
    expect(Interest.fromWire(''), isNull);
  });

  group('fromWireList', () {
    test('maps a stored list in order', () {
      expect(Interest.fromWireList(['music', 'ai']), [
        Interest.music,
        Interest.ai,
      ]);
    });

    test('drops values this build does not know about', () {
      expect(Interest.fromWireList(['music', 'quidditch', 'ai']), [
        Interest.music,
        Interest.ai,
      ]);
    });

    test('drops duplicates and non-string entries', () {
      expect(Interest.fromWireList(['music', 'music', 7, null]), [
        Interest.music,
      ]);
    });

    test('is empty for anything that is not a list', () {
      expect(Interest.fromWireList(null), isEmpty);
      expect(Interest.fromWireList('music'), isEmpty);
    });
  });

  test('toWireList maps back to the stored strings', () {
    expect(Interest.toWireList([Interest.ai, Interest.fitness]), [
      'ai',
      'fitness',
    ]);
    expect(Interest.toWireList(const []), isEmpty);
  });

  test('the selection cap is the five the spec allows', () {
    expect(Interest.maxSelectable, 5);
  });
}
