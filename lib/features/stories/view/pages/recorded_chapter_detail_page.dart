import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/stories/data/recording_playback.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';
import 'package:resonate/features/stories/model/transcript_line.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/features/stories/view/widgets/recorded_chapter_tile.dart';
import 'package:resonate/features/stories/viewmodel/recorded_chapters_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/utils/utils.dart';

class RecordedChapterDetailPage extends ConsumerStatefulWidget {
  const RecordedChapterDetailPage({super.key, required this.chapter});

  final RecordedChapter chapter;

  @override
  ConsumerState<RecordedChapterDetailPage> createState() =>
      _RecordedChapterDetailPageState();
}

class _RecordedChapterDetailPageState
    extends ConsumerState<RecordedChapterDetailPage> {
  RecordedChapter get chapter => widget.chapter;
  late final RecordingPlayback _playback;

  late final List<TranscriptLine> _lines;

  double? _scrubTo;

  @override
  void initState() {
    super.initState();
    _playback = ref.read(recordingPlaybackProvider.notifier);
    _lines = parseTranscript(chapter.transcript);
  }

  @override
  void dispose() {
    unawaited(_playback.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final description = chapter.description.trim();

    final playback = ref.watch(recordingPlaybackProvider);
    final isCurrent = playback.chapterId == chapter.id;
    final position = isCurrent ? playback.position : Duration.zero;
    final total = isCurrent && playback.duration > Duration.zero
        ? playback.duration
        : Duration(milliseconds: chapter.durationMs);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: Text(recordedChapterTitle(chapter, l10n))),
      body: ListView(
        padding: EdgeInsets.all(UiSizes.width_16),
        children: [
          _Section(
            child: _Player(
              isPlaying: isCurrent && playback.isPlaying,
              position: position,
              total: total,
              scrubTo: _scrubTo,
              onToggle: _toggle,
              onScrub: (value) => setState(() => _scrubTo = value),
              onScrubEnd: (value) {
                setState(() => _scrubTo = null);
                _playback.seek(Duration(milliseconds: value.round()));
              },
            ),
          ),
          SizedBox(height: UiSizes.height_16),
          _Section(
            child: Column(
              children: [
                _DetailRow(
                  label: l10n.recordedOn,
                  value: formatRecordedAt(chapter.recordedAt),
                ),
                _DetailRow(
                  label: l10n.recordingLength,
                  value: formatChapterLength(chapter.durationMs, l10n),
                ),
                _DetailRow(
                  label: l10n.audioFile,
                  value: fileNameOf(chapter.audioFilePath),
                ),
              ],
            ),
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: UiSizes.height_16),
            _Section(
              title: l10n.about,
              child: Text(
                description,
                style: TextStyle(
                  fontSize: UiSizes.size_16,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
          SizedBox(height: UiSizes.height_16),
          _Section(
            title: l10n.transcript,
            child: _Transcript(
              lines: _lines,
              position: isCurrent ? position : null,
              onSeek: (at) => _playback.seek(at),
            ),
          ),
          SizedBox(height: UiSizes.height_30),
          ElevatedButton.icon(
            onPressed: _confirmDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            label: Text(l10n.deleteRecording),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              minimumSize: Size.fromHeight(UiSizes.height_50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiSizes.width_16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggle() async {
    final l10n = AppLocalizations.of(context)!;
    if (ref.read(liveKitControllerProvider).isConnected) {
      customSnackbar(
        l10n.actionBlocked,
        l10n.playbackBlockedInSession,
        LogType.info,
      );
      return;
    }
    await _playback.toggle(chapter);
  }

  void _confirmDelete() {
    final l10n = AppLocalizations.of(context)!;
    AppUtils.showDialog(
      context: context,
      title: l10n.areYouSure,
      middleText: l10n.deleteRecordingMessage,
      firstBtnText: l10n.deleteRecording,
      onFirstBtnPressed: () {
        Navigator.of(context).pop();
        _delete();
      },
      onSecondBtnPressed: () => Navigator.of(context).pop(),
    );
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final title = recordedChapterTitle(chapter, l10n);
    final notifier = ref.read(recordedChaptersProvider.notifier);
    await _playback.stop();
    if (!mounted) return;
    Navigator.of(context).pop();
    try {
      await notifier.delete(chapter.id);
      customSnackbar(l10n.recordingDeleted, title, LogType.success);
    } catch (e) {
      customSnackbar(l10n.deleteRecordingFailed, e.toString(), LogType.error);
    }
  }
}

class _Player extends StatelessWidget {
  const _Player({
    required this.isPlaying,
    required this.position,
    required this.total,
    required this.scrubTo,
    required this.onToggle,
    required this.onScrub,
    required this.onScrubEnd,
  });

  final bool isPlaying;
  final Duration position;
  final Duration total;
  final double? scrubTo;
  final VoidCallback onToggle;
  final ValueChanged<double> onScrub;
  final ValueChanged<double> onScrubEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final max = total.inMilliseconds.toDouble();
    final value = (scrubTo ?? position.inMilliseconds.toDouble()).clamp(0, max);

    return Column(
      children: [
        if (max > 0)
          Slider(
            value: value.toDouble(),
            max: max,
            onChanged: onScrub,
            onChangeEnd: onScrubEnd,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatPlayDuration(value.round()),
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            IconButton.filled(
              onPressed: onToggle,
              iconSize: UiSizes.size_32,
              tooltip: isPlaying ? l10n.pauseRecording : l10n.playRecording,
              icon: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
            ),
            Text(
              formatPlayDuration(total.inMilliseconds),
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(UiSizes.width_16),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(UiSizes.width_16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: UiSizes.size_17,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: UiSizes.height_10),
          ],
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: UiSizes.height_5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: UiSizes.width_100,
            child: Text(
              label,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Transcript extends StatelessWidget {
  const _Transcript({
    required this.lines,
    required this.position,
    required this.onSeek,
  });

  final List<TranscriptLine> lines;
  // Null while this recording is not the one loaded in the player.
  final Duration? position;
  final ValueChanged<Duration> onSeek;
  
  int get _activeIndex {
    final at = position;
    if (at == null) return -1;
    var active = -1;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].at > at) break;
      active = i;
    }
    return active;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (lines.isEmpty) {
      return Text(
        l10n.noTranscript,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      );
    }

    final active = _activeIndex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, line) in lines.indexed)
          InkWell(
            onTap: () => onSeek(line.at),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: UiSizes.height_5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: UiSizes.width_56,
                    child: Text(
                      formatPlayDuration(line.at.inMilliseconds),
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: UiSizes.size_14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      line.text,
                      style: TextStyle(
                        fontSize: UiSizes.size_16,
                        color: index == active
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: index == active
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
