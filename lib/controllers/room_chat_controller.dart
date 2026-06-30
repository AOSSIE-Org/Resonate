import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:get/get.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/models/appwrite_upcomming_room.dart';
import 'package:resonate/models/message.dart';
import 'package:resonate/models/reply_to.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';

class RoomChatController extends GetxController {
  RoomChatController({this.appwriteRoom, this.appwriteUpcommingRoom});

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  RxList<Message> messages = <Message>[].obs;
  final AppwriteRoom? appwriteRoom;
  final Functions functions = AppwriteService.getFunctions();
  final AppwriteUpcommingRoom? appwriteUpcommingRoom;
  final Realtime realtime = AppwriteService.getRealtime();
  final TablesDB tablesDB = AppwriteService.getTables();
  late final RealtimeSubscription? subscription;
  Rx<ReplyTo?> replyingTo = Rxn<ReplyTo>();
  RxBool isMuted = false.obs;
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

  bool get isAdmin => appwriteRoom?.isUserAdmin ?? false;
  String get _roomId => appwriteRoom?.id ?? appwriteUpcommingRoom!.id;

  @override
  void onInit() async {
    super.onInit();
    subscribeToMessages();
    await checkMuteStatus();
    log(appwriteRoom.toString());
    log(appwriteUpcommingRoom.toString());
  }

  Future<void> checkMuteStatus() async {
    try {
      if (chatFunctionId.isNotEmpty) {
        var response = await functions.createExecution(
          functionId: chatFunctionId,
          body: json.encode({
            'action': 'checkMute',
            'roomId': _roomId,
            'uid': requireCurrentAuthUser.uid,
          }),
        );
        if (response.responseStatusCode == 200) {
          var result = jsonDecode(response.responseBody);
          isMuted.value = result['isMuted'] ?? false;
        }
      }
    } catch (e) {
      log('Error checking mute status: $e');
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      if (chatFunctionId.isNotEmpty) {
        var response = await functions.createExecution(
          functionId: chatFunctionId,
          body: json.encode({
            'action': 'delete',
            'messageId': messageId,
            'uid': requireCurrentAuthUser.uid,
          }),
        );
        if (response.responseStatusCode != 200) {
          throw Exception('Failed to delete message via cloud function');
        }
      } else {
        Message messageToDelete = messages.firstWhere(
          (msg) => msg.messageId == messageId,
        );
        messageToDelete =
            messageToDelete.copyWith(content: '', isDeleted: true);

        await tablesDB.updateRow(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          rowId: messageId,
          data: messageToDelete.toJsonForUpload(),
        );
      }
      log('Message deleted successfully');
    } catch (e) {
      log('Error deleting message: $e');
      rethrow;
    }
  }

