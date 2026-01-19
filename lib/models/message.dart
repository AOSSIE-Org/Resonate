import 'package:resonate/models/reply_to.dart';

class Message {
  String roomId;
  String messageId;
  String creatorId;
  String creatorUsername;
  String creatorName;
  String creatorImgUrl;
  bool hasValidTag;
  int index;
  bool isEdited;
  String content;
  DateTime creationDateTime;
  ReplyTo? replyTo;

  Message({
    required this.roomId,
    required this.messageId,
    required this.creatorId,
    required this.creatorUsername,
    required this.creatorName,
    required this.hasValidTag,
    required this.index,
    required this.creatorImgUrl,
    required this.isEdited,
    required this.content,
    required this.creationDateTime,
    this.replyTo,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'messageId': messageId,
      'creatorId': creatorId,
      'creatorUsername': creatorUsername,
      'creatorName': creatorName,
      'creatorImgUrl': creatorImgUrl,
      'hasValidTag': hasValidTag,
      'index': index,
      'isEdited': isEdited,
      'content': content,
      'creationDateTime': creationDateTime.toUtc().toIso8601String(),
      'replyTo': replyTo?.toJson(),
    };
  }

  Map<String, dynamic> toJsonForUpload() {
    return {
      'roomId': roomId,
      'messageId': messageId,
      'creatorId': creatorId,
      'creatorUsername': creatorUsername,
      'creatorName': creatorName,
      'creatorImgUrl': creatorImgUrl,
      'hasValidTag': hasValidTag,
      'index': index,
      'isEdited': isEdited,
      'content': content,
      'creationDateTime': creationDateTime.toUtc().toIso8601String(),
    };
  }

  Message.fromJson(Map<String, dynamic> json)
    : roomId = json['roomId'],
      messageId = json['messageId'],
      creatorId = json['creatorId'],
      creatorUsername = json['creatorUsername'],
      creatorName = json['creatorName'],
      creatorImgUrl = json['creatorImgUrl'],
      hasValidTag = json['hasValidTag'],
      index = json['index'],
      isEdited = json['isEdited'],
      content = json['content'],
      creationDateTime = DateTime.parse(json['creationDateTime']),
      replyTo = json['replyTo'] != null
          ? ReplyTo.fromJson(json['replyTo'])
          : null;
  Message copyWith({
    String? roomId,
    String? messageId,
    String? creatorId,
    String? creatorUsername,
    String? creatorName,
    String? creatorImgUrl,
    bool? hasValidTag,
    int? index,
    bool? isEdited,
    String? content,
    DateTime? creationDateTime,
    ReplyTo? replyTo,
  }) {
    return Message(
      roomId: roomId ?? this.roomId,
      messageId: messageId ?? this.messageId,
      creatorId: creatorId ?? this.creatorId,
      creatorUsername: creatorUsername ?? this.creatorUsername,
      creatorName: creatorName ?? this.creatorName,
      creatorImgUrl: creatorImgUrl ?? this.creatorImgUrl,
      hasValidTag: hasValidTag ?? this.hasValidTag,
      index: index ?? this.index,
      isEdited: isEdited ?? this.isEdited,
      content: content ?? this.content,
      creationDateTime: creationDateTime ?? this.creationDateTime,
      replyTo: replyTo ?? this.replyTo,
    );
  }
}
