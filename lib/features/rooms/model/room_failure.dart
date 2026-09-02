import 'package:appwrite/appwrite.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/core/errors/appwrite_error.dart';

part 'generated/room_failure.freezed.dart';

@freezed
sealed class RoomFailure with _$RoomFailure {
  const factory RoomFailure.notFound() = RoomFailureNotFound;
  const factory RoomFailure.network() = RoomFailureNetwork;
  const factory RoomFailure.liveKit(String message) = RoomFailureLiveKit;
  const factory RoomFailure.permissionDenied() = RoomFailurePermissionDenied;
  const factory RoomFailure.unknown(String message) = RoomFailureUnknown;

  static RoomFailure fromAppwrite(AppwriteException e) =>
      switch (classifyAppwriteError(e)) {
        AppwriteErrorKind.notFound => const RoomFailure.notFound(),
        AppwriteErrorKind.permissionDenied =>
          const RoomFailure.permissionDenied(),
        AppwriteErrorKind.unknown => RoomFailure.unknown(
          e.message ?? e.toString(),
        ),
      };
}
