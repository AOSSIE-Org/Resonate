import 'package:flutter/material.dart';
import 'package:resonate/features/profile/view/pages/profile_page.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/view/pages/story_page.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/model/resonate_user.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/secondary_list_card.dart';

class FilteredListTile extends StatelessWidget {
  final Story? story;
  final bool isStory;
  final ResonateUser? user;

  const FilteredListTile({
    this.story,
    required this.isStory,
    this.user,
    super.key,
  }) : assert(
         isStory
             ? (story != null && user == null)
             : (user != null && story == null),
       );

  ImageProvider? get _avatar {
    final url = isStory ? story!.coverImageUrl : user!.profileImageUrl;
    return (url == null || url.isEmpty) ? null : NetworkImage(url);
  }

  String get _userHandle => user!.userName ?? user!.name ?? '';
  String get _userName => user!.name ?? user!.userName ?? '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        if (isStory) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StoryPage(story: story!)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ProfilePage(creator: user, isCreatorProfile: true),
            ),
          );
        }
      },
      child: SecondaryListCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: _avatar,
            radius: UiSizes.width_25,
            child: _avatar == null ? const Icon(Icons.person_outline) : null,
          ),
          trailing: isStory
              ? Text(
                  formatPlayDuration(story!.playDuration),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: UiSizes.size_14,
                    fontFamily: 'Inter',
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text((user!.userRating ?? 0).toStringAsFixed(1)),
                  ],
                ),
          title: Text(
            isStory ? story!.title : _userHandle,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: UiSizes.size_17,
              fontFamily: 'Inter',
            ),
          ),
          subtitle: Text(
            "${isStory ? AppLocalizations.of(context)!.story : AppLocalizations.of(context)!.user} · ${isStory ? story!.creatorName : _userName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: UiSizes.size_12,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
