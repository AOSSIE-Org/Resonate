import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/interests/data/my_interests.dart';
import 'package:resonate/features/interests/data/repositories/interests_repository.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/shared/model/resonate_user.dart';


class FakeInterestsRepository implements InterestsRepository {
  final List<({Set<Interest> interests, String? excludeUid})> calls = [];
  List<ResonateUser> Function(Set<Interest> interests) matches = (_) => const [];

  Completer<void>? gate;
  Object? error;

  @override
  Future<List<ResonateUser>> usersWithInterests(
    Set<Interest> interests, {
    String? excludeUid,
    int limit = InterestsRepository.matchPageSize,
  }) async {
    calls.add((interests: {...interests}, excludeUid: excludeUid));
    if (gate != null) await gate!.future;
    if (error != null) throw error!;
    return matches(interests);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} not stubbed in FakeInterestsRepository',
  );
}

class FakeMyInterests extends MyInterests {
  FakeMyInterests([this.initial = const <Interest>[]]);

  final List<Interest> initial;
  final List<List<Interest>> saveCalls = [];
  bool saveSucceeds = true;

  @override
  Future<List<Interest>> build() async => initial;

  @override
  Future<bool> save(List<Interest> interests) async {
    saveCalls.add(interests);
    if (!saveSucceeds) return false;
    state = AsyncData(interests);
    return true;
  }
}

// The chip labels come from the l10n select message
String interestLabelInEnglish(Interest interest) => switch (interest) {
  Interest.ai => 'AI',
  Interest.music => 'Music',
  Interest.fitness => 'Fitness',
  Interest.anime => 'Anime',
  Interest.gaming => 'Gaming',
  Interest.technology => 'Technology',
  Interest.movies => 'Movies',
  Interest.books => 'Books',
  Interest.art => 'Art',
  Interest.travel => 'Travel',
  Interest.food => 'Food',
  Interest.sports => 'Sports',
  Interest.business => 'Business',
  Interest.science => 'Science',
  Interest.comedy => 'Comedy',
  Interest.wellness => 'Wellness',
};