  Future<void> loadMessages() async {
    messages.clear();
    var queries = [
      Query.equal('roomId', _roomId),
      Query.orderAsc('index'),
      Query.limit(100),
    ];
    ReplyTo? replyTo;
    RowList messagesList = await tablesDB.listRows(
      databaseId: masterDatabaseId,
      tableId: chatMessagesTableId,
      queries: queries,
    );
    for (Row message in messagesList.rows) {
      try {
        Row replyToDoc = await tablesDB.getRow(
          databaseId: masterDatabaseId,
          tableId: chatMessageReplyTableId,
          rowId: message.$id,
        );
        replyTo = ReplyTo.fromJson(replyToDoc.data);
      } catch (e) {
        if (e is AppwriteException && e.code == 404) {
          replyTo = null;
        } else {
          rethrow;
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
      final user = requireCurrentAuthUser;

      if (chatFunctionId.isNotEmpty) {
        final String messageId = ID.unique();
        var response = await functions.createExecution(
          functionId: chatFunctionId,
          body: json.encode({
            'action': 'send',
            'messageId': messageId,
            'roomId': _roomId,
            'creatorId': user.uid,
            'creatorUsername': user.userName ?? '',
            'creatorName': user.displayName,
            'creatorImgUrl': user.profileImageUrl ?? '',
            'content': content,
          }),
        );
        if (response.responseStatusCode != 200) {
          throw Exception('Failed to send message');
        }
        if (replyingTo.value != null) {
          await tablesDB.createRow(
            databaseId: masterDatabaseId,
            tableId: chatMessageReplyTableId,
            rowId: messageId,
            data: replyingTo.value!.toJson(),
          );
        }
      } else {
        final String messageId = ID.unique();
        final int newIndex =
            messages.isNotEmpty ? messages.last.index + 1 : 0;
        final Message message = Message(
          roomId: _roomId,
          messageId: messageId,
          creatorId: user.uid,
          creatorUsername: user.userName ?? '',
          creatorName: user.displayName,
          hasValidTag: false,
          index: newIndex,
          creatorImgUrl: user.profileImageUrl ?? '',
          isEdited: false,
          content: content,
          creationDateTime: DateTime.now(),
          isDeleted: false,
        );

        await tablesDB.createRow(
          databaseId: masterDatabaseId,
          tableId: chatMessagesTableId,
          rowId: messageId,
          data: message.toJsonForUpload(),
        );

        if (replyingTo.value != null) {
          await tablesDB.createRow(
            databaseId: masterDatabaseId,
            tableId: chatMessageReplyTableId,
            rowId: messageId,
            data: replyingTo.value!.toJson(),
          );
        }
      }

      if (appwriteUpcommingRoom != null) {
        log('Sending notification for sent message');
        var body = json.encode({
          'roomId': appwriteUpcommingRoom?.id,
          'payload': {
            'title': 'Message received in ${appwriteUpcommingRoom?.name}',
            'body':
                '${user.displayName} said: ${content}',
          },
        });
        var results = await functions.createExecution(
          functionId: sendMessageNotificationFunctionID,
          body: body.toString(),
        );
        log(results.status.name);
      }

      replyingTo.value = null;
    } catch (e) {
      log('Error sending message: $e');
      return;
    }
    log('Message sent\n');
  }

  Future<void> editMessage(String messageId, String newContent) async {
    Message updatedMessage = messages.firstWhere(
      (msg) => msg.messageId == messageId,
    );
    updatedMessage = updatedMessage.copyWith(
      content: newContent,
      isEdited: true,
      isDeleted: false,
    );

    try {
      await tablesDB.updateRow(
        databaseId: masterDatabaseId,
        tableId: chatMessagesTableId,
        rowId: messageId,
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

  Future<void> muteUser(String targetUid) async {
    if (!isAdmin || chatFunctionId.isEmpty) return;
    try {
      await functions.createExecution(
        functionId: chatFunctionId,
        body: json.encode({
          'action': 'mute',
          'roomId': _roomId,
          'targetUid': targetUid,
          'moderatorId': requireCurrentAuthUser.uid,
          'isMuted': true,
        }),
      );
    } catch (e) {
      log('Error muting user: $e');
      rethrow;
    }
  }

  Future<void> unmuteUser(String targetUid) async {
    if (!isAdmin || chatFunctionId.isEmpty) return;
    try {
      await functions.createExecution(
        functionId: chatFunctionId,
        body: json.encode({
          'action': 'mute',
          'roomId': _roomId,
          'targetUid': targetUid,
          'moderatorId': requireCurrentAuthUser.uid,
          'isMuted': false,
        }),
      );
    } catch (e) {
      log('Error unmuting user: $e');
      rethrow;
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
          'databases.$masterDatabaseId.tables.$chatMessagesTableId.rows';
      subscription = realtime.subscribe([channel]);
      subscription?.stream.listen((data) async {
        if (data.payload.isNotEmpty) {
          String roomId = data.payload['roomId'];
          if (roomId == _roomId) {
            String docId = data.payload['\$id'];
            String action = data.events.first.substring(
              channel.length + 1 + docId.length + 1,
            );
            log(action);
            if (action == 'create') {
              Message newMessage = Message.fromJson(data.payload);
              ReplyTo? replyTo;
              try {
                Row replyToDoc = await tablesDB.getRow(
                  databaseId: masterDatabaseId,
                  tableId: chatMessageReplyTableId,
                  rowId: newMessage.messageId,
                );
                replyTo = ReplyTo.fromJson(replyToDoc.data);
              } catch (e) {
                if (e is AppwriteException && e.code == 404) {
                  replyTo = null;
                } else {
                  log("Error fetching replyTo document: ${e.toString()}");
                  rethrow;
                }
              }
              newMessage.replyTo = replyTo;

              messages.add(newMessage);
              if (appwriteRoom != null) {
                _notifications.show(
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
                isDeleted: updatedMessage.isDeleted,
              );
              if (appwriteRoom != null) {
                _notifications.show(
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
