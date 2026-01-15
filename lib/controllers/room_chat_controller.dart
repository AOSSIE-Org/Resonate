import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/models/appwrite_upcomming_room.dart';
import 'package:resonate/models/message.dart';
import 'package:resonate/models/reply_to.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';

class RoomChatController extends GetxController {
  RoomChatController({this.appwriteRoom, this.appwriteUpcommingRoom});
  AuthStateController auth = Get.find<AuthStateController>();
  RxList<Message> messages = <Message>[].obs;
  final AppwriteRoom? appwriteRoom;
  final Functions functions = AppwriteService.getFunctions();
  final AppwriteUpcommingRoom? appwriteUpcommingRoom;
  final Realtime realtime = AppwriteService.getRealtime();
  final Databases databases = AppwriteService.getDatabases();
  late final RealtimeSubscription? subscription;
  Rx<ReplyTo?> replyingTo = Rxn<ReplyTo>();
  final NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    ),
  );

  @override
  void onInit() async {
    super.onInit();
    subscribeToMessages();
    log(appwriteRoom.toString());
    log(appwriteUpcommingRoom.toString());
  }

  Future<void> loadMessages() async {
    messages.clear();
    var queries = [
      Query.equal('roomId', appwriteRoom?.id ?? appwriteUpcommingRoom!.id),
      Query.orderAsc('index'),
      Query.limit(100),
    ];
    ReplyTo? replyTo;
    DocumentList messagesList = await databases.listDocuments(
      databaseId: masterDatabaseId,
      collectionId: chatMessagesCollectionId,
      queries: queries,
    );
    for (Document message in messagesList.documents) {
      try {
        Document replyToDoc = await databases.getDocument(
          databaseId: masterDatabaseId,
          collectionId: chatMessageReplyCollectionId,
          documentId: message.$id,
        );
        replyTo = ReplyTo.fromJson(replyToDoc.data);
      } catch (e) {
        if (e is AppwriteException && e.code == 404) {
          // If replyTo document not found, set it to null
          replyTo = null;
        } else {
          rethrow; // Rethrow if it's a different error
        }
      }
      messages.add(
        Message.fromJson(message.data..addAll({'replyTo': replyTo?.toJson()})),
      );
    }
    messages.sort((a, b) => a.index.compareTo(b.index));
    log(messages.toString());
  }

  Future<void> sendMessage(String content) async {
    try {
      final String messageId = ID.unique();

      final int newIndex = messages.isNotEmpty ? messages.last.index + 1 : 0;
      final Message message = Message(
        roomId: appwriteRoom?.id ?? appwriteUpcommingRoom!.id,
        messageId: messageId,
        creatorId: auth.appwriteUser.$id,
        creatorUsername: auth.userName!,
        creatorName: auth.displayName!,
        hasValidTag: false,
        index: newIndex,
        creatorImgUrl: auth.profileImageUrl!,
        isEdited: false,
        content: content,
        creationDateTime: DateTime.now(),
      );

      await databases.createDocument(
        databaseId: masterDatabaseId,
        collectionId: chatMessagesCollectionId,
        documentId: messageId,
        data: message.toJsonForUpload(),
      );

      if (replyingTo.value != null) {
        await databases.createDocument(
          databaseId: masterDatabaseId,
          collectionId: chatMessageReplyCollectionId,
          documentId: messageId,
          data: replyingTo.value!.toJson(),
        );
      }
      if (appwriteUpcommingRoom != null) {
        log('Sending notification for sent message');
        var body = json.encode({
          'roomId': appwriteUpcommingRoom?.id,
          'payload': {
            'title': 'Message received in ${appwriteUpcommingRoom?.name}',
            'body': '${message.creatorName} said: ${message.content}',
          },
        });
        var results = await functions.createExecution(
          functionId: sendMessageNotificationFunctionID,
          body: body.toString(),
        );
        log(results.status.name);
      }
      message.replyTo = replyingTo.value;

      // messages.add(message);
      replyingTo.value = null;
    } catch (e) {
      log('Error sending message: $e');
      return;
    }
    log('Message sed\nt');
  }

  Future<void> editMessage(String messageId, String newContent) async {
    Message updatedMessage = messages.firstWhere(
      (msg) => msg.messageId == messageId,
    );
    updatedMessage = updatedMessage.copyWith(
      content: newContent,
      isEdited: true,
    );

    try {
      await databases.updateDocument(
        databaseId: masterDatabaseId,
        collectionId: chatMessagesCollectionId,
        documentId: messageId,
        data: updatedMessage.toJsonForUpload(),
      );
      if (appwriteUpcommingRoom != null) {
        log('Sending notification for edited message');
        var body = json.encode({
          'roomId': appwriteUpcommingRoom?.id,
          'payload': {
            'title': 'Message Edited in ${appwriteUpcommingRoom?.name}',
            'body':
                '${updatedMessage.creatorName} updated his message: ${updatedMessage.content}',
          },
        });
        var results = await functions.createExecution(
          functionId: sendMessageNotificationFunctionID,
          body: body.toString(),
        );
        log(results.status.name);
      }
      log('Message edited successfully');
    } catch (e) {
      log('Error editing message: $e');
      return;
    }
  }

  void setReplyingTo(Message message) {
    replyingTo.value = ReplyTo(
      messageId: message.messageId,
      creatorUsername: message.creatorUsername,
      content: message.content,
      creatorImgUrl: message.creatorImgUrl,
      index: messages.indexOf(message),
    );
  }

  void clearReplyingTo() {
    replyingTo.value = null;
  }

  void subscribeToMessages() {
    try {
      String channel =
          'databases.$masterDatabaseId.collections.$chatMessagesCollectionId.documents';
      subscription = realtime.subscribe([channel]);
      subscription?.stream.listen((data) async {
        if (data.payload.isNotEmpty) {
          String roomId = data.payload['roomId'];
          if (roomId == (appwriteRoom?.id ?? appwriteUpcommingRoom!.id)) {
            String docId = data.payload['\$id'];
            String action = data.events.first.substring(
              channel.length + 1 + docId.length + 1,
            );
            log(action);
            if (action == 'create') {
              Message newMessage = Message.fromJson(data.payload);
              ReplyTo? replyTo;
              try {
                Document replyToDoc = await databases.getDocument(
                  databaseId: masterDatabaseId,
                  collectionId: chatMessageReplyCollectionId,
                  documentId: newMessage.messageId,
                );
                replyTo = ReplyTo.fromJson(replyToDoc.data);
              } catch (e) {
                if (e is AppwriteException && e.code == 404) {
                  // If replyTo document not found, set it to null
                  replyTo = null;
                } else {
                  log("Error fetching replyTo document: ${e.toString()}");
                  rethrow; // Rethrow if it's a different error
                }
              }
              newMessage.replyTo = replyTo;

              messages.add(newMessage);
              if (appwriteRoom != null) {
                auth.flutterLocalNotificationsPlugin.show(
                  0,
                  'Message received in ${appwriteRoom?.name ?? appwriteUpcommingRoom!.name}',
                  '${newMessage.creatorName} said: ${newMessage.content}',
                  notificationDetails,
                );
              }
            }
            if (action == 'update') {
              Message updatedMessage = Message.fromJson(data.payload);
              var index = messages.indexWhere(
                (msg) => msg.messageId == updatedMessage.messageId,
              );
              messages[index] = messages[index].copyWith(
                content: updatedMessage.content,
                isEdited: updatedMessage.isEdited,
              );
              if (appwriteRoom != null) {
                auth.flutterLocalNotificationsPlugin.show(
                  0,
                  'Message Edited in ${appwriteRoom?.name ?? appwriteUpcommingRoom!.name}',
                  '${updatedMessage.creatorName} updated his message: ${updatedMessage.content}',
                  notificationDetails,
                );
              }
            }
          }
        }
      });
    } catch (e) {
      log('Error subscribing to messages: $e');
    }
  }
}
