// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follower_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FollowerUserModel {

@JsonKey(name: "\$id", includeToJson: false) String get docId;@JsonKey(name: "followerUserId") String get uid;@JsonKey(name: "followerUsername") String get username;@JsonKey(name: "followerProfileImageUrl") String get profileImageUrl;@JsonKey(name: "followerName") String get name;@JsonKey(name: 'followerFCMToken') String get fcmToken;@JsonKey(name: "followingUserId") String? get followingUserId;@JsonKey(name: 'followerRating', fromJson: toDouble) double? get followerRating;
/// Create a copy of FollowerUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowerUserModelCopyWith<FollowerUserModel> get copyWith => _$FollowerUserModelCopyWithImpl<FollowerUserModel>(this as FollowerUserModel, _$identity);

  /// Serializes this FollowerUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowerUserModel&&(identical(other.docId, docId) || other.docId == docId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.followingUserId, followingUserId) || other.followingUserId == followingUserId)&&(identical(other.followerRating, followerRating) || other.followerRating == followerRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,docId,uid,username,profileImageUrl,name,fcmToken,followingUserId,followerRating);

@override
String toString() {
  return 'FollowerUserModel(docId: $docId, uid: $uid, username: $username, profileImageUrl: $profileImageUrl, name: $name, fcmToken: $fcmToken, followingUserId: $followingUserId, followerRating: $followerRating)';
}


}

