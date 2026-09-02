import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/activity_status.dart';
import 'package:resonate/utils/realtime_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/activity_status_repository.g.dart';

@Riverpod(keepAlive: true)
ActivityStatusRepository activityStatusRepository(Ref ref) => ActivityStatusRepository(
  tables: ref.watch(appwriteTablesProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
);

class ActivityStatusRepository {
  ActivityStatusRepository({required TablesDB tables, required Realtime realtime})
    : _tables = tables,
      _realtime = realtime;

  final TablesDB _tables;
  final Realtime _realtime;

  static const _pageSize = 100;

  Future<ActivityStatus?> loadStatus(String uid) async {
    final row = await _tables.getRow(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: uid,
      queries: [
        Query.select([r'$id', 'status']),
      ],
    );
    return ActivityStatus.fromWire(row.data['status'] as String?);
  }

  Future<Map<String, ActivityStatus>> loadStatuses(Set<String> uids) async {
    if (uids.isEmpty) return const {};
    final ids = uids.toList();
    final statuses = <String, ActivityStatus>{};
    for (var i = 0; i < ids.length; i += _pageSize) {
      final end = i + _pageSize > ids.length ? ids.length : i + _pageSize;
      final chunk = ids.sublist(i, end);
      final result = await _tables.listRows(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        queries: [
          Query.equal(r'$id', chunk),
          Query.select([r'$id', 'status']),
          Query.limit(chunk.length),
        ],
      );
      for (final row in result.rows) {
        final status = ActivityStatus.fromWire(row.data['status'] as String?);
        if (status != null) statuses[row.$id] = status;
      }
    }
    return statuses;
  }

  Future<void> setStatus({
    required String uid,
    required ActivityStatus status,
  }) async {
    await _tables.updateRow(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: uid,
      data: {'status': status.wire},
    );
  }

  Stream<({String uid, ActivityStatus status})> activityStatusStream() {
    final channel = 'databases.$userDatabaseID.tables.$usersTableID.rows';
    final subscription = _realtime.subscribe([channel]);
    final controller = StreamController<({String uid, ActivityStatus status})>();

    final sub = subscription.stream.listen((data) {
      if (data.payload.isEmpty) return;
      if (realtimeAction(data.events) != 'update') return;

      final uid = data.payload[r'$id'] as String?;
      final status = ActivityStatus.fromWire(data.payload['status'] as String?);
      if (uid == null || status == null) return;

      controller.add((uid: uid, status: status));
    });

    controller.onCancel = () async {
      await sub.cancel();
      await subscription.close();
    };
    return controller.stream;
  }
}
