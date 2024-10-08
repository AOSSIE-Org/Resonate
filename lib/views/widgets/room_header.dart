import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

class RoomHeader extends StatelessWidget {
  const RoomHeader(
      {super.key,
      required this.roomName,
      required this.roomDescription,
      this.roomTags});
  final String roomName;
  final String roomDescription;
  final String? roomTags;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          roomName,
          style: TextStyle(
            fontSize: UiSizes.size_20,
            // color: Colors.black,
          ),
        ),
        SizedBox(height: UiSizes.height_8),
        Text(
          roomTags ?? "",
          style: TextStyle(
            fontSize: UiSizes.size_15,
            fontWeight: FontWeight.w100,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: UiSizes.height_7),
        Text(
          roomDescription,
          style: TextStyle(
            color: Colors.grey,
            fontSize: UiSizes.size_14,
          ),
        ),
      ],
    );
  }
}
