import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/utils/enums/room_state.dart';
import 'package:resonate/views/new_screens/new_notifications_screen.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
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
              // : const GeneralAppBar(),
              CustomCategoryChips(
                categories: categories,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: pullToRefreshData,
                  child: (isLiveSelected
                      ? const LiveRoomListView()
                      : const UpcomingRoomsListView()),
                ),
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
        const Spacer(),
        Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(
          width: 15,
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Get.to(NewNotificationsScreen()),
        ),
        const SizedBox(width: 15),
        const CustomCircleAvatar(
          userImage:
              'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
        ),
      ],
    );
  }
}

//! Ui Compenet
class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    required this.userImage,
    this.width = 36,
    this.height = 36,
  });
  final String userImage;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            userImage,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
    );
  }
}

//! Ui Compenet
class CustomLiveRoomTile extends StatelessWidget {
  final AppwriteRoom appwriteRoom;

  const CustomLiveRoomTile({super.key, required this.appwriteRoom});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appwriteRoom.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: const Stack(
                    clipBehavior: Clip.antiAlias,
                    children: [
                      Positioned(
                        left: 0,
                        child: CustomCircleAvatar(
                          height: 40,
                          width: 40,
                          userImage:
                              'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
                        ),
                      ),
                      Positioned(
                        left: 28,
                        child: CustomCircleAvatar(
                          height: 40,
                          width: 40,
                          userImage:
                              'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
                        ),
                      ),
                      Positioned(
                        left: 28 * 2,
                        child: CustomCircleAvatar(
                          height: 40,
                          width: 40,
                          userImage:
                              'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
                        ),
                      ),
                      Positioned(
                        left: 28 * 3,
                        child: CustomCircleAvatar(
                          height: 40,
                          width: 40,
                          userImage:
                              'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
                        ),
                      ),
                      CustomCircleAvatar(
                        height: 40,
                        width: 40,
                        userImage:
                            'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
                      ),
                    ],
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    UserNameWithMicrophone(
                      name: 'Mohammmmed',
                    ),
                    UserNameWithMicrophone(
                      name: 'Aya',
                    ),
                    UserNameWithMicrophone(
                      name: 'Jo',
                    ),
                  ],
                ),
              ],
            ),
            IconWithNumbers(
              totalParticipant: appwriteRoom.totalParticipants,
            ),
          ],
        ),
      ),
    );
  }
}

class UpcomingRoomsListView extends StatelessWidget {
  const UpcomingRoomsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: upcomingRoomDummyData.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: UpCommingListTile(
            appwriteRoom: upcomingRoomDummyData[index],
          ),
        );
      },
    );
  }
}

class LiveRoomListView extends StatelessWidget {
  const LiveRoomListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      // primary: true,
      itemCount: upcomingRoomDummyData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: CustomLiveRoomTile(
            appwriteRoom: upcomingRoomDummyData[index],
          ),
        );
      },
    );
  }
}

//! Ui Compenet
class IconWithNumbers extends StatelessWidget {
  const IconWithNumbers({super.key, required this.totalParticipant});
  final int totalParticipant;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.people_outline,
          size: 13,
          // color: Colors.grey,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          '$totalParticipant',
        ),
        const SizedBox(
          width: 15,
        ),
        const Icon(
          Icons.mic,
          size: 13,
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          '3', //! add it in model later to make it dynamic
        ),
      ],
    );
  }
}

//! Ui Compenet
class UserNameWithMicrophone extends StatelessWidget {
  const UserNameWithMicrophone({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      // cros
      children: [
        SizedBox(
          width: 50,
          child: Text(
            name,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Icon(
          Icons.mic,
          size: 13,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ],
    );
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
              ? MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.secondary)
              : const MaterialStatePropertyAll(Colors.transparent),
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

List<AppwriteRoom> upcomingRoomDummyData = [
  AppwriteRoom(
    id: '0',
    name: 'Basics of Flutter App Development',
    description: 'Learn the basics of Flutter app development.',
    totalParticipants: 25,
    tags: ['Flutter', 'Workshop', 'Development'],
    memberAvatarUrls: ['url1', 'url2', 'url3'],
    state: RoomState.scheduled,
    isUserAdmin: true,
    myDocId: 'doc1',
  ),
  AppwriteRoom(
    id: '1',
    name: 'Flutter Development Workshop',
    description: 'Learn the basics of Flutter app development.',
    totalParticipants: 25,
    tags: ['Flutter', 'Workshop', 'Development'],
    memberAvatarUrls: ['url1', 'url2', 'url3'],
    state: RoomState.scheduled,
    isUserAdmin: true,
    myDocId: 'doc1',
  ),
  AppwriteRoom(
    id: '2',
    name: 'React Native Q&A Session',
    description: 'Ask questions about React Native development.',
    totalParticipants: 15,
    tags: ['React Native', 'Q&A'],
    memberAvatarUrls: ['url4', 'url5'],
    state: RoomState.scheduled,
    isUserAdmin: false,
    myDocId: 'doc2',
  ),
  AppwriteRoom(
    id: '3',
    name: 'Dart Language Deep Dive',
    description: 'Explore advanced Dart language features.',
    totalParticipants: 10,
    tags: ['Dart', 'Language', 'Advanced'],
    memberAvatarUrls: ['url6', 'url7', 'url8'],
    state: RoomState.recorded,
    isUserAdmin: false,
    myDocId: 'doc3',
  ),
  AppwriteRoom(
    id: '4',
    name: 'React Native Q&A Session',
    description: 'Ask questions about React Native development.',
    totalParticipants: 15,
    tags: ['React Native', 'Q&A'],
    memberAvatarUrls: ['url4', 'url5'],
    state: RoomState.scheduled,
    isUserAdmin: false,
    myDocId: 'doc2',
  ),
];

//! Ui Compenet
class UpCommingListTile extends StatelessWidget {
  const UpCommingListTile({super.key, required this.appwriteRoom});
  final AppwriteRoom appwriteRoom;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today , 06:00 pm',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none_outlined,
                  size: 34,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Text(
            appwriteRoom.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserImageWithName(
                name: 'Amar',
              ),
              const UserImageWithName(
                name: 'Aya',
              ),
              const UserImageWithName(
                name: 'Aresh',
              ),
            ].withSpacing(7),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            appwriteRoom.description,
            maxLines: 2,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

extension SpacedWidgets on List<Widget> {
  List<Widget> withSpacing(double spacing) {
    return asMap()
        .map((index, widget) {
          return MapEntry(
            index,
            [
              widget,
              if (index < length - 1) SizedBox(width: spacing),
            ],
          );
        })
        .values
        .expand((element) => element)
        .toList();
  }
}

////! Ui Compenet
class UserImageWithName extends StatelessWidget {
  const UserImageWithName({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomCircleAvatar(
          height: 40,
          width: 40,
          userImage:
              'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
        ),
        const SizedBox(
          height: 6,
        ),
        SizedBox(
          width: 40,
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
          ),
        ),
      ],
    );
  }
}
