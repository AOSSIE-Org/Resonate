import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/session_presented.g.dart';

// True while a session's full screen is on top
@Riverpod(keepAlive: true)
class SessionPresented extends _$SessionPresented {
  int _depth = 0;

  @override
  bool build() => false;

  void enter() {
    _depth++;
    if (ref.mounted) state = true;
  }

  void exit() {
    if (_depth > 0) _depth--;
    if (ref.mounted) state = _depth > 0;
  }
}
