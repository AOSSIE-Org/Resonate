import 'dart:developer';

import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/interests/data/repositories/interests_repository.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/my_interests.g.dart';

@Riverpod(keepAlive: true)
class MyInterests extends _$MyInterests {
  @override
  Future<List<Interest>> build() async {
    final uid = ref.watch(currentUserProvider)?.uid;
    if (uid == null) return const [];
    try {
      return await ref.read(interestsRepositoryProvider).loadInterests(uid);
    } catch (e) {
      log('MyInterests: could not read the stored interests: $e');
      return const [];
    }
  }

  Future<bool> save(List<Interest> interests) async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return false;

    final capped = interests.take(Interest.maxSelectable).toList();
    try {
      await ref
          .read(interestsRepositoryProvider)
          .setInterests(uid: uid, interests: capped);
      if (ref.mounted) state = AsyncData(capped);
      return true;
    } catch (e) {
      log('MyInterests: could not save the interests: $e');
      return false;
    }
  }
}
