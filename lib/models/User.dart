import 'package:uuid/uuid.dart';

class User{
  String? id;
  String? name;
  String? email;
  bool? isEmailVerified;
  String? pictureUrl;
  String? phoneNumber;
  Enum? signedInBy;

  User({this.name, this.email, this.isEmailVerified, this.pictureUrl, this.phoneNumber, this.signedInBy}){
    const uuid = Uuid();
    id = uuid.v4();
  }
}