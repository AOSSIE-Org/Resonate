// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friends_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendsModel {

 String get senderId; String get recieverId; String get senderProfileImgUrl; String get recieverProfileImgUrl; String get senderUsername; String get recieverUsername; String get senderName; String get recieverName; String? get senderFCMToken; String? get recieverFCMToken; List<String>? get users; FriendRequestStatus get requestStatus; String get requestSentByUserId;@JsonKey(fromJson: toDouble) double? get senderRating;@JsonKey(fromJson: toDouble) double? get recieverRating;@JsonKey(name: "\$id", includeToJson: false) String get docId;
/// Create a copy of FriendsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendsModelCopyWith<FriendsModel> get copyWith => _$FriendsModelCopyWithImpl<FriendsModel>(this as FriendsModel, _$identity);

  /// Serializes this FriendsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendsModel&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.recieverId, recieverId) || other.recieverId == recieverId)&&(identical(other.senderProfileImgUrl, senderProfileImgUrl) || other.senderProfileImgUrl == senderProfileImgUrl)&&(identical(other.recieverProfileImgUrl, recieverProfileImgUrl) || other.recieverProfileImgUrl == recieverProfileImgUrl)&&(identical(other.senderUsername, senderUsername) || other.senderUsername == senderUsername)&&(identical(other.recieverUsername, recieverUsername) || other.recieverUsername == recieverUsername)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.recieverName, recieverName) || other.recieverName == recieverName)&&(identical(other.senderFCMToken, senderFCMToken) || other.senderFCMToken == senderFCMToken)&&(identical(other.recieverFCMToken, recieverFCMToken) || other.recieverFCMToken == recieverFCMToken)&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.requestStatus, requestStatus) || other.requestStatus == requestStatus)&&(identical(other.requestSentByUserId, requestSentByUserId) || other.requestSentByUserId == requestSentByUserId)&&(identical(other.senderRating, senderRating) || other.senderRating == senderRating)&&(identical(other.recieverRating, recieverRating) || other.recieverRating == recieverRating)&&(identical(other.docId, docId) || other.docId == docId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,senderId,recieverId,senderProfileImgUrl,recieverProfileImgUrl,senderUsername,recieverUsername,senderName,recieverName,senderFCMToken,recieverFCMToken,const DeepCollectionEquality().hash(users),requestStatus,requestSentByUserId,senderRating,recieverRating,docId);

@override
String toString() {
  return 'FriendsModel(senderId: $senderId, recieverId: $recieverId, senderProfileImgUrl: $senderProfileImgUrl, recieverProfileImgUrl: $recieverProfileImgUrl, senderUsername: $senderUsername, recieverUsername: $recieverUsername, senderName: $senderName, recieverName: $recieverName, senderFCMToken: $senderFCMToken, recieverFCMToken: $recieverFCMToken, users: $users, requestStatus: $requestStatus, requestSentByUserId: $requestSentByUserId, senderRating: $senderRating, recieverRating: $recieverRating, docId: $docId)';
}


}

