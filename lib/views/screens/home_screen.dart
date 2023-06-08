import 'package:flutter/material.dart';

import '../../utils/enums/room_state.dart';
import '../widgets/room_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Column(
        children: [
          RoomTile(
            roomName:
                'For the love of open source ♥️ #flutter #resonate #aossie',
            roomState: RoomState.live,
            totalActiveMembers: 263,
            tags: ["Open Source", "Voice Platform", "New"],
            memberAvatarUrls: [
              "https://avatars.githubusercontent.com/u/58695010?s=96&v=4",
              "https://avatars.githubusercontent.com/u/41890434?v=4",
              "https://avatars.githubusercontent.com/u/43133646?s=96&v=4",
            ],
          ),
          RoomTile(
            roomName:
            'AOSSIE Team meeting',
            roomState: RoomState.scheduled,
            totalActiveMembers: 42,
            tags: ["Audio", "Review meet"],
            memberAvatarUrls: [
              "https://avatars.githubusercontent.com/u/43133646?s=96&v=4",
              "https://avatars.githubusercontent.com/u/58695010?s=96&v=4",
              "https://avatars.githubusercontent.com/u/41890434?v=4",
            ],
          ),
        ],
      ),
    );
  }
}

