import 'dart:async';

const Duration kSpeakingSampleInterval = Duration(milliseconds: 90);

class LeadingEdgeThrottle<T extends Object> {
  LeadingEdgeThrottle({required this.interval, required this.publish});

  final Duration interval;
  final void Function(T value) publish;

  Timer? _timer;
  T? _pending;

  T? get pending => _pending;

  void submit(T value) {
    _pending = value;
    if (_timer == null) _flush();
  }

  void _flush() {
    final value = _pending;
    _pending = null;
    if (value == null) {
      _timer = null;
      return;
    }
    publish(value);
    _timer = Timer(interval, _flush);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _pending = null;
  }
}
