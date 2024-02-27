import 'package:resonate/utils/enums/room_state.dart';

//AppwriteRoom is a model class for an AppWrite room.
//This class defines the structure of the Voice chat room.
class AppwriteRoom {
  AppwriteRoom(
      {required this.id, //identifier for the room
      required this.name, //name of the room
      required this.description, //description or additional information about the room
      required this.totalParticipants, //The total number of participants (users) in the room.
      required this.tags, //A list of tags associated with the room
      required this.memberAvatarUrls, //A list of URLs representing the avatars of members in the room
      required this.state, //An object of type RoomState representing the state of the room.
      required this.isUserAdmin, //A boolean indicating whether the user is an administrator of the room.
      this.myDocId //optional parameter
      });
  //variables marked by `late final` will be initialized at a later point, and
  //'final' indicates that once initialized, their values will not change.
  late final String id;
  late final String name;
  late final String description;
  late final int totalParticipants;
  late final List tags;
  late final List<String> memberAvatarUrls;
  late final RoomState state;
  late final bool isUserAdmin;
  late String? myDocId;
}
