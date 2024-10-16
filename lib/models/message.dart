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
  Duration creationDateTime;
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
      'creationDateTime': creationDateTime.inMilliseconds, 
      'replyTo': replyTo?.toJson(), 
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
        creationDateTime = Duration(milliseconds: json['creationDateTime']),
        replyTo = json['replyTo'] != null ? ReplyTo.fromJson(json['replyTo']) : null;
}
