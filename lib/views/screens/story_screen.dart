import 'package:flutter/material.dart';
import 'package:resonate/models/story.dart';

import 'package:resonate/utils/ui_sizes.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key, required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: UiSizes.width_20,
            vertical: UiSizes.height_20,
          ),
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(
                height: UiSizes.height_40,
              ),
              Semantics(
                label: "${story.title} image",
                child: Container(
                  width: mq.width * 0.7,
                  height: mq.width * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        story.coverImageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: UiSizes.height_80,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  story.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: UiSizes.size_24,
                  ),
                ),
              ),
              Slider(
                value: 0.3,
                inactiveColor: Theme.of(context).colorScheme.secondary,
                onChanged: (value) {},
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("3:49"),
                  Text("6:45"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    semanticLabel: "Replay 10 seconds",
                    Icons.replay_10_rounded,
                    size: 50,
                  ),
                  SizedBox(
                    width: UiSizes.width_30,
                  ),
                  Semantics(
                    label: "Play/Pause",
                    child: GestureDetector(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(70),
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: UiSizes.width_30,
                  ),
                  const Icon(semanticLabel: "Forward 10 seconds",
                    Icons.forward_10_rounded,
                    size: 50,
                  ),
                ],
              ),
              SizedBox(
                height: UiSizes.height_40,
              ),
              MergeSemantics(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: UiSizes.size_15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_5,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        story.description,
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: UiSizes.size_12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
