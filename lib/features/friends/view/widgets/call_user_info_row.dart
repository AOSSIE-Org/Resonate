import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

// Avatar + name row shared by the friend call and pair chat pages.
class CallUserInfoRow extends StatelessWidget {
  const CallUserInfoRow({
    super.key,
    required this.imageUrl,
    required this.userName,
  });

  final String imageUrl;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: UiSizes.width_66,
        ),
        SizedBox(width: UiSizes.width_16),
        Container(
          alignment: Alignment.center,
          width: UiSizes.width_100,
          child: Text(
            userName,
            style: TextStyle(fontSize: UiSizes.size_16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
