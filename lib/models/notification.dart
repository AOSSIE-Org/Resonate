class Notification {
  final String notificationType;        
  final String initiatorUsername;        
  final String initiatorProfileImgUrl;   
  final String recipientId;               
  final String subject;                  

  Notification({
    required this.notificationType,
    required this.initiatorUsername,
    required this.initiatorProfileImgUrl,
    required this.recipientId,
    required this.subject,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationType': notificationType,
      'initiatorUsername': initiatorUsername,
      'initiatorProfileImgUrl': initiatorProfileImgUrl,
      'recipientId': recipientId,
      'subject': subject,
    };
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationType: json['notificationType'],
      initiatorUsername: json['initiatorUsername'],
      initiatorProfileImgUrl: json['initiatorProfileImgUrl'],
      recipientId: json['recipientId'],
      subject: json['subject'],
    );
  }
}
