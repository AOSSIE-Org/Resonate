import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/features/stories/viewmodel/chapter_player_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class ChapterPlayerView extends ConsumerWidget {
  const ChapterPlayerView({
    super.key,
    required this.chapter,
    required this.progress,
  });

  final Chapter chapter;
  final double progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(chapterPlayerProvider(chapter.chapterId));
    final notifier = ref.read(
      chapterPlayerProvider(chapter.chapterId).notifier,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              chapter.tintColor.withValues(alpha: progress < 0.75 ? 0.8 : 1),
              chapter.tintColor.withValues(alpha: progress < 0.75 ? 0.3 : 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: 30 - (progress * 100) < 20 ? 20 : 30 - (progress * 100),
              left: progress < 0.45 ? 100 + (progress * 100) : 30,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: progress > 0.65 ? 50 : 200 - (2 * (progress * 100)),
                width: progress > 0.65 ? 50 : 200 - (2 * (progress * 100)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(UiSizes.width_20),
                  child: Image.network(
                    chapter.coverImageUrl,
                    width: UiSizes.width_200,
                    height: UiSizes.width_200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: progress > 0.65 ? 25 : 250 - (2.5 * (progress * 100)),
              left: 100,
              right: 100,
              child: Text(
                chapter.title,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: UiSizes.size_26,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ||
                          (ThemeData.estimateBrightnessForColor(
                                    chapter.tintColor,
                                  ) ==
                                  Brightness.dark &&
                              progress > 0.75)
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ),
            // Progress bar + time labels
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: progress > 0.65 ? 70 : 300 - (3 * (progress * 100)),
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: UiSizes.width_10),
                child: Column(
                  children: [
                    Slider(
                      value: playerState.sliderProgress,
                      onChanged: notifier.onSliderChanged,
                      onChangeEnd: notifier.onSliderChangeEnd,
                      min: 0,
                      max:
                          notifier.chapterDuration.inMilliseconds.toDouble() +
                          1000,
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey.shade300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 100),
                          opacity: progress > 0.70 ? 0 : 1,
                          child: Text(
                            "${formatPlayDuration(playerState.sliderProgress.toInt())} ${AppLocalizations.of(context)!.lengthMinutes}",
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 100),
                          opacity: progress > 0.70 ? 0 : 1,
                          child: Text(
                            "${formatPlayDuration(chapter.playDuration)} ${AppLocalizations.of(context)!.lengthMinutes}",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Expanded play button
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: 350 - (3.3 * (progress * 100)) < 200
                  ? 200
                  : 350 - (3.3 * (progress * 100)),
              left: 175,
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: progress > 0.45 ? 0 : 1,
                child: _PlayButton(
                  isPlaying: playerState.isPlaying,
                  enabled: progress <= 0.45,
                  onPressed: notifier.togglePlayPause,
                ),
              ),
            ),
            // Collapsed play button
            Positioned(
              top: 20,
              left: 320,
              child: AnimatedOpacity(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 200),
                opacity: progress > 0.45 ? 1 : 0,
                child: _PlayButton(
                  isPlaying: playerState.isPlaying,
                  enabled: progress > 0.45,
                  onPressed: notifier.togglePlayPause,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.isPlaying,
    required this.enabled,
    required this.onPressed,
  });

  final bool isPlaying;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: UiSizes.size_35,
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: enabled ? onPressed : null,
      icon: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
