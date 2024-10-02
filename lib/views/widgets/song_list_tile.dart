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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        songModel.name,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 17,
              fontStyle: FontStyle.normal,
              fontFamily: 'Inter',
            ),
      ),
      subtitle: Text(
        '${songModel.type} - ${songModel.singer}',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12,
              fontStyle: FontStyle.normal,
              fontFamily: 'Inter',
            ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          songModel.image,
        ),
      ),
      trailing: Icon(
        Icons.play_arrow_rounded,
        color: Colors.grey[350],
      ),
      tileColor: Colors.transparent,
      onTap: () {},
    );
  }
}
