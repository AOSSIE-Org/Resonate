import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/achievements/model/achievement_badge.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';

class FakeAchievementsRepository implements AchievementsRepository {
  // Configurable returns.
  UserStats stats = UserStats.empty;
  Map<String, UserStats> statsByUid = const {};
  List<AchievementBadge> catalogue = kDefaultBadges;
  List<String> nextNewBadges = const [];
  Object? recordError;

  // Recorded calls.
  final List<String> loadedUids = [];
  int loadCatalogueCount = 0;
  final List<int> activityCalls = [];
  final List<String> roomCredits = [];
  final List<({List<String> displayedBadges, String? avatarBadge})>
  showcaseCalls = [];

  @override
  Future<UserStats> loadStats(String uid) async {
    loadedUids.add(uid);
    return statsByUid[uid] ?? stats;
  }

  @override
  Future<List<AchievementBadge>> loadCatalogue() async {
    loadCatalogueCount++;
    return catalogue;
  }

  @override
  Future<ActivityResult> recordActivity({int interactions = 0}) async {
    activityCalls.add(interactions);
    return _result();
  }

  @override
  Future<ActivityResult> recordRoomCredit(String roomId) async {
    roomCredits.add(roomId);
    return _result();
  }

  @override
  Future<ActivityResult> setShowcase({
    required List<String> displayedBadges,
    required String? avatarBadge,
  }) async {
    showcaseCalls.add((
      displayedBadges: displayedBadges,
      avatarBadge: avatarBadge,
    ));
    stats = stats.copyWith(
      displayedBadges: displayedBadges,
      avatarBadge: avatarBadge,
    );
    return _result();
  }

  ActivityResult _result() {
    final error = recordError;
    if (error != null) throw error;
    final earned = nextNewBadges;
    nextNewBadges = const [];
    return (stats: stats, newBadges: earned);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} not stubbed in FakeAchievementsRepository',
  );
}
