import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_tags.dart';

void main() {
  group('normalizeStoryTag', () {
    test('lowercases and trims', () {
      expect(normalizeStoryTag('  Tech Talks '), 'tech talks');
    });

    test('collapses runs of whitespace', () {
      expect(normalizeStoryTag('fitness\t  motivation'), 'fitness motivation');
    });

    test('truncates to the width of the stored column', () {
      final tag = normalizeStoryTag('a' * 60);

      expect(tag, hasLength(kMaxStoryTagLength));
    });

    test('is empty for blank input', () {
      expect(normalizeStoryTag('   '), isEmpty);
      expect(normalizeStoryTag(''), isEmpty);
    });
  });

  group('normalizeStoryTags', () {
    test('normalises every tag', () {
      expect(normalizeStoryTags([' AI ', 'Tech  Talks']), [
        'ai',
        'tech talks',
      ]);
    });

    test('drops blanks and duplicates that differ only in case', () {
      expect(normalizeStoryTags(['ai', '  ', 'AI', 'ai ']), ['ai']);
    });

    test('stops at the tag limit', () {
      final tags = normalizeStoryTags([
        for (var i = 0; i < kMaxStoryTags + 4; i++) 'tag$i',
      ]);

      expect(tags, hasLength(kMaxStoryTags));
      expect(tags.last, 'tag${kMaxStoryTags - 1}');
    });
  });

  group('Story.fromMap tags', () {
    Map<String, dynamic> data(Object? tags) => {
      'title': 'A Story',
      'description': 'desc',
      'category': 'drama',
      'coverImgUrl': 'https://example.com/c.jpg',
      'creatorId': 'creator-1',
      'creatorName': 'Creator',
      'creatorImgUrl': 'https://example.com/a.jpg',
      'likes': 0,
      'playDuration': 100,
      'tintColor': 'cbc6c6',
      'tags': tags,
    };

    Story parse(Object? tags) => Story.fromMap(
      data(tags),
      id: 's1',
      createdAt: DateTime(2024).toIso8601String(),
    );

    test('reads the stored list', () {
      expect(parse(['ai', 'tech talks']).tags, ['ai', 'tech talks']);
    });

    test('is empty for a story saved before the column existed', () {
      expect(parse(null).tags, isEmpty);
    });

    test('skips entries that are not strings', () {
      expect(parse(['ai', 7, null]).tags, ['ai']);
    });

    test('survives a non-list value', () {
      expect(parse('ai').tags, isEmpty);
    });
  });
}
