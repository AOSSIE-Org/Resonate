import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/rooms/data/repositories/rooms_repository.dart';
import 'package:resonate/features/rooms/view/widgets/live_room_tile.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/utils/colors.dart';

class TabViewController extends GetxController {
  final RxInt _selectedIndex = 0.obs;
  int getIndex() => _selectedIndex.value;
  dynamic setIndex(index) => _selectedIndex.value = index;

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void onInit() {
    super.onInit();
    initAppLinks();
  }

  void onDispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initAppLinks() async {
    _appLinks = AppLinks();

    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      log('getInitialAppLink: $appLink');
      openAppLink(appLink);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      log('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) async {
    try {
      final roomId = uri.pathSegments.last;
      final authState = await rootContainer.read(authProvider.future);
      if (!authState.hasSession) return;
      final userUid = authState.userOrNull?.uid;
      if (userUid == null) return;

      final room = await rootContainer
          .read(roomsRepositoryProvider)
          .getRoomById(roomId, userUid);
      if (room == null) return;

      final ctx = rootNavigatorKey.currentContext;
      if (ctx == null) return;
      await showDialog<void>(
        context: ctx,
        builder: (dialogCtx) => AlertDialog(
          backgroundColor: AppColor.bgBlackColor,
          title: Text(
            AppLocalizations.of(dialogCtx)!.joinRoom,
            style: const TextStyle(color: Colors.amber, fontSize: 25),
          ),
          content: SingleChildScrollView(
            child: CustomLiveRoomTile(appwriteRoom: room),
          ),
        ),
      );
    } catch (e) {
      log('Open App Link ERROR : ${e.toString()}');
    }
  }
}
