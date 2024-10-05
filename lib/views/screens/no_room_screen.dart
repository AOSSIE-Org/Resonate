import 'package:flutter/material.dart';
import 'package:resonate/views/widgets/live_room_tile.dart';

class NoRoomScreen extends StatelessWidget {
  final bool isRoom;
  const NoRoomScreen({super.key, required this.isRoom});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 6,
        ),
        Image.asset(height: 150, width: 150, 'assets/images/no_room.png'),
        const SizedBox(
          height: 30,
        ),
        Text(
          '''No ${isRoom ? 'Room' : 'Upcoming Room'} Available
Get Started By Adding One Below! ''',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class GeneralAppBar extends StatelessWidget {
  const GeneralAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'LIVE',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 25),
        const Text(
          'UPCOMING',
          style: TextStyle(color: Color.fromRGBO(118, 124, 134, 1)),
        ),
        const Spacer(),
        const CustomCircleAvatar(
          userImage:
              'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
        ),
      ],
    );
  }
}
