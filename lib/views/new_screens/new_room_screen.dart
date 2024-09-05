import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/models/participant.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/enums/room_state.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/new_screens/new_room_chat_screen.dart';

class NewRoomScreen extends StatefulWidget {
  const NewRoomScreen({
    Key? key,
  }) : super(key: key);

  @override
  _NewRoomScreenState createState() => _NewRoomScreenState();
}

class _NewRoomScreenState extends State<NewRoomScreen> {
  late final ThemeController themeController;
  // late final SingleRoomController controller;
  final AppwriteRoom room = AppwriteRoom(
    id: 'room1',
    name: 'Sample Room',
    description: 'This is a sample room for demonstration purposes.',
    totalParticipants: 10,
    tags: ['sample', 'demo', 'mock'],
    memberAvatarUrls: [
      'https://img.freepik.com/free-photo/joyful-excited-woman-making-winner-gesture_74855-3552.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      'https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      'https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
    ],
    state: RoomState.live,
    isUserAdmin: true,
    myDocId: 'doc123',
  );

  var participants = [
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'Amar',
      dpUrl:
          'https://img.freepik.com/free-vector/young-man-using-smartphone_24908-81611.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'Amar',
      dpUrl:
          'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'Amar',
      dpUrl:
          'https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'Amar',
      dpUrl:
          'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'Amar',
      dpUrl:
          'https://img.freepik.com/free-photo/close-up-young-successful-man-smiling-camera-standing-casual-outfit-against-blue-background_1258-66609.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'Amar',
      dpUrl:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'Amar',
      dpUrl:
          'https://img.freepik.com/free-photo/portrait-happy-male-with-broad-smile_176532-8175.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'Amar',
      dpUrl:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'Amar',
      dpUrl:
          'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'Amar',
      dpUrl:
          'https://img.freepik.com/free-photo/joyful-excited-woman-laughing-joke_74855-3551.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
    Participant(
      uid: '1',
      email: 'amar@example.com',
      name: 'aya',
      dpUrl:
          'https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
      isAdmin: true,
      isMicOn: true,
      isModerator: true,
      isSpeaker: true,
      hasRequestedToBeSpeaker: false,
    ).obs,
  ];
  @override
  void initState() {
    super.initState();
    // controller = Get.put(SingleRoomController(appwriteRoom: room));
    themeController = Get.find<ThemeController>();
  }

  Future<dynamic> _deleteRoomDialog(String text, Function() onTap) async {
    return await Get.defaultDialog(
      title: "Are you sure?",
      buttonColor: themeController.primaryColor.value,
      middleText: "To $text the room",
      cancelTextColor: themeController.primaryColor.value,
      onConfirm: onTap,
      onCancel: () => log("canceled"),
    );
  }

