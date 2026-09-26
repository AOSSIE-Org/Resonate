import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/model/user_profile_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/user_profile_summaries.g.dart';

@riverpod
Future<UserProfileSummary> userProfileSummary(Ref ref, String uid) =>
    ref.watch(profileRepositoryProvider).fetchProfileSummary(uid);
