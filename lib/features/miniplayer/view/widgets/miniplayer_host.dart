import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/friends/data/services/friend_call_coordinator.dart';
import 'package:resonate/features/miniplayer/data/services/pip_controller.dart';
import 'package:resonate/features/miniplayer/data/session_presented.dart';
import 'package:resonate/features/miniplayer/model/miniplayer_session.dart';
import 'package:resonate/features/miniplayer/view/widgets/session_miniplayer.dart';
import 'package:resonate/features/miniplayer/viewmodel/miniplayer_notifier.dart';
import 'package:resonate/features/rooms/view/pages/room_page.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';


class MiniplayerHost extends ConsumerStatefulWidget {
  const MiniplayerHost({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MiniplayerHost> createState() => _MiniplayerHostState();
}

class _MiniplayerHostState extends ConsumerState<MiniplayerHost>
    with WidgetsBindingObserver {
  bool _screenSeen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.inactive) return;
    if (ref.read(miniplayerProvider) == null) return;
    ref.read(pipModeProvider.notifier).enterNow();
  }

  BuildContext? get _navigatorContext =>
      rootNavigatorKey.currentState?.overlay?.context;

  void _restore(MiniplayerSession session) {
    final room = session.room;
    if (room == null) {
      ref.read(routerProvider).push(RoutePaths.friendCallScreen);
      return;
    }
    final navigator = _navigatorContext;
    if (navigator == null) return;
    openRoomSheet(navigator, room);
  }

  void _leave(MiniplayerSession session) {
    final room = session.room;
    if (room == null) {
      ref.read(friendCallCoordinatorProvider.notifier).endCall();
      return;
    }
    final navigator = _navigatorContext;
    if (navigator == null) return;
    openRoomSheet(navigator, room, confirmLeave: true);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(miniplayerProvider.select((s) => s != null), (_, hasSession) {
      ref.read(pipModeProvider.notifier).setSessionActive(active: hasSession);
      // A new session has to earn its miniplayer again.
      if (!hasSession) _screenSeen = false;
    });

    ref.listen(sessionPresentedProvider, (_, presented) {
      if (presented) _screenSeen = true;
    });

    final session = ref.watch(miniplayerProvider);
    final inPip = session != null && ref.watch(pipModeProvider);
    final presented = ref.watch(sessionPresentedProvider);
    final showBar = session != null && !presented && _screenSeen && !inPip;

    return Stack(
      fit: StackFit.expand,
      children: [
        Offstage(offstage: inPip, child: widget.child),
        if (inPip) SessionMiniplayer.pip(session: session),
        if (showBar)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: UiSizes.height_110),
                child: SessionMiniplayer(
                  session: session,
                  onRestore: () => _restore(session),
                  onToggleMic: () =>
                      ref.read(miniplayerProvider.notifier).toggleMic(),
                  onLeave: () => _leave(session),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
