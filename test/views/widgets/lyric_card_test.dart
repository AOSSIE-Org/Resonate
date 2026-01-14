import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/views/widgets/lyric_card.dart';

void main() {
  testWidgets('LyricCard builds correctly with provided data', (WidgetTester tester) async {
    // Create a mock chapter
    final chapter = Chapter(
      'test_id',
      'Test Title',
      'https://example.com/cover.jpg',
      'Description',
      'Lyrics content',
      'https://example.com/audio.mp3',
      1000,
      Colors.blue,
    );

    const lyricText = 'This is a test lyric';

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LyricCard(
            chapter: chapter,
            lyric: lyricText,
          ),
        ),
      ),
    );

    // Verify content matches
    expect(find.text('"This is a test lyric"'), findsOneWidget);
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Resonate'), findsOneWidget);
    
    // Verify structure
    expect(find.byType(Image), findsOneWidget); // Cover image
    expect(find.byIcon(Icons.multitrack_audio), findsOneWidget); // Logo icon
  });
}
