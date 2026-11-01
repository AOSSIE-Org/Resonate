import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/firebase_providers.g.dart';

@Riverpod(keepAlive: true)
FirebaseMessaging firebaseMessaging(Ref ref) => FirebaseMessaging.instance;
