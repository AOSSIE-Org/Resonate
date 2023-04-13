import 'package:uuid/uuid.dart';

class UserProfile{
  String? id;
  String? name;
  String? email;
  bool? isEmailVerified;
  String? pictureUrl;
  String? phoneNumber;
  Enum? signedInBy;

  UserProfile({this.name, this.email, this.isEmailVerified, this.pictureUrl, this.phoneNumber, this.signedInBy}){
    const uuid = Uuid();
    id = uuid.v4();
  }
}