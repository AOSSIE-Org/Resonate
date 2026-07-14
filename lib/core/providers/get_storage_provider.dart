import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/get_storage_provider.g.dart';

@riverpod
GetStorage getStorageBox(Ref ref) => GetStorage();
