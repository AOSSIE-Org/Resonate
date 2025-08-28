import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/resonate_user.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/views/screens/create_story_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';
import 'package:resonate/views/screens/story_screen.dart';

class FilteredListTile extends StatelessWidget {
  final Story? story;
  final bool isStory;
  final ResonateUser? user;

  const FilteredListTile(
      {this.story, required this.isStory, this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isStory) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryScreen(
                story: story!,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                creator: user,
                isCreatorProfile: true,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                isStory ? story!.coverImageUrl : user!.profileImageUrl!),
            radius: 25,
          ),
          trailing: isStory
              ? Text(
                  formatPlayDuration(story!.playDuration),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Inter',
                      ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Text(user!.userRating!.toStringAsFixed(1)),
                  ],
                ),
          title: Text(
            isStory ? story!.title : user!.userName!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
          ),
          subtitle: Text(
            "${isStory ? AppLocalizations.of(context)!.story : AppLocalizations.of(context)!.user} · ${isStory ? story!.creatorName : user!.name!}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 12,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
          ),
        ),
      ),
    );
  }
}
