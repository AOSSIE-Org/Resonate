import 'dart:async';
import 'package:resonate/utils/dev_log.dart';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:resonate/features/rooms/data/services/room_launcher.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/view/widgets/live_room_tile.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/tabview_notifier.g.dart';

@Riverpod(keepAlive: true)
class TabView extends _$TabView {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  int build() {
    _initAppLinks();
    ref.onDispose(() => _linkSubscription?.cancel());
    return 0;
  }

  void setIndex(int index) => state = index;

  Future<void> _initAppLinks() async {
    final appLinks = AppLinks();

    final appLink = await appLinks.getInitialLink();
    if (appLink != null) {
      log('getInitialAppLink: $appLink');
      _openAppLink(appLink);
    }

    _linkSubscription = appLinks.uriLinkStream.listen((uri) {
      log('onAppLink: $uri');
      _openAppLink(uri);
    });
  }

  Future<void> _openAppLink(Uri uri) async {
    try {
      final segments = uri.pathSegments;
      if (segments.length < 2 || segments.first != 'room') return;
      final roomId = segments[1];
      if (roomId.isEmpty) return;

      // Rooms owns resolving this, including the signed-out case.
      final room = await ref.read(roomLauncherProvider).findRoomById(roomId);
      if (room == null) return;

      _showJoinRoomDialog(room);
    } catch (e) {
      log('Open App Link ERROR : ${e.toString()}');
    }
  }

  static const _maxDialogAttempts = 60;

  void _showJoinRoomDialog(AppwriteRoom room, {int attempt = 0}) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) {
      if (attempt >= _maxDialogAttempts) {
        log('Open App Link: no navigator after $attempt frames, dropping');
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showJoinRoomDialog(room, attempt: attempt + 1),
      );
      return;
    }
    showDialog<void>(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColor.bgBlackColor,
        title: Text(
          AppLocalizations.of(dialogCtx)!.joinRoom,
          style: TextStyle(color: Colors.amber, fontSize: UiSizes.size_25),
        ),
        content: SingleChildScrollView(
          child: CustomLiveRoomTile(appwriteRoom: room),
        ),
      ),
    );
  }
}
