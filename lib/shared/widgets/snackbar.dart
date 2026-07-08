import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';


OverlayEntry? _activeToast;
Timer? _toastTimer;

void _dismissToast() {
  _toastTimer?.cancel();
  _toastTimer = null;
  if (_activeToast?.mounted ?? false) _activeToast!.remove();
  _activeToast = null;
}

void customSnackbar(
  String title,
  String message,
  LogType messageType, {
  int snackbarDuration = 2,
}) {
  final color = switch (messageType) {
    LogType.success => Colors.green,
    LogType.warning => Colors.amber,
    LogType.error => Colors.red,
    LogType.info => Colors.blue,
  };

  try {
    final overlay = rootNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _dismissToast(); 
    final entry = OverlayEntry(
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        return Positioned(
          top: MediaQuery.of(context).padding.top + UiSizes.height_10,
          left: UiSizes.width_10,
          right: UiSizes.width_10,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            builder: (context, t, child) => Opacity(opacity: t, child: child),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: _dismissToast,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: UiSizes.width_16,
                    vertical: UiSizes.height_10,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color, width: UiSizes.width_1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontSize: UiSizes.size_20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: UiSizes.height_4),
                      Text(message, style: TextStyle(color: scheme.onSurface)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    _activeToast = entry;
    overlay.insert(entry);
    _toastTimer = Timer(Duration(seconds: snackbarDuration), _dismissToast);
  } catch (e) {
    log('customSnackbar failed: $e');
  }
}
