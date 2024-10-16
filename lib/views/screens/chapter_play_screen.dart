import 'package:flutter/material.dart';
import 'package:resonate/models/chapter.dart';

class ChapterPlayScreen extends StatefulWidget {
  final Chapter chapter; // Passing the selected chapter

  const ChapterPlayScreen({
    super.key,
    required this.chapter,
  });

  @override
  ChapterPlayScreenState createState() => ChapterPlayScreenState();
}

class ChapterPlayScreenState extends State<ChapterPlayScreen> {
  int currentPage = 0;
  double currentTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.chapter.tintColor.withOpacity(0.8),
                    widget.chapter.tintColor.withOpacity(0.3)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  // Chapter Cover Image Screen
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            widget.chapter.coverImageUrl,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.chapter.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Lyrics Screen
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.chapter.lyrics,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2, // Number of pages in the PageView
                (index) => Container(
                  margin: const EdgeInsets.all(4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPage == index
                        ? Colors.greenAccent
                        : Colors.grey.shade400,
                    boxShadow: currentPage == index
                        ? [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ]
                        : [],
                  ),
                ),
              ),
            ),

            // Play Controls and Progress Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Redesigned Progress Bar
                  Slider(
                    value: currentTime,
                    onChanged: (value) {
                      setState(() {
                        currentTime = value;
                      });
                    },
                    min: 0,
                    max:
                        double.parse(widget.chapter.playDuration.split(':')[0]),
                    activeColor: Colors.greenAccent,
                    inactiveColor: Colors.grey.shade300,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${currentTime.toStringAsFixed(0)} min"),
                      Text("${widget.chapter.playDuration} min"),
                    ],
                  ),
                ],
              ),
            ),

            // Title and About Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.chapter.title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Inter',
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.chapter.description,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Inter',
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
