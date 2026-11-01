import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/friends/model/friends_model.dart';

// The state of the friends list
class FriendRowsState {
  const FriendRowsState({required this.rows, this.busy = const <String>{}});

  final AsyncValue<List<FriendsModel>> rows;
  final Set<String> busy;

  bool isBusy(String docId) => busy.contains(docId);

  FriendRowsState copyWith({
    AsyncValue<List<FriendsModel>>? rows,
    Set<String>? busy,
  }) => FriendRowsState(rows: rows ?? this.rows, busy: busy ?? this.busy);
}
