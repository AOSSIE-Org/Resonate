import 'package:flutter/material.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:share_plus/share_plus.dart';

class CustomLiveRoomTile extends StatelessWidget {
  final AppwriteRoom appwriteRoom;

  const CustomLiveRoomTile({super.key, required this.appwriteRoom});

  @override
  Widget build(BuildContext context) {
    // Display the first three member avatars or as many as available.
    List<String> memberAvatars = appwriteRoom.memberAvatarUrls.length > 3
        ? appwriteRoom.memberAvatarUrls.sublist(0, 3)
        : appwriteRoom.memberAvatarUrls;

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
            // Room Name and Share Button
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appwriteRoom.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    Share.share(
                      '🚀 Check out this amazing room: ${appwriteRoom.name}!\n\n📖 Description: ${appwriteRoom.description}\n👥 Join ${appwriteRoom.totalParticipants} participants now!',
                    );
                  },
                ),
              ],
            ),
            // Room Tags
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: appwriteRoom.tags
                  .map((tag) => Text(
                        "#$tag",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                        ),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 8),

            // Room Description
            Text(
              appwriteRoom.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 5),
            
            // Total participants count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: memberAvatars
                            .asMap()
                            .entries
                            .map((entry) => Positioned(
                                  left: 28.0 * entry.key,
                                  child: CustomCircleAvatar(
                                    height: 40,
                                    width: 40,
                                    userImage: entry.value,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${appwriteRoom.totalParticipants} Participants',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    roomsController.joinRoom(
                        room: appwriteRoom, context: context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Join'),
                ),
              ],
            ),

            // Join button
          ],
        ),
      ),
    );
  }
}

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    required this.userImage,
    this.width = 40,
    this.height = 40,
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
          image: NetworkImage(userImage),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20), // Circular avatar
      ),
    );
  }
}
