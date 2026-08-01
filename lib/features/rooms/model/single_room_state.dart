import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/rooms/model/participant.dart';

part 'generated/single_room_state.freezed.dart';

@freezed
abstract class SingleRoomState with _$SingleRoomState {
  const factory SingleRoomState({
    required Participant me,
    @Default(<Participant>[]) List<Participant> participants,
    @Default(false) bool wasKicked,
  }) = _SingleRoomState;
}
