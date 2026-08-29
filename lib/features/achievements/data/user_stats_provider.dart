import 'package:resonate/features/achievements/data/repositories/achievements_repository.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/user_stats_provider.g.dart';

@Riverpod(keepAlive: true)
Future<UserStats> userStats(Ref ref, String uid) =>
    ref.watch(achievementsRepositoryProvider).loadStats(uid);
