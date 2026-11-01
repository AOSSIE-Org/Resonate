import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/active_room.g.dart';

@Riverpod(keepAlive: true)
class ActiveRoom extends _$ActiveRoom {
  @override
  AppwriteRoom? build() => null;

  void enter(AppwriteRoom room) => state = room;

  void clear() => state = null;
}
