//Participant is a json model class
//Participant has various parameters that are associated with a room's participant(s).
class Participant {
  Participant({
    required this.uid, //The unique identifier for the participant
    required this.email, //The email address of the participant.
    required this.name, //The name of the participant.
    required this.dpUrl, //The URL of the participant's profile picture (avatar).
    required this.isAdmin, //A bool indicating whether the participant is an administrator.
    required this.isMicOn, //A bool indicating whether the participant's microphone is on.
    required this.isModerator, //A bool indicating whether the participant is a moderator.
    required this.isSpeaker, //A bool indicating whether the participant is a speaker.
    required this.hasRequestedToBeSpeaker, //A bool indicating whether the participant has requested to be a speaker.
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

  //fromJson method is used to deserialize json data.
  Participant.fromJson(Map<String, dynamic> json) {
    //values on the left are asssigned to the values associated with json's key.
    //here uid is assigned to the value associated with json's "uid" key.
    uid = json["uid"];
    email = json['email'];
    //set the value of name variable to value stored in 'name'.
    name = json['name'] ??
        "Unknown"; //if value asssociated with 'name' key of json is null then set the value of name to "Unknown"
    dpUrl = json['dpUrl'] ??
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80";
    isAdmin = json['isAdmin'];
    isMicOn = json['isMicOn'];
    isModerator = json['isModerator'];
    isSpeaker = json['isSpeaker'];
    hasRequestedToBeSpeaker = json["hasRequestedToBeSpeaker"];
  }

  //toJson method is used for json serialization
  Map<String, dynamic> toJson() {
    //create data variable which is a map of String,dynamic
    final data = <String, dynamic>{};
    //Json key are of type String and the values the key are associated with can be of type dynamic(String, int, double, etc.)
    data["uid"] = uid; //assigns the value of uid to key named 'uid' in data map
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
