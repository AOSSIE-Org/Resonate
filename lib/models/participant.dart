class Participant {
  Participant({
    required this.uid,
    required this.email,
    required this.name,
    required this.dpUrl,
    required this.isAdmin,
    required this.isMicOn,
    required this.isModerator,
    required this.isSpeaker,
    required this.hasRequestedToBeSpeaker
  });
  late final String uid;
  late final String email;
  late final String name;
  late final String dpUrl;
  late bool isAdmin;
  late bool isMicOn;
  late bool isModerator;
  late bool isSpeaker;
  late bool hasRequestedToBeSpeaker;

  Participant.fromJson(Map<String, dynamic> json){
    uid = json["uid"];
    email = json['email'];
    name = json['name'] ?? "Unknown";
    dpUrl = json['dpUrl'] ?? "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80";
    isAdmin = json['isAdmin'];
    isMicOn = json['isMicOn'];
    isModerator = json['isModerator'];
    isSpeaker = json['isSpeaker'];
    hasRequestedToBeSpeaker = json["hasRequestedToBeSpeaker"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["uid"] = uid;
    data['email'] = email;
    data['name'] = name;
    data['dpUrl'] = dpUrl;
    data['isAdmin'] = isAdmin;
    data['isMicOn'] = isMicOn;
    data['isModerator'] = isModerator;
    data['isSpeaker'] = isSpeaker;
    data['hasRequestedToBeSpeaker'] = hasRequestedToBeSpeaker;
    return data;
  }
}