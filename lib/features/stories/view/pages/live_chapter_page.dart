import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/view/widgets/audio_selector_dialog.dart';
import 'package:resonate/features/rooms/data/services/livekit_controller.dart';
import 'package:resonate/features/stories/model/live_chapter_attendees_model.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_attendee_block.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_header.dart';
import 'package:resonate/features/stories/data/services/live_chapter_coordinator.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class LiveChapterPage extends ConsumerWidget {
  const LiveChapterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveState = ref.watch(liveChapterProvider);
    final model = liveState.model;

    if (model == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isAdmin = model.authorUid == ref.read(currentUserProvider)?.uid;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: UiSizes.height_10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
              child: LiveChapterHeader(
                chapterName: model.chapterTitle,
                chapterDescription: model.chapterDescription,
              ),
            ),
            SizedBox(height: UiSizes.height_7),
            Expanded(child: _participants(context, ref, isAdmin)),
          ],
        ),
      ),
    );
  }

  Widget _participants(BuildContext context, WidgetRef ref, bool isAdmin) {
    final colorScheme = Theme.of(context).colorScheme;
    final model = ref.watch(liveChapterProvider).model!;
    final attendees = model.attendees?.users ?? const [];

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UiSizes.width_16),
            color: colorScheme.onSecondary.withValues(alpha: 0.15),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(UiSizes.width_16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.participants,
                  style: TextStyle(
                    fontSize: UiSizes.size_18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: UiSizes.height_10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: UiSizes.width_20,
                    mainAxisSpacing: UiSizes.height_5,
                    childAspectRatio: 2.5 / 3,
                  ),
                  itemCount: attendees.length + 1,
                  itemBuilder: (context, index) {
                    return LiveChapterAttendeeBlock(
                      user: index == 0
                          ? LiveChapterAttendee(
                              id: model.authorUid,
                              name: model.authorName,
                              profileImageUrl: model.authorProfileImageUrl,
                            )
                          : attendees[index - 1],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        _footer(context, ref, isAdmin),
      ],
    );
  }

  Widget _footer(BuildContext context, WidgetRef ref, bool isAdmin) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UiSizes.width_25),
          color: colorScheme.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _LeaveButton(isAdmin: isAdmin),
            if (isAdmin) ...[const _MicButton(), const _RecordButton()],
            FloatingActionButton(
              heroTag: null,
              onPressed: () => showAudioDeviceSelector(context),
              backgroundColor: colorScheme.secondary,
              child: const Icon(Icons.settings_voice),
            ),
          ],
        ),
      ),
    );
  }
}

// End-call / leave control.
class _LeaveButton extends ConsumerWidget {
  const _LeaveButton({required this.isAdmin});
  final bool isAdmin;

  Future<bool> _confirm(BuildContext context, String action) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.areYouSure),
        content: Text(l10n.toRoomAction(action)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton(
      onPressed: () async {
        final notifier = ref.read(liveChapterProvider.notifier);
        final router = GoRouter.of(context);
        final confirmed = await _confirm(
          context,
          isAdmin ? l10n.delete : l10n.leave,
        );
        if (!confirmed) return;

        if (isAdmin) {
          if (ref.read(liveKitControllerProvider).isRecording) {
            final lyrics = await notifier.endLiveChapter();
            // Replace (not push): the live chapter is ended/disconnected, so it
            // must leave the back stack — otherwise backing out of verify (via
            // the button OR hardware back) returns to the dead live screen.
            router.pushReplacement(
              RoutePaths.verifyChapterDetails,
              extra: lyrics,
            );
          } else {
            customSnackbar(l10n.error, l10n.noRecordingError, LogType.error);
          }
        } else {
          await notifier.leaveRoom();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiSizes.width_20),
        ),
      ),
      child: Icon(Icons.call_end, size: UiSizes.size_24),
    );
  }
}

class _MicButton extends ConsumerWidget {
  const _MicButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMicOn = ref.watch(liveChapterProvider).isMicOn;
    final notifier = ref.read(liveChapterProvider.notifier);
    return FloatingActionButton(
      heroTag: null,
      onPressed: () => isMicOn ? notifier.turnOffMic() : notifier.turnOnMic(),
      // Mic on/off is a semantic green/red control.
      backgroundColor: isMicOn ? Colors.lightGreen : Colors.redAccent,
      child: Icon(isMicOn ? Icons.mic : Icons.mic_off, color: Colors.black),
    );
  }
}

class _RecordButton extends ConsumerWidget {
  const _RecordButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isRecording = ref.watch(liveKitControllerProvider).isRecording;
    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        if (isRecording) {
          customSnackbar(
            l10n.actionBlocked,
            l10n.cannotStopRecording,
            LogType.info,
          );
        } else {
          ref.read(liveChapterProvider.notifier).setRecording(true);
        }
      },
      backgroundColor: isRecording ? Colors.red : Colors.green,
      child: Icon(isRecording ? Icons.stop_circle : Icons.radio_button_checked),
    );
  }
}
