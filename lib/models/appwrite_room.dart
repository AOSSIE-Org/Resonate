import 'package:resonate/utils/enums/room_state.dart';

class AppwriteRoom{
  AppwriteRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.totalParticipants,
    required this.tags,
    required this.memberAvatarUrls,
    required this.state,
    this.myDocId
});
  late final String id;
  late final String name;
  late final String description;
  late final int totalParticipants;
  late final List tags;
  late final List<String> memberAvatarUrls;
  late final RoomState state;
  late final String? myDocId;
}