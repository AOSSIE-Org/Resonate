import 'package:resonate/features/rooms/model/appwrite_room.dart';


class MiniplayerSession {
  const MiniplayerSession({
    required this.speakerUid,
    required this.avatarUrl,
    required this.isMicOn,
    required this.canToggleMic,
    this.title,
    this.room,
  });

  final String speakerUid;
  final String avatarUrl;
  final bool isMicOn;

  // A room listener has no mic to turn on.
  final bool canToggleMic;

  final String? title;
  final AppwriteRoom? room;
}
