// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resonate_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResonateUser {

 String? get uid;@JsonKey(name: 'userName') String? get userName; String? get profileImageUrl; String? get name; String? get email;@JsonKey(name: 'dob') String? get dateOfBirth; String? get docId;@JsonKey(fromJson: toDouble) double? get userRating;
/// Create a copy of ResonateUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResonateUserCopyWith<ResonateUser> get copyWith => _$ResonateUserCopyWithImpl<ResonateUser>(this as ResonateUser, _$identity);

  /// Serializes this ResonateUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResonateUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.docId, docId) || other.docId == docId)&&(identical(other.userRating, userRating) || other.userRating == userRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,userName,profileImageUrl,name,email,dateOfBirth,docId,userRating);

@override
String toString() {
  return 'ResonateUser(uid: $uid, userName: $userName, profileImageUrl: $profileImageUrl, name: $name, email: $email, dateOfBirth: $dateOfBirth, docId: $docId, userRating: $userRating)';
}


}

/// @nodoc
abstract mixin class $ResonateUserCopyWith<$Res>  {
  factory $ResonateUserCopyWith(ResonateUser value, $Res Function(ResonateUser) _then) = _$ResonateUserCopyWithImpl;
@useResult
$Res call({
 String? uid,@JsonKey(name: 'userName') String? userName, String? profileImageUrl, String? name, String? email,@JsonKey(name: 'dob') String? dateOfBirth, String? docId,@JsonKey(fromJson: toDouble) double? userRating
});




}
/// @nodoc
class _$ResonateUserCopyWithImpl<$Res>
    implements $ResonateUserCopyWith<$Res> {
  _$ResonateUserCopyWithImpl(this._self, this._then);

  final ResonateUser _self;
  final $Res Function(ResonateUser) _then;

/// Create a copy of ResonateUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = freezed,Object? userName = freezed,Object? profileImageUrl = freezed,Object? name = freezed,Object? email = freezed,Object? dateOfBirth = freezed,Object? docId = freezed,Object? userRating = freezed,}) {
  return _then(_self.copyWith(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,docId: freezed == docId ? _self.docId : docId // ignore: cast_nullable_to_non_nullable
as String?,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResonateUser].
extension ResonateUserPatterns on ResonateUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResonateUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResonateUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResonateUser value)  $default,){
final _that = this;
switch (_that) {
case _ResonateUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResonateUser value)?  $default,){
final _that = this;
switch (_that) {
case _ResonateUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? uid, @JsonKey(name: 'userName')  String? userName,  String? profileImageUrl,  String? name,  String? email, @JsonKey(name: 'dob')  String? dateOfBirth,  String? docId, @JsonKey(fromJson: toDouble)  double? userRating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResonateUser() when $default != null:
return $default(_that.uid,_that.userName,_that.profileImageUrl,_that.name,_that.email,_that.dateOfBirth,_that.docId,_that.userRating);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? uid, @JsonKey(name: 'userName')  String? userName,  String? profileImageUrl,  String? name,  String? email, @JsonKey(name: 'dob')  String? dateOfBirth,  String? docId, @JsonKey(fromJson: toDouble)  double? userRating)  $default,) {final _that = this;
switch (_that) {
case _ResonateUser():
return $default(_that.uid,_that.userName,_that.profileImageUrl,_that.name,_that.email,_that.dateOfBirth,_that.docId,_that.userRating);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? uid, @JsonKey(name: 'userName')  String? userName,  String? profileImageUrl,  String? name,  String? email, @JsonKey(name: 'dob')  String? dateOfBirth,  String? docId, @JsonKey(fromJson: toDouble)  double? userRating)?  $default,) {final _that = this;
switch (_that) {
case _ResonateUser() when $default != null:
return $default(_that.uid,_that.userName,_that.profileImageUrl,_that.name,_that.email,_that.dateOfBirth,_that.docId,_that.userRating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResonateUser implements ResonateUser {
  const _ResonateUser({this.uid, @JsonKey(name: 'userName') this.userName, this.profileImageUrl, this.name, this.email, @JsonKey(name: 'dob') this.dateOfBirth, this.docId, @JsonKey(fromJson: toDouble) this.userRating});
  factory _ResonateUser.fromJson(Map<String, dynamic> json) => _$ResonateUserFromJson(json);

@override final  String? uid;
@override@JsonKey(name: 'userName') final  String? userName;
@override final  String? profileImageUrl;
@override final  String? name;
@override final  String? email;
@override@JsonKey(name: 'dob') final  String? dateOfBirth;
@override final  String? docId;
@override@JsonKey(fromJson: toDouble) final  double? userRating;

/// Create a copy of ResonateUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResonateUserCopyWith<_ResonateUser> get copyWith => __$ResonateUserCopyWithImpl<_ResonateUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResonateUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResonateUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.docId, docId) || other.docId == docId)&&(identical(other.userRating, userRating) || other.userRating == userRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,userName,profileImageUrl,name,email,dateOfBirth,docId,userRating);

@override
String toString() {
  return 'ResonateUser(uid: $uid, userName: $userName, profileImageUrl: $profileImageUrl, name: $name, email: $email, dateOfBirth: $dateOfBirth, docId: $docId, userRating: $userRating)';
}


}

/// @nodoc
abstract mixin class _$ResonateUserCopyWith<$Res> implements $ResonateUserCopyWith<$Res> {
  factory _$ResonateUserCopyWith(_ResonateUser value, $Res Function(_ResonateUser) _then) = __$ResonateUserCopyWithImpl;
@override @useResult
$Res call({
 String? uid,@JsonKey(name: 'userName') String? userName, String? profileImageUrl, String? name, String? email,@JsonKey(name: 'dob') String? dateOfBirth, String? docId,@JsonKey(fromJson: toDouble) double? userRating
});




}
/// @nodoc
class __$ResonateUserCopyWithImpl<$Res>
    implements _$ResonateUserCopyWith<$Res> {
  __$ResonateUserCopyWithImpl(this._self, this._then);

  final _ResonateUser _self;
  final $Res Function(_ResonateUser) _then;

/// Create a copy of ResonateUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = freezed,Object? userName = freezed,Object? profileImageUrl = freezed,Object? name = freezed,Object? email = freezed,Object? dateOfBirth = freezed,Object? docId = freezed,Object? userRating = freezed,}) {
  return _then(_ResonateUser(
uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,docId: freezed == docId ? _self.docId : docId // ignore: cast_nullable_to_non_nullable
as String?,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
