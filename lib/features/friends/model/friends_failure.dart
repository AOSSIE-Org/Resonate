import 'package:appwrite/appwrite.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/core/errors/appwrite_error.dart';

part 'generated/friends_failure.freezed.dart';

@freezed
sealed class FriendsFailure with _$FriendsFailure {
  const factory FriendsFailure.notFound() = FriendsFailureNotFound;
  const factory FriendsFailure.network() = FriendsFailureNetwork;
  const factory FriendsFailure.permissionDenied() =
      FriendsFailurePermissionDenied;
  const factory FriendsFailure.unknown(String message) = FriendsFailureUnknown;

  static FriendsFailure fromAppwrite(AppwriteException e) =>
      switch (classifyAppwriteError(e)) {
        AppwriteErrorKind.notFound => const FriendsFailure.notFound(),
        AppwriteErrorKind.permissionDenied =>
          const FriendsFailure.permissionDenied(),
        AppwriteErrorKind.unknown => FriendsFailure.unknown(
          e.message ?? e.toString(),
        ),
      };
}
