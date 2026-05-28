import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';

part 'generated/rooms_state.freezed.dart';

@freezed
sealed class RoomsState with _$RoomsState {
  const RoomsState._();

  const factory RoomsState.ready({
    @Default(<AppwriteRoom>[]) List<AppwriteRoom> rooms,
    @Default(<AppwriteRoom>[]) List<AppwriteRoom> filteredRooms,
    @Default(false) bool isSearching,
    @Default(true) bool searchBarIsEmpty,
  }) = RoomsStateReady;

  List<AppwriteRoom> get visibleRooms => switch (this) {
    RoomsStateReady(:final filteredRooms, :final searchBarIsEmpty, :final rooms) =>
      searchBarIsEmpty ? rooms : filteredRooms,
  };
}
