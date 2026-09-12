import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/services/execute_function.dart';
import 'package:resonate/features/achievements/model/achievement_badge.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/achievements_repository.g.dart';

typedef ActivityResult = ({UserStats stats, List<String> newBadges});

@Riverpod(keepAlive: true)
AchievementsRepository achievementsRepository(Ref ref) =>
    AchievementsRepository(
      tables: ref.watch(appwriteTablesProvider),
      functions: ref.watch(appwriteFunctionsProvider),
    );

class AchievementsRepository {
  AchievementsRepository({
    required TablesDB tables,
    required Functions functions,
  }) : _tables = tables,
       _functions = functions;

  final TablesDB _tables;
  final Functions _functions;

  static const _pageSize = 100;

  Future<UserStats> loadStats(String uid) async {
    try {
      final row = await _tables.getRow(
        databaseId: userDatabaseID,
        tableId: userStatsTableID,
        rowId: uid,
      );
      return UserStats.fromMap(row.data);
    } catch (e) {
      log('AchievementsRepository: could not load stats for $uid: $e');
      return UserStats.empty;
    }
  }

  Future<List<AchievementBadge>> loadCatalogue() async {
    try {
      final result = await _tables.listRows(
        databaseId: userDatabaseID,
        tableId: achievementThresholdsTableID,
        queries: [Query.limit(_pageSize)],
      );
      final badges = result.rows
          .map((row) => AchievementBadge.fromMap(row.data))
          .nonNulls
          .toList();
      return badges.isEmpty ? kDefaultBadges : badges;
    } catch (e) {
      log('AchievementsRepository: could not load the catalogue: $e');
      return kDefaultBadges;
    }
  }

  Future<ActivityResult> recordActivity({int interactions = 0}) => _record({
    'action': 'activity',
    if (interactions > 0) 'interactions': interactions,
  });

  Future<ActivityResult> recordRoomCredit(String roomId) =>
      _record({'action': 'roomCredit', 'roomId': roomId});

  Future<ActivityResult> setShowcase({
    required List<String> displayedBadges,
    required String? avatarBadge,
  }) => _record({
    'action': 'display',
    'displayedBadges': displayedBadges,
    'avatarBadge': avatarBadge,
  });

  Future<ActivityResult> _record(Map<String, dynamic> body) async {
    final response = await _functions.execute(
      functionId: recordActivityFunctionID,
      body: body,
    );
    final stats = response['stats'];
    return (
      stats: stats is Map<String, dynamic>
          ? UserStats.fromMap(stats)
          : UserStats.empty,
      newBadges: (response['newBadges'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
    );
  }
}
