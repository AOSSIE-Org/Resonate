import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
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
      final roomId = uri.pathSegments.last;
      final authState = await ref.read(authProvider.future);
      if (!authState.hasSession) return;
      final userUid = authState.userOrNull?.uid;
      if (userUid == null) return;

      final room = await ref
          .read(roomsRepositoryProvider)
          .getRoomById(roomId, userUid);
      if (room == null) return;

      _showJoinRoomDialog(room);
    } catch (e) {
      log('Open App Link ERROR : ${e.toString()}');
    }
  }

  void _showJoinRoomDialog(AppwriteRoom room) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return;
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
