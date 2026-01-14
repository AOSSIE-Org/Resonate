import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/views/widgets/lyric_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';

class ChapterPlayerController extends GetxController {
  Rx<int> currentPage = 0.obs;
  Rx<int> lyricProgress = 0.obs;
  Rx<double> sliderProgress = 0.0.obs;
  Rx<bool> isPlaying = false.obs;
  Rx<bool> isSharing = false.obs;
  AudioPlayer? audioPlayer;
  late Duration chapterDuration;
  late LyricsReaderModel lyricModel;
  
  final GlobalKey lyricCardKey = GlobalKey();

  void initialize(
    AudioPlayer player,
    LyricsReaderModel model,
    Duration duration,
  ) {
    audioPlayer = player;
    lyricModel = model;
    chapterDuration = duration;
    audioPlayer?.setReleaseMode(ReleaseMode.stop);

    audioPlayer?.onPositionChanged.listen((Duration event) {
      sliderProgress.value = event.inMilliseconds.toDouble();
      lyricProgress.value = event.inMilliseconds;
    });

    audioPlayer?.onPlayerStateChanged.listen((PlayerState state) {
      isPlaying.value = state == PlayerState.playing;
    });
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.resume();
    }
    isPlaying.value = !isPlaying.value;
  }

  /// Retrieves the current lyric line based on audio playback position.
  /// 
  /// This iterates through the lyric model to find the latest segment that
  /// has started. It defaults to the first line or "Resonate" if none match.
  String getCurrentLyric() {
    try {
      final line = lyricModel.lyrics.lastWhere(
        (element) => element.startTime! <= lyricProgress.value,
        orElse: () => lyricModel.lyrics.first,
      );
      return line.mainText ?? "";
    } catch (e) {
      return "Resonate";
    }
  }

  /// Initiates the social sharing flow for the currently playing lyric.
  ///
  /// This displays a hidden dialog containing the [LyricCard] to allow
  /// the [RepaintBoundary] to render it off-screen before capturing.
  Future<void> shareCurrentLyric(BuildContext context, Chapter chapter) async {
    isSharing.value = true;
    final currentLine = getCurrentLyric();
    
    // We render the LyricCard inside a hidden dialog.
    // This trick allows us to use RepaintBoundary on a widget that hasn't
    // been drawn to the main screen yet, without messing up the UI.
    await showDialog(
      context: context, 
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             RepaintBoundary(
              key: lyricCardKey,
              child: LyricCard(chapter: chapter, lyric: currentLine),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await _captureAndShare();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
              label: const Text(
                "Share Card",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2962FF), // Resonate Blue
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: const Color(0xFF2962FF).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
    isSharing.value = false;
  }

  /// Captures the [LyricCard] as a PNG image and shares it via platform channel.
  Future<void> _captureAndShare() async {
    try {
      RenderRepaintBoundary? boundary = lyricCardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) return;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/lyric_card.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Check out this story on Resonate!');
    } catch (e) {
      debugPrint("Error sharing lyric card: $e");
    }
  }

  @override
  void onClose() {
    audioPlayer?.release();
    super.onClose();
  }
}
