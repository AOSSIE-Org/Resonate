class ReplyTo {
  String creatorUsername;
  String creatorImgUrl;
  int index;
  String content;
  String messageId;

  ReplyTo({
    required this.creatorUsername,
    required this.creatorImgUrl,
    required this.index,
    required this.content,
    required this.messageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'creatorUsername': creatorUsername,
      'creatorImgUrl': creatorImgUrl,
      'index': index,
      'content': content,
      'messageId': messageId,
    };
  }

  ReplyTo.fromJson(Map<String, dynamic> json)
    : creatorUsername = json['creatorUsername'],
      creatorImgUrl = json['creatorImgUrl'],
      index = json['index'],
      content = json['content'],
      messageId = json['messageId'];
}
