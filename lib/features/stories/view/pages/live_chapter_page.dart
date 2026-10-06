import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/live_audio/view/widgets/audio_selector_dialog.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/stories/model/live_chapter_attendees_model.dart';
import 'package:resonate/features/stories/model/live_chapter_model.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_attendee_block.dart';
import 'package:resonate/features/stories/data/services/live_chapter_coordinator.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/shared/widgets/session_app_bar.dart';
import 'package:resonate/shared/widgets/session_control_bar.dart';
import 'package:resonate/shared/widgets/session_exit_dialog.dart';
import 'package:resonate/shared/widgets/session_header.dart';
import 'package:resonate/shared/widgets/session_stage.dart';
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

    final isAdmin = model.authorUid == ref.watch(currentUserProvider)?.uid;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SessionAppBar(
            icon: Icons.arrow_back,
            onPressed: () => leaveLiveChapter(context, ref, isAdmin: isAdmin),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
            child: SessionHeader(
              title: model.chapterTitle,
              description: model.chapterDescription,
            ),
          ),
          SizedBox(height: UiSizes.height_16),
          Expanded(
            child: _Stage(
              model: model,
              isAdmin: isAdmin,
              authorMicOn: isAdmin ? liveState.isMicOn : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({
    required this.model,
    required this.isAdmin,
    required this.authorMicOn,
  });

  final LiveChapterModel model;
  final bool isAdmin;
  final bool? authorMicOn;

  @override
  Widget build(BuildContext context) {
    final author = LiveChapterAttendee(
      id: model.authorUid,
      name: model.authorName,
      profileImageUrl: model.authorProfileImageUrl,
    );
    final listeners = (model.attendees?.users ?? const <LiveChapterAttendee>[])
        .where((user) => user.id != model.authorUid)
        .toList();

    return SessionStage(
      featured: [
        LiveChapterAttendeeBlock(
          user: author,
          featured: true,
          isMicOn: authorMicOn,
        ),
      ],
      tiles: [
        for (final listener in listeners)
          LiveChapterAttendeeBlock(user: listener),
      ],
      emptyState: SessionStageEmpty(
        message: AppLocalizations.of(context)!.noListenersYet,
      ),
      controls: _Footer(isAdmin: isAdmin),
    );
  }
}

class _Footer extends ConsumerWidget {
  const _Footer({required this.isAdmin});

  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(liveChapterProvider.notifier);
    final isMicOn = ref.watch(liveChapterProvider).isMicOn;
    final isRecording = ref.watch(liveKitControllerProvider).isRecording;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SessionControlBar(
        controls: [
          SessionControl(
            SessionControlKind.leave,
            onTap: () => leaveLiveChapter(context, ref, isAdmin: isAdmin),
          ),
          // Only the author speaks, and only the author records.
          if (isAdmin) ...[
            SessionControl(
              SessionControlKind.mic,
              active: isMicOn,
              onTap: () =>
                  isMicOn ? notifier.turnOffMic() : notifier.turnOnMic(),
            ),
            SessionControl(
              SessionControlKind.record,
              active: isRecording,
              onTap: () => isRecording
                  ? customSnackbar(
                      l10n.actionBlocked,
                      l10n.cannotStopRecording,
                      LogType.info,
                    )
                  : notifier.setRecording(true),
            ),
          ],
          SessionControl(
            SessionControlKind.audioDevice,
            onTap: () => showAudioDeviceSelector(context),
          ),
        ],
      ),
    );
  }
}

Future<void> leaveLiveChapter(
  BuildContext context,
  WidgetRef ref, {
  required bool isAdmin,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final notifier = ref.read(liveChapterProvider.notifier);
  final isRecording = ref.read(liveKitControllerProvider).isRecording;
  final router = GoRouter.of(context);

  final confirmed = await confirmSessionExit(
    context,
    isAdmin ? l10n.delete : l10n.leave,
  );
  if (!confirmed) return;

  if (!isAdmin) {
    await notifier.leaveRoom();
    return;
  }
  if (!isRecording) {
    customSnackbar(l10n.error, l10n.noRecordingError, LogType.error);
    return;
  }
  await notifier.endLiveChapter();
  router.pushReplacement(RoutePaths.verifyChapterDetails);
}
