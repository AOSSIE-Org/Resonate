import 'package:meilisearch/meilisearch.dart';

class FakeMeiliIndex implements MeiliSearchIndex {
  FakeMeiliIndex(this.uid);

  @override
  final String uid;

  final List<SearchQuery?> queries = [];
  List<Object?> errors = const [];
  List<Map<String, dynamic>> hits = const [];

  int _calls = 0;

  @override
  Future<Searcheable<Map<String, dynamic>>> search(
    String? text, [
    SearchQuery? q,
  ]) async {
    queries.add(q);
    final call = _calls++;
    final error = call < errors.length ? errors[call] : null;
    if (error != null) throw error;

    return SearchResult.fromMap({
      'hits': hits,
      'query': text,
      'processingTimeMs': 1,
      'estimatedTotalHits': hits.length,
    }, indexUid: uid);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} not stubbed in FakeMeiliIndex',
  );
}

class FakeMeiliClient implements MeiliSearchClient {
  final Map<String, FakeMeiliIndex> indexes = {};

  FakeMeiliIndex indexNamed(String uid) =>
      indexes.putIfAbsent(uid, () => FakeMeiliIndex(uid));

  @override
  MeiliSearchIndex index(String uid) => indexNamed(uid);

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} not stubbed in FakeMeiliClient',
  );
}

Map<String, dynamic> meiliStoryHit({
  String id = 'story-1',
  String title = 'A Story',
  List<String> tags = const [],
}) => {
  r'$id': id,
  r'$createdAt': DateTime(2024).toIso8601String(),
  'title': title,
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
