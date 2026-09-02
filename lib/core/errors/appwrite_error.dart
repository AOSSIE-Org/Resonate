import 'package:appwrite/appwrite.dart';

enum AppwriteErrorKind { notFound, permissionDenied, unknown }

AppwriteErrorKind classifyAppwriteError(AppwriteException e) =>
    switch (e.code) {
      404 => AppwriteErrorKind.notFound,
      401 || 403 => AppwriteErrorKind.permissionDenied,
      _ => AppwriteErrorKind.unknown,
    };
