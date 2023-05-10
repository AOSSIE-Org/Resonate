class ResonateUser{
  final String? uid;
  final String? userName;
  final String? profileImage;
  final String? gender;
  final String? dateOfBirth;
  final List<String>? followers;
  final List<String>? followings;

  ResonateUser({this.uid, this.userName, this.profileImage, this.gender, this.dateOfBirth, this.followers = const [], this.followings = const []});

  factory ResonateUser.fromJson(Map<String, dynamic> json){
    return ResonateUser(
      uid: json["uid"],
      userName: json["username"],
      profileImage: json["profileImage"],
      gender: json["gender"],
      dateOfBirth: json["dateOfBirth"],
      followers: List<String>.from(json["followers"] ?? []),
      followings: List<String>.from(json["followings"]?? [])
    );
  }
}