  String _getTags() {
    if (room.tags.isEmpty) return "";
    return room.tags.join(" · ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: UiSizes.width_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoomHeader(),
            SizedBox(height: UiSizes.height_7),
            Expanded(child: _buildParticipantsList()),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
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
            Get.to(NewRoomChatScreen());
          },
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16.0, left: 16),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://img.freepik.com/free-vector/user-blue-gradient_78370-4692.jpg?ga=GA1.1.338869508.1708106114&semt=sph'),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          room.name,
          style: TextStyle(
            fontSize: UiSizes.size_20,
            // color: Colors.black,
          ),
        ),
        SizedBox(height: UiSizes.height_8),
        Text(
          _getTags(),
          style: TextStyle(
            fontSize: UiSizes.size_15,
            fontWeight: FontWeight.w100,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: UiSizes.height_7),
        Text(
          room.description,
          style: TextStyle(
            color: Colors.grey,
            fontSize: UiSizes.size_14,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsList() {
    // return Obx(() {
    //   if (controller.isLoading.value) {
    //     return Center(
    //       child: LoadingAnimationWidget.threeRotatingDots(
    //         color: themeController.primaryColor.value,
    //         size: Get.pixelRatio * 20,
    //       ),
    //     );
    //   } else {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.15)),
      ),
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildParticipantsSection(
              title: "Participants",
              participants: participants,
            ),
          ],
        ),
      ),
      _buildFooter(),
    ]);
  }
  //   });
  // }

  Widget _buildParticipantsSection({
    required String title,
    required List<Rx<Participant>> participants,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: UiSizes.size_18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: UiSizes.width_20,
              mainAxisSpacing: UiSizes.height_5,
              childAspectRatio: 2 / 3,
            ),
            itemCount: participants.length,
            itemBuilder: (ctx, index) {
              return ParticepantItem(
                participant: participants[index].value,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(24),
            color: Theme.of(context).colorScheme.surface),
        child: Row(
          children: [
            _buildLeaveButton(),
            _buildRaiseHand(),
            _buildMicrophone(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveButton() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.058,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.rightFromBracket,
            color: Color.fromARGB(255, 198, 40, 29),
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            "Leave",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildRaiseHand() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.058,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.hand,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildMicrophone() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.058,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.onPrimary),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.microphone,
            size: 32,
          ),
        ],
      ),
    );
  }
  // Widget _buildFooter() {
  //   return SafeArea(
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 8.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           _buildLeaveButton(),
  //           _buildRaiseHandButton(),
  //           _buildMicButton(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildLeaveButton() {
  //   return ElevatedButton.icon(
  //     onPressed: () async {
  //       await _deleteRoomDialog(
  //         controller.appwriteRoom.isUserAdmin ? "delete" : "leave",
  //         () async {
  //           if (controller.appwriteRoom.isUserAdmin) {
  //             await controller.deleteRoom();
  //           } else {
  //             await controller.leaveRoom();
  //           }
  //         },
  //       );
  //     },
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: Colors.red,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //     ),
  //     icon: const Icon(Icons.exit_to_app),
  //     label: const Text("Leave"),
  //   );
  // }

  // Widget _buildRaiseHandButton() {
  //   return GetBuilder<SingleRoomController>(builder: (controller) {
  //     final bool hasRequestedToBeSpeaker =
  //         controller.me.value.hasRequestedToBeSpeaker;

  //     return FloatingActionButton(
  //       onPressed: () {
  //         if (hasRequestedToBeSpeaker) {
  //           controller.unRaiseHand();
  //         } else {
  //           controller.raiseHand();
  //         }
  //       },
  //       backgroundColor: hasRequestedToBeSpeaker
  //           ? themeController.primaryColor.value
  //           : Theme.of(context).brightness == Brightness.light
  //               ? Colors.white
  //               : Colors.black54,
  //       child: Icon(
  //         hasRequestedToBeSpeaker ? Icons.back_hand : Icons.back_hand_outlined,
  //         color: hasRequestedToBeSpeaker
  //             ? Colors.black
  //             : Theme.of(context).brightness == Brightness.light
  //                 ? Colors.black
  //                 : Colors.white54,
  //       ),
  //     );
  //   });
  // }

  // Widget _buildMicButton() {
  //   return GetBuilder<SingleRoomController>(builder: (controller) {
  //     final bool isMicOn = controller.me.value.isMicOn;
  //     final bool isSpeaker = controller.me.value.isSpeaker;

  //     return FloatingActionButton(
  //       onPressed: () {
  //         if (isSpeaker) {
  //           if (isMicOn) {
  //             controller.turnOffMic();
  //           } else {
  //             controller.turnOnMic();
  //           }
  //         }
  //       },
  //       backgroundColor: isMicOn ? Colors.lightGreen : Colors.redAccent,
  //       child: Icon(
  //         isMicOn ? Icons.mic : Icons.mic_off,
  //         color: Colors.black,
  //       ),
  //     );
  //   });
  // }
}

class ParticepantItem extends StatelessWidget {
  const ParticepantItem({super.key, required this.participant});
  final Participant participant;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
              participant.dpUrl), // Replace with actual image assets
        ),
        const SizedBox(height: 8),
        Text(participant.name),
      ],
    );
  }
}
