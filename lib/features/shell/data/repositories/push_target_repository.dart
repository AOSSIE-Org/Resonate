import 'package:appwrite/appwrite.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/shell/data/services/apns_token_service.dart';
import 'package:resonate/utils/dev_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/push_target_repository.g.dart';

const String _apnsTargetIdKey = 'apnsPushTargetId';

@Riverpod(keepAlive: true)
ApnsTokenService apnsTokenService(Ref ref) => ApnsTokenService();

@Riverpod(keepAlive: true)
PushTargetRepository pushTargetRepository(Ref ref) => PushTargetRepository(
  account: ref.watch(appwriteAccountProvider),
  apns: ref.watch(apnsTokenServiceProvider),
  storage: ref.watch(getStorageBoxProvider),
);

/// Keeps the signed-in user's APNs push target in step with the device token,
/// so `createPush({users: [uid]})` reaches an iOS device that is not running.
class PushTargetRepository {
  PushTargetRepository({
    required Account account,
    required ApnsTokenService apns,
    required GetStorage storage,
  }) : _account = account,
       _apns = apns,
       _storage = storage;

  final Account _account;
  final ApnsTokenService _apns;
  final GetStorage _storage;

  /// No-op off iOS, and whenever the token cannot be obtained.
  Future<void> register() async {
    final token = await _apns.token();
    if (token == null || token.isEmpty) return;

    final targetId = await _targetId();
    try {
      await _account.createPushTarget(targetId: targetId, identifier: token);
      log('[push] APNs target created');
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        try {
          await _account.updatePushTarget(
            targetId: targetId,
            identifier: token,
          );
          log('[push] APNs target updated');
        } catch (e) {
          log('[push] APNs target update failed: $e');
        }
        return;
      }
      log('[push] APNs target failed: ${e.message}');
    }
  }

  /// Dropped on sign-out so the next account on this device is not reached.
  Future<void> unregister() async {
    final targetId = _storage.read<String>(_apnsTargetIdKey);
    if (targetId == null) return;
    try {
      await _account.deletePushTarget(targetId: targetId);
    } catch (e) {
      log('[push] APNs target delete failed: $e');
    }
  }

  // Stable per install: Appwrite keys a target by id, so a fresh one each
  // launch would pile up dead targets on the account.
  Future<String> _targetId() async {
    final existing = _storage.read<String>(_apnsTargetIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final created = ID.unique();
    await _storage.write(_apnsTargetIdKey, created);
    return created;
  }
}
