import 'package:flutter/material.dart';

class NoMatchView extends StatelessWidget {
  const NoMatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No Search Results',
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    );
  }
}
