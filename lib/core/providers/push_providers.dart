import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:resonate/core/providers/appwrite_providers.dart';

part 'generated/push_providers.g.dart';


@Riverpod(keepAlive: true)
Push appwritePush(Ref ref) => Push(ref.watch(appwriteClientProvider));
