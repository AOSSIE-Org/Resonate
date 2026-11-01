import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/livekit_state.freezed.dart';

@freezed
abstract class LiveKitState with _$LiveKitState {
  const factory LiveKitState({
    @Default(false) bool isConnected,
    @Default(false) bool isRecording,
    @Default(false) bool hasSession,
  }) = _LiveKitState;
}
