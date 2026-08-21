import 'dart:async';
import 'dart:developer';

import 'package:resonate/features/rooms/data/repositories/room_polls_repository.dart';
import 'package:resonate/features/rooms/data/room_polls.dart';
import 'package:resonate/features/rooms/model/poll_vote.dart';
import 'package:resonate/features/rooms/model/voter_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/voter_profiles.g.dart';


@riverpod
class VoterProfiles extends _$VoterProfiles {
  final Map<String, VoterProfile> _cache = {};
  final Set<String> _requested = {};

  @override
  Map<String, VoterProfile> build(String roomId) {
    final votes =
        ref.watch(roomPollsProvider(roomId)).value?.votes ??
        const <PollVote>[];
    final shownPerOption = <String, int>{};
    final missing = <String>{};
    for (final vote in votes) {
      final key = '${vote.pollId}|${vote.optionIndex}';
      final shown = shownPerOption[key] ?? 0;
      if (shown >= kPollOptionAvatarCap) continue;
      shownPerOption[key] = shown + 1;
      if (!_requested.contains(vote.uid)) missing.add(vote.uid);
    }
    if (missing.isNotEmpty) {
      _requested.addAll(missing);
      unawaited(_fetch(missing));
    }

    return Map.unmodifiable(_cache);
  }

  Future<void> _fetch(Set<String> uids) async {
    try {
      final profiles = await ref
          .read(roomPollsRepositoryProvider)
          .loadVoterProfiles(uids);
      _cache.addEntries(profiles.map((p) => MapEntry(p.uid, p)));
      if (!ref.mounted) return;
      state = Map.unmodifiable(_cache);
    } catch (e) {
      // those avatars just won't show, later retry.
      _requested.removeAll(uids);
      log('loadVoterProfiles failed: $e');
    }
  }
}
