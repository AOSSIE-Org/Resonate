import 'package:appwrite/appwrite.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/appwrite_providers.g.dart';

@Riverpod(keepAlive: true)
Client appwriteClient(Ref ref) => AppwriteService.getClient();

@Riverpod(keepAlive: true)
Account appwriteAccount(Ref ref) {
  ref.watch(appwriteClientProvider);
  return AppwriteService.getAccount();
}

@Riverpod(keepAlive: true)
TablesDB appwriteTables(Ref ref) => AppwriteService.getTables();

@Riverpod(keepAlive: true)
Storage appwriteStorage(Ref ref) => AppwriteService.getStorage();

@Riverpod(keepAlive: true)
Realtime appwriteRealtime(Ref ref) => AppwriteService.getRealtime();

@Riverpod(keepAlive: true)
Functions appwriteFunctions(Ref ref) => AppwriteService.getFunctions();