/// @nodoc
abstract mixin class $FriendsModelCopyWith<$Res>  {
  factory $FriendsModelCopyWith(FriendsModel value, $Res Function(FriendsModel) _then) = _$FriendsModelCopyWithImpl;
@useResult
$Res call({
 String senderId, String recieverId, String senderProfileImgUrl, String recieverProfileImgUrl, String senderUsername, String recieverUsername, String senderName, String recieverName, String? senderFCMToken, String? recieverFCMToken, List<String>? users, FriendRequestStatus requestStatus, String requestSentByUserId,@JsonKey(fromJson: toDouble) double? senderRating,@JsonKey(fromJson: toDouble) double? recieverRating,@JsonKey(name: "\$id", includeToJson: false) String docId
});




}
/// @nodoc
class _$FriendsModelCopyWithImpl<$Res>
    implements $FriendsModelCopyWith<$Res> {
  _$FriendsModelCopyWithImpl(this._self, this._then);

  final FriendsModel _self;
  final $Res Function(FriendsModel) _then;

/// Create a copy of FriendsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? senderId = null,Object? recieverId = null,Object? senderProfileImgUrl = null,Object? recieverProfileImgUrl = null,Object? senderUsername = null,Object? recieverUsername = null,Object? senderName = null,Object? recieverName = null,Object? senderFCMToken = freezed,Object? recieverFCMToken = freezed,Object? users = freezed,Object? requestStatus = null,Object? requestSentByUserId = null,Object? senderRating = freezed,Object? recieverRating = freezed,Object? docId = null,}) {
  return _then(_self.copyWith(
senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,recieverId: null == recieverId ? _self.recieverId : recieverId // ignore: cast_nullable_to_non_nullable
as String,senderProfileImgUrl: null == senderProfileImgUrl ? _self.senderProfileImgUrl : senderProfileImgUrl // ignore: cast_nullable_to_non_nullable
as String,recieverProfileImgUrl: null == recieverProfileImgUrl ? _self.recieverProfileImgUrl : recieverProfileImgUrl // ignore: cast_nullable_to_non_nullable
as String,senderUsername: null == senderUsername ? _self.senderUsername : senderUsername // ignore: cast_nullable_to_non_nullable
as String,recieverUsername: null == recieverUsername ? _self.recieverUsername : recieverUsername // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,recieverName: null == recieverName ? _self.recieverName : recieverName // ignore: cast_nullable_to_non_nullable
as String,senderFCMToken: freezed == senderFCMToken ? _self.senderFCMToken : senderFCMToken // ignore: cast_nullable_to_non_nullable
as String?,recieverFCMToken: freezed == recieverFCMToken ? _self.recieverFCMToken : recieverFCMToken // ignore: cast_nullable_to_non_nullable
as String?,users: freezed == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<String>?,requestStatus: null == requestStatus ? _self.requestStatus : requestStatus // ignore: cast_nullable_to_non_nullable
as FriendRequestStatus,requestSentByUserId: null == requestSentByUserId ? _self.requestSentByUserId : requestSentByUserId // ignore: cast_nullable_to_non_nullable
as String,senderRating: freezed == senderRating ? _self.senderRating : senderRating // ignore: cast_nullable_to_non_nullable
as double?,recieverRating: freezed == recieverRating ? _self.recieverRating : recieverRating // ignore: cast_nullable_to_non_nullable
as double?,docId: null == docId ? _self.docId : docId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FriendsModel].
extension FriendsModelPatterns on FriendsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendsModel value)  $default,){
final _that = this;
switch (_that) {
case _FriendsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendsModel value)?  $default,){
final _that = this;
switch (_that) {
case _FriendsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String senderId,  String recieverId,  String senderProfileImgUrl,  String recieverProfileImgUrl,  String senderUsername,  String recieverUsername,  String senderName,  String recieverName,  String? senderFCMToken,  String? recieverFCMToken,  List<String>? users,  FriendRequestStatus requestStatus,  String requestSentByUserId, @JsonKey(fromJson: toDouble)  double? senderRating, @JsonKey(fromJson: toDouble)  double? recieverRating, @JsonKey(name: "\$id", includeToJson: false)  String docId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendsModel() when $default != null:
return $default(_that.senderId,_that.recieverId,_that.senderProfileImgUrl,_that.recieverProfileImgUrl,_that.senderUsername,_that.recieverUsername,_that.senderName,_that.recieverName,_that.senderFCMToken,_that.recieverFCMToken,_that.users,_that.requestStatus,_that.requestSentByUserId,_that.senderRating,_that.recieverRating,_that.docId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String senderId,  String recieverId,  String senderProfileImgUrl,  String recieverProfileImgUrl,  String senderUsername,  String recieverUsername,  String senderName,  String recieverName,  String? senderFCMToken,  String? recieverFCMToken,  List<String>? users,  FriendRequestStatus requestStatus,  String requestSentByUserId, @JsonKey(fromJson: toDouble)  double? senderRating, @JsonKey(fromJson: toDouble)  double? recieverRating, @JsonKey(name: "\$id", includeToJson: false)  String docId)  $default,) {final _that = this;
switch (_that) {
case _FriendsModel():
return $default(_that.senderId,_that.recieverId,_that.senderProfileImgUrl,_that.recieverProfileImgUrl,_that.senderUsername,_that.recieverUsername,_that.senderName,_that.recieverName,_that.senderFCMToken,_that.recieverFCMToken,_that.users,_that.requestStatus,_that.requestSentByUserId,_that.senderRating,_that.recieverRating,_that.docId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String senderId,  String recieverId,  String senderProfileImgUrl,  String recieverProfileImgUrl,  String senderUsername,  String recieverUsername,  String senderName,  String recieverName,  String? senderFCMToken,  String? recieverFCMToken,  List<String>? users,  FriendRequestStatus requestStatus,  String requestSentByUserId, @JsonKey(fromJson: toDouble)  double? senderRating, @JsonKey(fromJson: toDouble)  double? recieverRating, @JsonKey(name: "\$id", includeToJson: false)  String docId)?  $default,) {final _that = this;
switch (_that) {
case _FriendsModel() when $default != null:
return $default(_that.senderId,_that.recieverId,_that.senderProfileImgUrl,_that.recieverProfileImgUrl,_that.senderUsername,_that.recieverUsername,_that.senderName,_that.recieverName,_that.senderFCMToken,_that.recieverFCMToken,_that.users,_that.requestStatus,_that.requestSentByUserId,_that.senderRating,_that.recieverRating,_that.docId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendsModel extends FriendsModel {
   _FriendsModel({required this.senderId, required this.recieverId, required this.senderProfileImgUrl, required this.recieverProfileImgUrl, required this.senderUsername, required this.recieverUsername, required this.senderName, required this.recieverName, this.senderFCMToken, this.recieverFCMToken, final  List<String>? users, required this.requestStatus, required this.requestSentByUserId, @JsonKey(fromJson: toDouble) required this.senderRating, @JsonKey(fromJson: toDouble) required this.recieverRating, @JsonKey(name: "\$id", includeToJson: false) required this.docId}): _users = users,super._();
  factory _FriendsModel.fromJson(Map<String, dynamic> json) => _$FriendsModelFromJson(json);

@override final  String senderId;
@override final  String recieverId;
@override final  String senderProfileImgUrl;
@override final  String recieverProfileImgUrl;
@override final  String senderUsername;
@override final  String recieverUsername;
@override final  String senderName;
@override final  String recieverName;
@override final  String? senderFCMToken;
@override final  String? recieverFCMToken;
 final  List<String>? _users;
@override List<String>? get users {
  final value = _users;
  if (value == null) return null;
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  FriendRequestStatus requestStatus;
@override final  String requestSentByUserId;
@override@JsonKey(fromJson: toDouble) final  double? senderRating;
@override@JsonKey(fromJson: toDouble) final  double? recieverRating;
@override@JsonKey(name: "\$id", includeToJson: false) final  String docId;

/// Create a copy of FriendsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendsModelCopyWith<_FriendsModel> get copyWith => __$FriendsModelCopyWithImpl<_FriendsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendsModel&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.recieverId, recieverId) || other.recieverId == recieverId)&&(identical(other.senderProfileImgUrl, senderProfileImgUrl) || other.senderProfileImgUrl == senderProfileImgUrl)&&(identical(other.recieverProfileImgUrl, recieverProfileImgUrl) || other.recieverProfileImgUrl == recieverProfileImgUrl)&&(identical(other.senderUsername, senderUsername) || other.senderUsername == senderUsername)&&(identical(other.recieverUsername, recieverUsername) || other.recieverUsername == recieverUsername)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.recieverName, recieverName) || other.recieverName == recieverName)&&(identical(other.senderFCMToken, senderFCMToken) || other.senderFCMToken == senderFCMToken)&&(identical(other.recieverFCMToken, recieverFCMToken) || other.recieverFCMToken == recieverFCMToken)&&const DeepCollectionEquality().equals(other._users, _users)&&(identical(other.requestStatus, requestStatus) || other.requestStatus == requestStatus)&&(identical(other.requestSentByUserId, requestSentByUserId) || other.requestSentByUserId == requestSentByUserId)&&(identical(other.senderRating, senderRating) || other.senderRating == senderRating)&&(identical(other.recieverRating, recieverRating) || other.recieverRating == recieverRating)&&(identical(other.docId, docId) || other.docId == docId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,senderId,recieverId,senderProfileImgUrl,recieverProfileImgUrl,senderUsername,recieverUsername,senderName,recieverName,senderFCMToken,recieverFCMToken,const DeepCollectionEquality().hash(_users),requestStatus,requestSentByUserId,senderRating,recieverRating,docId);

@override
String toString() {
  return 'FriendsModel(senderId: $senderId, recieverId: $recieverId, senderProfileImgUrl: $senderProfileImgUrl, recieverProfileImgUrl: $recieverProfileImgUrl, senderUsername: $senderUsername, recieverUsername: $recieverUsername, senderName: $senderName, recieverName: $recieverName, senderFCMToken: $senderFCMToken, recieverFCMToken: $recieverFCMToken, users: $users, requestStatus: $requestStatus, requestSentByUserId: $requestSentByUserId, senderRating: $senderRating, recieverRating: $recieverRating, docId: $docId)';
}


}

/// @nodoc
abstract mixin class _$FriendsModelCopyWith<$Res> implements $FriendsModelCopyWith<$Res> {
  factory _$FriendsModelCopyWith(_FriendsModel value, $Res Function(_FriendsModel) _then) = __$FriendsModelCopyWithImpl;
@override @useResult
$Res call({
 String senderId, String recieverId, String senderProfileImgUrl, String recieverProfileImgUrl, String senderUsername, String recieverUsername, String senderName, String recieverName, String? senderFCMToken, String? recieverFCMToken, List<String>? users, FriendRequestStatus requestStatus, String requestSentByUserId,@JsonKey(fromJson: toDouble) double? senderRating,@JsonKey(fromJson: toDouble) double? recieverRating,@JsonKey(name: "\$id", includeToJson: false) String docId
});




}
/// @nodoc
class __$FriendsModelCopyWithImpl<$Res>
    implements _$FriendsModelCopyWith<$Res> {
  __$FriendsModelCopyWithImpl(this._self, this._then);

  final _FriendsModel _self;
  final $Res Function(_FriendsModel) _then;

/// Create a copy of FriendsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? senderId = null,Object? recieverId = null,Object? senderProfileImgUrl = null,Object? recieverProfileImgUrl = null,Object? senderUsername = null,Object? recieverUsername = null,Object? senderName = null,Object? recieverName = null,Object? senderFCMToken = freezed,Object? recieverFCMToken = freezed,Object? users = freezed,Object? requestStatus = null,Object? requestSentByUserId = null,Object? senderRating = freezed,Object? recieverRating = freezed,Object? docId = null,}) {
  return _then(_FriendsModel(
senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,recieverId: null == recieverId ? _self.recieverId : recieverId // ignore: cast_nullable_to_non_nullable
as String,senderProfileImgUrl: null == senderProfileImgUrl ? _self.senderProfileImgUrl : senderProfileImgUrl // ignore: cast_nullable_to_non_nullable
as String,recieverProfileImgUrl: null == recieverProfileImgUrl ? _self.recieverProfileImgUrl : recieverProfileImgUrl // ignore: cast_nullable_to_non_nullable
as String,senderUsername: null == senderUsername ? _self.senderUsername : senderUsername // ignore: cast_nullable_to_non_nullable
as String,recieverUsername: null == recieverUsername ? _self.recieverUsername : recieverUsername // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,recieverName: null == recieverName ? _self.recieverName : recieverName // ignore: cast_nullable_to_non_nullable
as String,senderFCMToken: freezed == senderFCMToken ? _self.senderFCMToken : senderFCMToken // ignore: cast_nullable_to_non_nullable
as String?,recieverFCMToken: freezed == recieverFCMToken ? _self.recieverFCMToken : recieverFCMToken // ignore: cast_nullable_to_non_nullable
as String?,users: freezed == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<String>?,requestStatus: null == requestStatus ? _self.requestStatus : requestStatus // ignore: cast_nullable_to_non_nullable
as FriendRequestStatus,requestSentByUserId: null == requestSentByUserId ? _self.requestSentByUserId : requestSentByUserId // ignore: cast_nullable_to_non_nullable
as String,senderRating: freezed == senderRating ? _self.senderRating : senderRating // ignore: cast_nullable_to_non_nullable
as double?,recieverRating: freezed == recieverRating ? _self.recieverRating : recieverRating // ignore: cast_nullable_to_non_nullable
as double?,docId: null == docId ? _self.docId : docId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