/// @nodoc
abstract mixin class $FollowerUserModelCopyWith<$Res>  {
  factory $FollowerUserModelCopyWith(FollowerUserModel value, $Res Function(FollowerUserModel) _then) = _$FollowerUserModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "\$id", includeToJson: false) String docId,@JsonKey(name: "followerUserId") String uid,@JsonKey(name: "followerUsername") String username,@JsonKey(name: "followerProfileImageUrl") String profileImageUrl,@JsonKey(name: "followerName") String name,@JsonKey(name: 'followerFCMToken') String fcmToken,@JsonKey(name: "followingUserId") String? followingUserId,@JsonKey(name: 'followerRating', fromJson: toDouble) double? followerRating
});




}
/// @nodoc
class _$FollowerUserModelCopyWithImpl<$Res>
    implements $FollowerUserModelCopyWith<$Res> {
  _$FollowerUserModelCopyWithImpl(this._self, this._then);

  final FollowerUserModel _self;
  final $Res Function(FollowerUserModel) _then;

/// Create a copy of FollowerUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? docId = null,Object? uid = null,Object? username = null,Object? profileImageUrl = null,Object? name = null,Object? fcmToken = null,Object? followingUserId = freezed,Object? followerRating = freezed,}) {
  return _then(_self.copyWith(
docId: null == docId ? _self.docId : docId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: null == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,followingUserId: freezed == followingUserId ? _self.followingUserId : followingUserId // ignore: cast_nullable_to_non_nullable
as String?,followerRating: freezed == followerRating ? _self.followerRating : followerRating // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowerUserModel].
extension FollowerUserModelPatterns on FollowerUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowerUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowerUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowerUserModel value)  $default,){
final _that = this;
switch (_that) {
case _FollowerUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowerUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _FollowerUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "\$id", includeToJson: false)  String docId, @JsonKey(name: "followerUserId")  String uid, @JsonKey(name: "followerUsername")  String username, @JsonKey(name: "followerProfileImageUrl")  String profileImageUrl, @JsonKey(name: "followerName")  String name, @JsonKey(name: 'followerFCMToken')  String fcmToken, @JsonKey(name: "followingUserId")  String? followingUserId, @JsonKey(name: 'followerRating', fromJson: toDouble)  double? followerRating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowerUserModel() when $default != null:
return $default(_that.docId,_that.uid,_that.username,_that.profileImageUrl,_that.name,_that.fcmToken,_that.followingUserId,_that.followerRating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "\$id", includeToJson: false)  String docId, @JsonKey(name: "followerUserId")  String uid, @JsonKey(name: "followerUsername")  String username, @JsonKey(name: "followerProfileImageUrl")  String profileImageUrl, @JsonKey(name: "followerName")  String name, @JsonKey(name: 'followerFCMToken')  String fcmToken, @JsonKey(name: "followingUserId")  String? followingUserId, @JsonKey(name: 'followerRating', fromJson: toDouble)  double? followerRating)  $default,) {final _that = this;
switch (_that) {
case _FollowerUserModel():
return $default(_that.docId,_that.uid,_that.username,_that.profileImageUrl,_that.name,_that.fcmToken,_that.followingUserId,_that.followerRating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "\$id", includeToJson: false)  String docId, @JsonKey(name: "followerUserId")  String uid, @JsonKey(name: "followerUsername")  String username, @JsonKey(name: "followerProfileImageUrl")  String profileImageUrl, @JsonKey(name: "followerName")  String name, @JsonKey(name: 'followerFCMToken')  String fcmToken, @JsonKey(name: "followingUserId")  String? followingUserId, @JsonKey(name: 'followerRating', fromJson: toDouble)  double? followerRating)?  $default,) {final _that = this;
switch (_that) {
case _FollowerUserModel() when $default != null:
return $default(_that.docId,_that.uid,_that.username,_that.profileImageUrl,_that.name,_that.fcmToken,_that.followingUserId,_that.followerRating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowerUserModel extends FollowerUserModel {
   _FollowerUserModel({@JsonKey(name: "\$id", includeToJson: false) required this.docId, @JsonKey(name: "followerUserId") required this.uid, @JsonKey(name: "followerUsername") required this.username, @JsonKey(name: "followerProfileImageUrl") required this.profileImageUrl, @JsonKey(name: "followerName") required this.name, @JsonKey(name: 'followerFCMToken') required this.fcmToken, @JsonKey(name: "followingUserId") this.followingUserId, @JsonKey(name: 'followerRating', fromJson: toDouble) required this.followerRating}): super._();
  factory _FollowerUserModel.fromJson(Map<String, dynamic> json) => _$FollowerUserModelFromJson(json);

@override@JsonKey(name: "\$id", includeToJson: false) final  String docId;
@override@JsonKey(name: "followerUserId") final  String uid;
@override@JsonKey(name: "followerUsername") final  String username;
@override@JsonKey(name: "followerProfileImageUrl") final  String profileImageUrl;
@override@JsonKey(name: "followerName") final  String name;
@override@JsonKey(name: 'followerFCMToken') final  String fcmToken;
@override@JsonKey(name: "followingUserId") final  String? followingUserId;
@override@JsonKey(name: 'followerRating', fromJson: toDouble) final  double? followerRating;

/// Create a copy of FollowerUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowerUserModelCopyWith<_FollowerUserModel> get copyWith => __$FollowerUserModelCopyWithImpl<_FollowerUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowerUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowerUserModel&&(identical(other.docId, docId) || other.docId == docId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.name, name) || other.name == name)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.followingUserId, followingUserId) || other.followingUserId == followingUserId)&&(identical(other.followerRating, followerRating) || other.followerRating == followerRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,docId,uid,username,profileImageUrl,name,fcmToken,followingUserId,followerRating);

@override
String toString() {
  return 'FollowerUserModel(docId: $docId, uid: $uid, username: $username, profileImageUrl: $profileImageUrl, name: $name, fcmToken: $fcmToken, followingUserId: $followingUserId, followerRating: $followerRating)';
}


}

/// @nodoc
abstract mixin class _$FollowerUserModelCopyWith<$Res> implements $FollowerUserModelCopyWith<$Res> {
  factory _$FollowerUserModelCopyWith(_FollowerUserModel value, $Res Function(_FollowerUserModel) _then) = __$FollowerUserModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "\$id", includeToJson: false) String docId,@JsonKey(name: "followerUserId") String uid,@JsonKey(name: "followerUsername") String username,@JsonKey(name: "followerProfileImageUrl") String profileImageUrl,@JsonKey(name: "followerName") String name,@JsonKey(name: 'followerFCMToken') String fcmToken,@JsonKey(name: "followingUserId") String? followingUserId,@JsonKey(name: 'followerRating', fromJson: toDouble) double? followerRating
});




}
/// @nodoc
class __$FollowerUserModelCopyWithImpl<$Res>
    implements _$FollowerUserModelCopyWith<$Res> {
  __$FollowerUserModelCopyWithImpl(this._self, this._then);

  final _FollowerUserModel _self;
  final $Res Function(_FollowerUserModel) _then;

/// Create a copy of FollowerUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? docId = null,Object? uid = null,Object? username = null,Object? profileImageUrl = null,Object? name = null,Object? fcmToken = null,Object? followingUserId = freezed,Object? followerRating = freezed,}) {
  return _then(_FollowerUserModel(
docId: null == docId ? _self.docId : docId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: null == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,followingUserId: freezed == followingUserId ? _self.followingUserId : followingUserId // ignore: cast_nullable_to_non_nullable
as String?,followerRating: freezed == followerRating ? _self.followerRating : followerRating // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
