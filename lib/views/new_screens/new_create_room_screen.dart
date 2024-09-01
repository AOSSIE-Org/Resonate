import 'package:flutter/material.dart';
import 'package:resonate/views/new_screens/new_home_screen.dart';

class StartRoomBottomSheet extends StatelessWidget {
  const StartRoomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        //! check it in ui
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          // wrap with form here
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'START ROOM',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LIVE',
                  //! check it in ui
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    // Theme.of(context).colorScheme.onTertiary, // is not selected
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 25),
                const Text(
                  'Scheduled',
                  //! check it in ui
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Give a great name',
                filled: true,
                //! check it in ui
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Tags',
                filled: true,
                //! check it in ui
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Descriptions',
                filled: true,
                //! check it in ui
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Start Now',
                  //! check it in ui
                  // style: TextStyle(
                  //   color: Colors.white,
                  // ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'or start a private chat with one of online friends',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Row(
                children: [
                  CustomCircleAvatar(
                    userImage:
                        'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Aya Nady',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onTertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Add',
                  // style: TextStyle(
                  //   color: Colors.white,
                  // ),
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Row(
                children: [
                  CustomCircleAvatar(
                    userImage:
                        'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Chandan Gowda',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onTertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Add',
                  // style: TextStyle(
                  //   color: Colors.white,
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showStartRoomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    showDragHandle: true,
    elevation: 0,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.secondary,
    builder: (context) => const StartRoomBottomSheet(),
  );
}
