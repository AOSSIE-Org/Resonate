class Participant {
  Participant({
    required this.email,
    required this.name,
    required this.dpUrl,
    required this.isAdmin,
    required this.isMicOn,
    required this.isModerator,
    required this.isSpeaker,
    required this.isSpeaking,
  });
  late final String email;
  late final String name;
  late final String dpUrl;
  late final bool isAdmin;
  late final bool isMicOn;
  late final bool isModerator;
  late final bool isSpeaker;
  late final bool isSpeaking;

  Participant.fromJson(Map<String, dynamic> json){
    email = json['email'];
    name = json['name'] ?? "Unknown";
    dpUrl = json['dpUrl'] ?? "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80";
    isAdmin = json['isAdmin'];
    isMicOn = json['isMicOn'];
    isModerator = json['isModerator'];
    isSpeaker = json['isSpeaker'];
    isSpeaking = json['isSpeaking'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['name'] = name;
    _data['dpUrl'] = dpUrl;
    _data['isAdmin'] = isAdmin;
    _data['isMicOn'] = isMicOn;
    _data['isModerator'] = isModerator;
    _data['isSpeaker'] = isSpeaker;
    _data['isSpeaking'] = isSpeaking;
    return _data;
  }
}