import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'new_home_screen.dart';

class NewNoRoomScreen extends StatelessWidget {
  NewNoRoomScreen({super.key});

  final List<String> categories = [
    'Popular',
    'Science',
    'Design',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 6,
        ),
        CachedNetworkImage(
          imageUrl:
              'https://s3-alpha-sig.figma.com/img/8c21/7e03/c10f3a587b9f9cfb69384f60f06a7f62?Expires=1722211200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=F0zPrNm7-s7PKGj-EkR969BdGyF4MZZWbaQwg90k7wxSHC40QhTaOrtY0-BsUzTLs~h0~3bqVhIjEmB3Wcp6rV72sUxU25meF2om9neJ5TNLgZFDAzHMtwliXWeaFUCOrM85PM6Gg2sZyoMC16EjH9cbI-mAeikbQEZ8~l3tMEDLZFN7NrOwOnMUGtsBsyAKzvTHsirXmVC~-d4VaQTszfYkfyVIafRBnFzI6WdzLj5DvabDORETExsyPWN4oeDZCw4cJCDhuPp-UiCzpFyPBxPSHOSvHbQn5WsKQa0qVGevzQU9kh2F~QcJ9Py9PDhOjdlS6YL91pV~Bb7NV9HsrA__',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width / 1.2,
          height: 200.0,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          '''No Rooms Available
      Get Started By Adding One Below! ''',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class GeneralAppBar extends StatelessWidget {
  const GeneralAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'LIVE',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 25),
        const Text(
          'UPCOMING',
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
