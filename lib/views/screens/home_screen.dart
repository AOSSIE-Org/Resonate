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
import 'package:resonate/views/widgets/search_rooms.dart';
import 'package:resonate/views/widgets/upcomming_room_tile.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

bool isLiveSelected = true;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UpcomingRoomsController upcomingRoomsController = Get.put(
    UpcomingRoomsController(),
  );
  final RoomsController roomsController = Get.put(RoomsController());
  bool _showSearchOverlay = false;

  Future<void> pullToRefreshData() async {
    await upcomingRoomsController.getUpcomingRooms();
    await roomsController.getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBarLiveRoom(
                    isLiveSelected: isLiveSelected,
                    onTabSelected: (bool selectedTab) {
                      setState(() {
                        isLiveSelected = selectedTab;
                        _showSearchOverlay = false;
                      });
                      roomsController.clearLiveSearch();
                      upcomingRoomsController.clearUpcomingSearch();
                    },
                    onSearchTapped: () {
                      setState(() {
                        _showSearchOverlay = true;
                      });
                    },
                  ),
                  SizedBox(height: UiSizes.height_16),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: pullToRefreshData,
                      child: Obx(
                        () => (isLiveSelected
                            ? roomsController.isLoading.value
                                  ? Center(
                                      child:
                                          LoadingAnimationWidget.fourRotatingDots(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            size: Get.pixelRatio * 20,
                                          ),
                                    )
                                  : LiveRoomListView()
                            : upcomingRoomsController.isLoading.value
                            ? Center(
                                child: LoadingAnimationWidget.fourRotatingDots(
                                  color: Theme.of(context).colorScheme.primary,
                                  size: Get.pixelRatio * 20,
                                ),
                              )
                            : UpcomingRoomsListView()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Search bar
            SearchOverlay(
              isVisible: _showSearchOverlay,
              onSearchChanged: (query) {
                if (isLiveSelected) {
                  roomsController.searchLiveRooms(query);
                } else {
                  upcomingRoomsController.searchUpcomingRooms(query);
                }
              },
              onClose: () {
                setState(() {
                  _showSearchOverlay = false;
                });
                if (isLiveSelected) {
                  roomsController.clearLiveSearch();
                } else {
                  upcomingRoomsController.clearUpcomingSearch();
                }
              },
              isSearching: isLiveSelected
                  ? roomsController.isSearching.value
                  : false,
            ),
          ],
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
    required this.onSearchTapped,
  });
  final Function(bool) onTabSelected;
  final VoidCallback onSearchTapped;
  final bool isLiveSelected;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onTabSelected(true),
          child: Text(
            AppLocalizations.of(context)!.live.toUpperCase(),
            style: TextStyle(
              color: isLiveSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: UiSizes.width_25),
        GestureDetector(
          onTap: () => onTabSelected(false),
          child: Text(
            AppLocalizations.of(context)!.upcoming.toUpperCase(),
            style: TextStyle(
              color: !isLiveSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onSearchTapped,
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
            size: UiSizes.size_24,
          ),
          tooltip: AppLocalizations.of(context)!.search,
        ),
      ],
    );
  }
}

class UpcomingRoomsListView extends StatelessWidget {
  UpcomingRoomsListView({super.key});
  final UpcomingRoomsController upcomingRoomsController = Get.put(
    UpcomingRoomsController(),
  );
  final RoomsController roomsController = Get.find<RoomsController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roomsToShow =
          upcomingRoomsController.filteredUpcomingRooms.isNotEmpty ||
              !upcomingRoomsController.searchBarIsEmpty.value
          ? upcomingRoomsController.filteredUpcomingRooms
          : upcomingRoomsController.upcomingRooms;

      if (roomsToShow.isNotEmpty) {
        return ListView.builder(
          itemCount: roomsToShow.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: UiSizes.height_8),
              child: UpCommingListTile(
                appwriteUpcommingRoom: roomsToShow[index],
              ),
            );
          },
        );
      } else {
        return upcomingRoomsController.upcomingRooms.isEmpty &&
                upcomingRoomsController.searchBarIsEmpty.value
            ? const NoRoomScreen(isRoom: false)
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: UiSizes.size_65,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    SizedBox(height: UiSizes.height_16),
                    Text(
                      AppLocalizations.of(context)!.noSearchResults,
                      style: TextStyle(
                        fontSize: UiSizes.size_16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_8),
                    Text(
                      AppLocalizations.of(context)!.clearSearch,
                      style: TextStyle(
                        fontSize: UiSizes.size_14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
      }
    });
  }
}

class LiveRoomListView extends StatelessWidget {
  LiveRoomListView({super.key});
  final RoomsController roomsController = Get.put(RoomsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roomsToShow = roomsController.searchBarIsEmpty.value
          ? roomsController.rooms
          : roomsController.filteredRooms;

      if (roomsController.isSearching.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.fourRotatingDots(
                color: Theme.of(context).colorScheme.primary,
                size: UiSizes.size_20,
              ),
              SizedBox(height: UiSizes.height_16),
              Text(
                AppLocalizations.of(context)!.searchingRooms,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        );
      }

      if (roomsToShow.isNotEmpty) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: roomsToShow.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: UiSizes.height_8),
              child: CustomLiveRoomTile(appwriteRoom: roomsToShow[index]),
            );
          },
        );
      } else {
        return roomsController.searchBarIsEmpty.value
            ? const NoRoomScreen(isRoom: true)
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: UiSizes.size_65,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    SizedBox(height: UiSizes.height_16),
                    Text(
                      AppLocalizations.of(context)!.noSearchResults,
                      style: TextStyle(
                        fontSize: UiSizes.size_16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_8),
                    Text(
                      AppLocalizations.of(context)!.clearSearch,
                      style: TextStyle(
                        fontSize: UiSizes.size_14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
      }
    });
  }
}

class CustomCategoryChips extends StatefulWidget {
  const CustomCategoryChips({super.key, required this.categories});

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
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categories.length,
          itemBuilder: (context, index) {
            return CategoryItem(
              isSelected: index == selectedIndex ? true : false,
              category: widget.categories[index],
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
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

  const CategoryItem({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

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
    reportedUsers: [],
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
    reportedUsers: [],
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
    reportedUsers: [],
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
    reportedUsers: [],
  ),
];
