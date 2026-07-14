import 'package:appwrite/appwrite.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/appwrite_providers.g.dart';


@Riverpod(keepAlive: true)
Client appwriteClient(Ref ref) => Client()
    .setEndpoint(appwriteEndpoint)
    .setProject(appwriteProjectId)
    .setSelfSigned(status: true);

@Riverpod(keepAlive: true)
Account appwriteAccount(Ref ref) => Account(ref.watch(appwriteClientProvider));

@Riverpod(keepAlive: true)
TablesDB appwriteTables(Ref ref) => TablesDB(ref.watch(appwriteClientProvider));

@Riverpod(keepAlive: true)
Storage appwriteStorage(Ref ref) => Storage(ref.watch(appwriteClientProvider));

@Riverpod(keepAlive: true)
Realtime appwriteRealtime(Ref ref) =>
    Realtime(ref.watch(appwriteClientProvider));

@Riverpod(keepAlive: true)
Functions appwriteFunctions(Ref ref) =>
    Functions(ref.watch(appwriteClientProvider));
