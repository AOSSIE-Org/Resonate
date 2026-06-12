import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/views/widgets/no_connection_dialog.dart';

class NetworkController extends GetxController {
  final _connectivity = InternetConnection();
  StreamSubscription<InternetStatus>? _statusSub;
  bool _isDialogOpen = false;

  Rx<bool> isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    _statusSub = _connectivity.onStatusChange.listen((status) {
      if (status == InternetStatus.disconnected) {
        _showNoConnectionDialog();
      } else {
        _dismissNoConnectionDialog();
      }
    });
  }

  @override
  void onClose() {
    _statusSub?.cancel();
    super.onClose();
  }

  void _showNoConnectionDialog() {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null || _isDialogOpen) return;
    _isDialogOpen = true;
    showDialog(
      context: ctx,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => NoConnectionDialog(),
    ).whenComplete(() => _isDialogOpen = false);
  }

  void _dismissNoConnectionDialog() {
    if (!_isDialogOpen) return;
    final nav = rootNavigatorKey.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
  }

  void tryAgain() async {
    isLoading.value = true;

    var status = await _connectivity.internetStatus;

    log(status.toString());
    if (status == InternetStatus.connected) {
      _dismissNoConnectionDialog();
    }

    isLoading.value = false;
  }
}
