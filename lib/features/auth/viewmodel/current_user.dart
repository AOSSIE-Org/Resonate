import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/current_user.g.dart';


@Riverpod(keepAlive: true)
AuthUser? currentUser(Ref ref) =>
    ref.watch(authSessionProvider).value?.userOrNull;

@Riverpod(keepAlive: true)
AuthUser requireUser(Ref ref) =>
    ref.watch(currentUserProvider) ??
    (throw StateError('requireUser read with no authenticated user'));
