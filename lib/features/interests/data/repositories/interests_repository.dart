import 'package:appwrite/appwrite.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/shared/model/resonate_user.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/interests_repository.g.dart';

@Riverpod(keepAlive: true)
InterestsRepository interestsRepository(Ref ref) =>
    InterestsRepository(tables: ref.watch(appwriteTablesProvider));

class InterestsRepository {
  InterestsRepository({required TablesDB tables}) : _tables = tables;

  final TablesDB _tables;

  static const int matchPageSize = 25;

  Future<List<Interest>> loadInterests(String uid) async {
    final row = await _tables.getRow(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: uid,
      queries: [
        Query.select([r'$id', 'interests']),
      ],
    );
    return Interest.fromWireList(row.data['interests']);
  }

  Future<void> setInterests({
    required String uid,
    required List<Interest> interests,
  }) async {
    await _tables.updateRow(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: uid,
      data: {'interests': Interest.toWireList(interests)},
    );
  }

  Future<List<ResonateUser>> usersWithInterests(
    Set<Interest> interests, {
    String? excludeUid,
    int limit = matchPageSize,
  }) async {
    if (interests.isEmpty) return const [];
    final result = await _tables.listRows(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      queries: [
        Query.contains('interests', Interest.toWireList(interests)),
        if (excludeUid != null) Query.notEqual(r'$id', excludeUid),
        Query.limit(limit),
      ],
    );
    return result.rows
        .map((row) => ResonateUser.fromRow(row.data, row.$id))
        .toList();
  }
}
