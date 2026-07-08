import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:resonate/features/shell/view/widgets/no_connection_dialog.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/network_notifier.g.dart';


@Riverpod(keepAlive: true)
class Network extends _$Network {
  final _connectivity = InternetConnection();
  bool _isDialogOpen = false;

  @override
  bool build() {
    final sub = _connectivity.onStatusChange.listen((status) {
      if (status == InternetStatus.disconnected) {
        _showNoConnectionDialog();
      } else {
        _dismissNoConnectionDialog();
      }
    });
    ref.onDispose(sub.cancel);
    return false;
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
      builder: (_) => const NoConnectionDialog(),
    ).whenComplete(() => _isDialogOpen = false);
  }

  void _dismissNoConnectionDialog() {
    if (!_isDialogOpen) return;
    final nav = rootNavigatorKey.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
  }

  Future<void> tryAgain() async {
    state = true;

    var status = await _connectivity.internetStatus;

    log(status.toString());
    if (status == InternetStatus.connected) {
      _dismissNoConnectionDialog();
    }

    state = false;
  }
}
