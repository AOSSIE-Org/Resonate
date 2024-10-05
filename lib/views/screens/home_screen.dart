import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/controllers/upcomming_rooms_controller.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/models/appwrite_upcomming_room.dart';
import 'package:resonate/utils/enums/room_state.dart';
import 'package:resonate/views/screens/no_room_screen.dart';
import 'package:resonate/views/widgets/live_room_tile.dart';
import 'package:resonate/views/widgets/upcomming_room_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final RoomsController roomsController = Get.put(RoomsController());

final UpcomingRoomsController upcomingRoomsController =
    Get.put(UpcomingRoomsController());

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    'Popular',
    'Science',
    'Design',
  ];
  bool isLiveSelected = false;

  Future<void> pullToRefreshData() async {
    await Future.delayed(
      const Duration(
        microseconds: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBarLiveRoom(
                isLiveSelected: isLiveSelected,
                onTabSelected: (bool selectedTab) {
                  setState(
                    () {
                      isLiveSelected = selectedTab;
                    },
                  );
                },
              ),
              // Will be implemented later on
              // CustomCategoryChips(
              //   categories: categories,
              // ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: RefreshIndicator(
                    onRefresh: pullToRefreshData,
                    child: Obx(
                      () => (isLiveSelected
                          ? roomsController.isLoading.value
                              ? Center(
                                  child: LoadingAnimationWidget.fourRotatingDots(
                                                                        color:
                                    Theme.of(context).colorScheme.primary,
                                                                        size: Get.pixelRatio * 20,
                                                                      ))
                              : const LiveRoomListView()
                          : upcomingRoomsController.isLoading.value
                              ? Center(
                                  child: LoadingAnimationWidget.fourRotatingDots(
                                                                        color:
                                    Theme.of(context).colorScheme.primary,
                                                                        size: Get.pixelRatio * 20,
                                                                      ))
                              : const UpcomingRoomsListView()),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBarLiveRoom extends StatelessWidget {
  const CustomAppBarLiveRoom({
    super.key,
    required this.isLiveSelected,
    required this.onTabSelected,
  });
  final Function(bool) onTabSelected;
  final bool isLiveSelected;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onTabSelected(true),
          child: Text(
            'LIVE',
            style: TextStyle(
              color: isLiveSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 25),
        GestureDetector(
          onTap: () => onTabSelected(false),
          child: Text(
            'UPCOMING',
            style: TextStyle(
              color: !isLiveSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class UpcomingRoomsListView extends StatelessWidget {
  const UpcomingRoomsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return upcomingRoomsController.upcomingRooms.isEmpty
        ? ListView.builder(
            itemCount: upcomingRoomsController.upcomingRooms.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: UpCommingListTile(
                  appwriteUpcommingRoom:
                      upcomingRoomsController.upcomingRooms[index],
                ),
              );
            },
          )
        : const NoRoomScreen(isRoom: false);
  }
}

class LiveRoomListView extends StatelessWidget {
  const LiveRoomListView({super.key});

  @override
  Widget build(BuildContext context) {
    return roomsController.rooms.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: roomsController.rooms.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: CustomLiveRoomTile(
                  appwriteRoom: roomsController.rooms[index],
                ),
              );
            },
          )
        : const NoRoomScreen(isRoom: true);
  }
}

class CustomCategoryChips extends StatefulWidget {
  const CustomCategoryChips({
    super.key,
    required this.categories,
  });

  final List<String> categories;

  @override
  State<CustomCategoryChips> createState() => _CustomCategoryChipsState();
}

class _CustomCategoryChipsState extends State<CustomCategoryChips> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: MediaQuery.of(context).size.width / 1.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categories.length,
          itemBuilder: (context, index) {
            return CategoryItem(
              isSelected: index == selectedIndex ? true : false,
              category: widget.categories[index],
              onTap: () {
                setState(
                  () {
                    selectedIndex = index;
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryItem(
      {super.key, required this.category, this.isSelected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          color: isSelected
              ? WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary)
              : const WidgetStatePropertyAll(Colors.transparent),
          side: BorderSide.none,
          label: Text(
            category,
            style: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onTertiary,
            ),
          ),
          backgroundColor: Colors.transparent,
          labelStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

List<AppwriteUpcommingRoom> upcomingRoomDummyData = [
  AppwriteUpcommingRoom(
    id: 'room1',
    name: 'Flutter Devs Meetup',
    isTime: true,
    scheduledDateTime: DateTime(2024, 10, 10, 14, 30),
    description:
        'A meetup for Flutter developers to discuss the latest trends in Flutter development.',
    totalSubscriberCount: 2,
    tags: ['flutter', 'development', 'mobile'],
    subscribersAvatarUrls: [
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
    ],
    userIsCreator: false,
    hasUserSubscribed: true,
  ),
  AppwriteUpcommingRoom(
    id: 'room4',
    name: 'Flutter Devs Meetup',
    isTime: true,
    scheduledDateTime: DateTime(2024, 10, 10, 14, 30),
    description:
        'A meetup for Flutter developers to discuss the latest trends in Flutter development.',
    totalSubscriberCount: 2,
    tags: ['flutter', 'development', 'mobile'],
    subscribersAvatarUrls: [
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
    ],
    userIsCreator: false,
    hasUserSubscribed: false,
  ),
  AppwriteUpcommingRoom(
    id: 'room2',
    name: 'Appwrite Deep Dive',
    isTime: true,
    scheduledDateTime: DateTime(2024, 11, 5, 10, 00),
    description:
        'Learn the ins and outs of Appwrite in this deep dive session.',
    totalSubscriberCount: 3,
    tags: ['appwrite', 'backend', 'open-source'],
    subscribersAvatarUrls: [
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
    ],
    userIsCreator: true,
    hasUserSubscribed: false,
  ),
  AppwriteUpcommingRoom(
    id: 'room3',
    name: 'Dart & Appwrite Integration',
    isTime: false,
    scheduledDateTime: DateTime(2024, 10, 15, 16, 00),
    description:
        'Exploring the integration of Dart with Appwrite for seamless app development.',
    totalSubscriberCount: 3,
    tags: ['dart', 'appwrite', 'integration'],
    subscribersAvatarUrls: [
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
    ],
    userIsCreator: true,
    hasUserSubscribed: false,
  ),
];

List<AppwriteRoom> appwriteRooms = [
  AppwriteRoom(
    id: 'room_001',
    name: 'Flutter Dev Room',
    description: 'Discuss all things Flutter development.',
    totalParticipants: 3,
    tags: ['flutter', 'development', 'mobile'],
    memberAvatarUrls: [
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
    ],
    state: RoomState.live,
    isUserAdmin: true,
    myDocId: 'doc123',
  ),
  AppwriteRoom(
    id: 'room_002',
    name: 'Appwrite Enthusiasts',
    description: 'A room for Appwrite fans to share and learn.',
    totalParticipants: 3,
    tags: ['appwrite', 'open-source', 'backend'],
    memberAvatarUrls: [
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
    ],
    state: RoomState.live,
    isUserAdmin: false,
    myDocId: 'doc456',
  ),
  AppwriteRoom(
    id: 'room_003',
    name: 'Backend Developers Hub',
    description: 'Discuss modern backend architectures and APIs.',
    totalParticipants: 3,
    tags: ['backend', 'architecture', 'api'],
    memberAvatarUrls: [
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
    ],
    state: RoomState.live,
    isUserAdmin: false,
    myDocId: null,
  ),
  AppwriteRoom(
    id: 'room_004',
    name: 'Mobile Dev Summit',
    description: 'A discussion room for mobile development trends.',
    totalParticipants: 3,
    tags: ['mobile', 'development', 'summit'],
    memberAvatarUrls: [
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
    ],
    state: RoomState.live,
    isUserAdmin: true,
    myDocId: 'doc789',
  ),
];
