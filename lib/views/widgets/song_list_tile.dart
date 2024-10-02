import 'package:flutter/material.dart';
import 'package:resonate/models/sony_model.dart';

class SongListTile extends StatelessWidget {
  const SongListTile({
    super.key,
    required this.songModel,
  });

  final SongModel songModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        songModel.name,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 17,
              fontStyle: FontStyle.normal,
              fontFamily: 'Inter',
            ),
      ),
      subtitle: Text(
        'Song : ${songModel.type} ${songModel.singer}',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w400,
              fontSize: 17,
              fontStyle: FontStyle.normal,
              fontFamily: 'Inter',
            ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Image.asset(
          songModel.image,
        ),
      ),
      trailing: Icon(
        Icons.pause_circle_filled,
        color: Colors.grey[350],
      ),
      tileColor: Colors.transparent,
      onTap: () {},
    );
  }
}
