import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/room_failure.freezed.dart';

@freezed
sealed class RoomFailure with _$RoomFailure {
  const factory RoomFailure.notFound() = RoomFailureNotFound;
  const factory RoomFailure.network() = RoomFailureNetwork;
  const factory RoomFailure.liveKit(String message) = RoomFailureLiveKit;
  const factory RoomFailure.permissionDenied() = RoomFailurePermissionDenied;
  const factory RoomFailure.unknown(String message) = RoomFailureUnknown;
}
