import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/views/widgets/live_room_tile.dart';
import 'package:resonate/l10n/app_localizations.dart';

class NoRoomScreen extends StatelessWidget {
  final bool isRoom;
  const NoRoomScreen({super.key, required this.isRoom});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppImages.noRoomImage,
                  height: 200,
                  width: 200,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.noAvailableRoom(isRoom.toString()),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GeneralAppBar extends StatelessWidget {
  const GeneralAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.live.toUpperCase(),
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 25),
        Text(
          AppLocalizations.of(context)!.upcoming.toUpperCase(),
          style: TextStyle(color: Color.fromRGBO(118, 124, 134, 1)),
        ),
        const Spacer(),
        const CustomCircleAvatar(
          userImage:
              'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
        ),
      ],
    );
  }
}
