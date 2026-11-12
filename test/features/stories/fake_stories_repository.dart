import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/story.dart';

// Canned story lists and records the viewer it was asked about
class FakeStoriesRepository implements StoriesRepository {
  FakeStoriesRepository({
    this.createdStories = const [],
    this.likedStories = const [],
  });

  List<Story> createdStories;
  List<Story> likedStories;

  String? lastCreatedViewerUid;
  String? lastLikedViewerUid;

  @override
  Future<List<Story>> fetchCreatedStories(
    String creatorId, {
    String? viewerUid,
  }) async {
    lastCreatedViewerUid = viewerUid;
    return createdStories;
  }

  @override
  Future<List<Story>> fetchLikedStories(String uid, {String? viewerUid}) async {
    lastLikedViewerUid = viewerUid;
    return likedStories;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} not stubbed in FakeStoriesRepository',
  );
}
