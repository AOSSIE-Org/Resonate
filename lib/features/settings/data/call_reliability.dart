import 'package:resonate/core/providers/push_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/call_reliability.g.dart';


@riverpod
Future<bool> callDeliveryDegraded(Ref ref) async {
  final status = await ref.watch(appwritePushProvider).backgroundStatus();
  // Null off Android, where there is nothing to ask for.
  if (status == null) return false;
  return !status.ignoringBatteryOptimizations;
}

@riverpod
Future<bool> Function() requestCallReliability(Ref ref) {
  final push = ref.watch(appwritePushProvider);
  return () async {
    final asked = await push.requestIgnoreBatteryOptimizations();
    ref.invalidate(callDeliveryDegradedProvider);
    return asked;
  };
}
