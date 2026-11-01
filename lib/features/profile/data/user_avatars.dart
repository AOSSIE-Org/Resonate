import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/user_avatars.g.dart';

@riverpod
Future<String?> userAvatarUrl(Ref ref, String uid) async {
  if (uid.isEmpty) return null;
  try {
    final row = await ref
        .read(appwriteTablesProvider)
        .getRow(databaseId: userDatabaseID, tableId: usersTableID, rowId: uid);
    return row.data['profileImageUrl'] as String?;
  } catch (_) {
    return null;
  }
}


String bestAvatarUrl(WidgetRef ref, {required String uid, required String stored}) {
  final live = ref.watch(userAvatarUrlProvider(uid)).value;
  return (live == null || live.isEmpty) ? stored : live;
}
