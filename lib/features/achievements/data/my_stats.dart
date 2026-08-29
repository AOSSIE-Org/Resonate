import 'dart:developer';

import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/my_stats.g.dart';

@Riverpod(keepAlive: true)
class MyStats extends _$MyStats {
  @override
  Future<UserStats> build() async {
    final uid = ref.watch(currentUserProvider)?.uid;
    if (uid == null) return UserStats.empty;
    return ref.read(achievementsRepositoryProvider).loadStats(uid);
  }

  void apply(UserStats stats) {
    if (!ref.mounted) return;
    state = AsyncData(stats);
  }

  Future<bool> setShowcase({
    required List<String> displayedBadges,
    required String? avatarBadge,
  }) async {
    try {
      final result = await ref
          .read(achievementsRepositoryProvider)
          .setShowcase(
            displayedBadges: displayedBadges,
            avatarBadge: avatarBadge,
          );
      apply(result.stats);
      return true;
    } catch (e) {
      log('MyStats: could not update the showcase: $e');
      return false;
    }
  }
}
