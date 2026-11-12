import 'dart:developer' show Timeline, TimelineTask;

import 'package:flutter/foundation.dart' show kProfileMode;

// Named Timeline spans, so a CPU trace attributes work to a subsystem
T trace<T>(String name, T Function() body) {
  if (!kProfileMode) return body();
  return Timeline.timeSync(name, body);
}

Future<T> traceAsync<T>(String name, Future<T> Function() body) async {
  if (!kProfileMode) return body();
  final task = TimelineTask()..start(name);
  try {
    return await body();
  } finally {
    task.finish();
  }
}
