import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/views/screens/room_chat_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';

class RoomAppBar extends StatelessWidget {
  const RoomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.keyboard_arrow_down,
          // color: Colors.black,
          size: 36,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.comments,
          ),
          onPressed: () {
            Get.to(RoomChatScreen());
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16),
          child: GestureDetector(
            onTap: () => Get.to(const ProfileScreen()),
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg?ga=GA1.1.338869508.1708106114&semt=sph'),
            ),
          ),
        ),
      ],
    );
  }
}
