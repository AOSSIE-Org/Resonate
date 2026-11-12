import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/shared/widgets/session_control_bar.dart';
import 'package:resonate/features/live_audio/view/widgets/audio_selector_dialog.dart';
import 'package:resonate/features/friends/view/widgets/call_user_info_row.dart';
import 'package:resonate/features/friends/view/widgets/rating_sheet.dart';
import 'package:resonate/features/friends/data/pair_chat_session.dart';
import 'package:resonate/shared/widgets/session_app_bar.dart';
import 'package:resonate/shared/widgets/session_header.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/rooms/model/user_report_model.dart';
import 'package:resonate/features/rooms/view/widgets/report_widget.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

class PairChatPage extends ConsumerStatefulWidget {
  const PairChatPage({super.key});

  @override
  ConsumerState<PairChatPage> createState() => _PairChatPageState();
}

class _PairChatPageState extends ConsumerState<PairChatPage> {
  late final PairChat _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(pairChatProvider.notifier);
    // When the partner ended the pair while we were still joining
    if (ref.read(pairChatProvider).ended) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onChatEnded());
    }
  }

  @override
  void dispose() {
    // Leaving ends the chat; endChat() self-guards, so don't read ref in dispose.
    _notifier.endChat();
    super.dispose();
  }

  Future<void> _reportPartner(BuildContext context, WidgetRef ref) async {
    final chatState = ref.read(pairChatProvider);
    final uid = chatState.pairUid;
    if (uid == null) return;
    final l10n = AppLocalizations.of(context)!;

    final draft = await showDialog<ReportDraft>(
      context: context,
      builder: (_) => ReportWidget(
        participantName: chatState.pairUsername ?? '',
        participantId: uid,
      ),
    );
    if (draft == null) return;

    final filed = await _notifier.reportPartner(draft);
    customSnackbar(
      filed ? l10n.success : l10n.error,
      filed ? l10n.reportSubmitted : l10n.reportFailed,
      filed ? LogType.success : LogType.error,
    );
  }

  Future<void> _onChatEnded() async {
    if (!mounted) return;
    final router = GoRouter.of(context);
    await showModalBottomSheet(
      context: context,
      builder: (_) => const RatingSheet(),
    );
    router.go(RoutePaths.tabview);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(pairChatProvider);
    final placeholderUrl = ref.watch(userProfileImagePlaceholderUrlProvider);

    ref.listen(pairChatProvider.select((s) => s.ended), (prev, ended) {
      if (ended && prev != true) _onChatEnded();
    });

    // End the chat when the LiveKit room drops.
    ref.listen(liveKitControllerProvider.select((s) => s.isConnected), (prev, connected) {
      if (prev == true && !connected) {
        ref.read(pairChatProvider.notifier).endChat();
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SessionAppBar(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: UiSizes.height_10,
                  horizontal: UiSizes.width_20,
                ),
                child: Column(
                  children: [
                    SessionHeader(
                      title: AppLocalizations.of(context)!.title,
                      description: AppLocalizations.of(
                        context,
                      )!.roomDescription,
                    ),
                    SizedBox(height: UiSizes.height_24_6),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CallUserInfoRow(
                          imageUrl: chatState.isAnonymous
                              ? placeholderUrl
                              : ref.read(requireUserProvider).profileImageUrl ?? '',
                          userName: chatState.isAnonymous
                              ? AppLocalizations.of(context)!.user1
                              : ref.read(requireUserProvider).userName ?? '',
                        ),
                        SizedBox(height: UiSizes.height_20),
                        CallUserInfoRow(
                          imageUrl: chatState.isAnonymous
                              ? placeholderUrl
                              : chatState.pairProfileImageUrl ?? placeholderUrl,
                          userName: chatState.isAnonymous
                              ? AppLocalizations.of(context)!.user2
                              : chatState.pairUsername ?? '',
                        ),
                        if (!chatState.isAnonymous &&
                            chatState.pairUid != null)
                          TextButton.icon(
                            onPressed: () => _reportPartner(context, ref),
                            icon: Icon(
                              Icons.flag_outlined,
                              size: UiSizes.size_16,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            label: Text(
                              AppLocalizations.of(context)!.reportParticipant,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: UiSizes.height_24_6),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: SessionControlBar(
                  controls: [
                    SessionControl(
                      SessionControlKind.leave,
                      onTap: () => _notifier.endChat(),
                    ),
                    SessionControl(
                      SessionControlKind.mic,
                      active: chatState.isMicOn,
                      onTap: _notifier.toggleMic,
                    ),
                    SessionControl(
                      SessionControlKind.audioDevice,
                      onTap: () => showAudioDeviceSelector(context),
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
