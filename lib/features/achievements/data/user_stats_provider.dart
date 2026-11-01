import 'dart:async';

import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/user_stats_provider.g.dart';

const Duration _statsCacheWindow = Duration(minutes: 5);

@riverpod
Future<UserStats> userStats(Ref ref, String uid) {
  final link = ref.keepAlive();
  final timer = Timer(_statsCacheWindow, link.close);
  ref.onDispose(timer.cancel);
  return ref.watch(achievementsRepositoryProvider).loadStats(uid);
}
