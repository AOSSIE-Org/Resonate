enum Interest {
  ai('ai'),
  music('music'),
  fitness('fitness'),
  anime('anime'),
  gaming('gaming'),
  technology('technology'),
  movies('movies'),
  books('books'),
  art('art'),
  travel('travel'),
  food('food'),
  sports('sports'),
  business('business'),
  science('science'),
  comedy('comedy'),
  wellness('wellness');

  const Interest(this.wire);

  final String wire;
  static const int maxSelectable = 5;

  static Interest? fromWire(String? wire) {
    if (wire == null) return null;
    for (final interest in Interest.values) {
      if (interest.wire == wire) return interest;
    }
    return null;
  }

  static List<Interest> fromWireList(Object? stored) {
    if (stored is! List) return const [];
    final interests = <Interest>[];
    for (final value in stored) {
      final interest = fromWire(value is String ? value : null);
      if (interest != null && !interests.contains(interest)) {
        interests.add(interest);
      }
    }
    return interests;
  }

  static List<String> toWireList(Iterable<Interest> interests) =>
      interests.map((interest) => interest.wire).toList();
}
