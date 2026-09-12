const int kMaxStoryTags = 5;

// The stored column is 40 characters wide.
const int kMaxStoryTagLength = 40;

String normalizeStoryTag(String tag) {
  final value = tag.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  return value.length <= kMaxStoryTagLength
      ? value
      : value.substring(0, kMaxStoryTagLength).trim();
}

// Normalises, drops blanks and duplicates, and stops at the tag limit.
List<String> normalizeStoryTags(Iterable<String> tags) {
  final normalized = <String>[];
  for (final tag in tags) {
    final value = normalizeStoryTag(tag);
    if (value.isEmpty || normalized.contains(value)) continue;
    normalized.add(value);
    if (normalized.length == kMaxStoryTags) break;
  }
  return normalized;
}
