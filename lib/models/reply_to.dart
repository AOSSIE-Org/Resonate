class ReplyTo {
  String creatorUsername;
  String creatorImgUrl;
  int index;
  String content;

  ReplyTo({
    required this.creatorUsername,
    required this.creatorImgUrl,
    required this.index,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'creatorUsername': creatorUsername,
      'creatorImgUrl': creatorImgUrl,
      'index': index,
      'content': content,
    };
  }

  ReplyTo.fromJson(Map<String, dynamic> json)
      : creatorUsername = json['creatorUsername'],
        creatorImgUrl = json['creatorImgUrl'],
        index = json['index'],
        content = json['content'];
}
