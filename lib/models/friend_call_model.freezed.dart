// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_call_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendCallModel {

 String get callerName; String get recieverName; String get callerUsername; String get recieverUsername; String get callerUid; String get recieverUid; String get callerProfileImageUrl; String get recieverProfileImageUrl; String get livekitRoomId; FriendCallStatus get callStatus;@JsonKey(name: "\$id", includeToJson: false) String get docId;
/// Create a copy of FriendCallModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendCallModelCopyWith<FriendCallModel> get copyWith => _$FriendCallModelCopyWithImpl<FriendCallModel>(this as FriendCallModel, _$identity);

  /// Serializes this FriendCallModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendCallModel&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.recieverName, recieverName) || other.recieverName == recieverName)&&(identical(other.callerUsername, callerUsername) || other.callerUsername == callerUsername)&&(identical(other.recieverUsername, recieverUsername) || other.recieverUsername == recieverUsername)&&(identical(other.callerUid, callerUid) || other.callerUid == callerUid)&&(identical(other.recieverUid, recieverUid) || other.recieverUid == recieverUid)&&(identical(other.callerProfileImageUrl, callerProfileImageUrl) || other.callerProfileImageUrl == callerProfileImageUrl)&&(identical(other.recieverProfileImageUrl, recieverProfileImageUrl) || other.recieverProfileImageUrl == recieverProfileImageUrl)&&(identical(other.livekitRoomId, livekitRoomId) || other.livekitRoomId == livekitRoomId)&&(identical(other.callStatus, callStatus) || other.callStatus == callStatus)&&(identical(other.docId, docId) || other.docId == docId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callerName,recieverName,callerUsername,recieverUsername,callerUid,recieverUid,callerProfileImageUrl,recieverProfileImageUrl,livekitRoomId,callStatus,docId);

@override
String toString() {
  return 'FriendCallModel(callerName: $callerName, recieverName: $recieverName, callerUsername: $callerUsername, recieverUsername: $recieverUsername, callerUid: $callerUid, recieverUid: $recieverUid, callerProfileImageUrl: $callerProfileImageUrl, recieverProfileImageUrl: $recieverProfileImageUrl, livekitRoomId: $livekitRoomId, callStatus: $callStatus, docId: $docId)';
}


}

/// @nodoc
abstract mixin class $FriendCallModelCopyWith<$Res>  {
  factory $FriendCallModelCopyWith(FriendCallModel value, $Res Function(FriendCallModel) _then) = _$FriendCallModelCopyWithImpl;
@useResult
$Res call({
 String callerName, String recieverName, String callerUsername, String recieverUsername, String callerUid, String recieverUid, String callerProfileImageUrl, String recieverProfileImageUrl, String livekitRoomId, FriendCallStatus callStatus,@JsonKey(name: "\$id", includeToJson: false) String docId
});




}
/// @nodoc
class _$FriendCallModelCopyWithImpl<$Res>
    implements $FriendCallModelCopyWith<$Res> {
  _$FriendCallModelCopyWithImpl(this._self, this._then);

  final FriendCallModel _self;
  final $Res Function(FriendCallModel) _then;

/// Create a copy of FriendCallModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callerName = null,Object? recieverName = null,Object? callerUsername = null,Object? recieverUsername = null,Object? callerUid = null,Object? recieverUid = null,Object? callerProfileImageUrl = null,Object? recieverProfileImageUrl = null,Object? livekitRoomId = null,Object? callStatus = null,Object? docId = null,}) {
  return _then(_self.copyWith(
callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,recieverName: null == recieverName ? _self.recieverName : recieverName // ignore: cast_nullable_to_non_nullable
as String,callerUsername: null == callerUsername ? _self.callerUsername : callerUsername // ignore: cast_nullable_to_non_nullable
as String,recieverUsername: null == recieverUsername ? _self.recieverUsername : recieverUsername // ignore: cast_nullable_to_non_nullable
as String,callerUid: null == callerUid ? _self.callerUid : callerUid // ignore: cast_nullable_to_non_nullable
as String,recieverUid: null == recieverUid ? _self.recieverUid : recieverUid // ignore: cast_nullable_to_non_nullable
as String,callerProfileImageUrl: null == callerProfileImageUrl ? _self.callerProfileImageUrl : callerProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String,recieverProfileImageUrl: null == recieverProfileImageUrl ? _self.recieverProfileImageUrl : recieverProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String,livekitRoomId: null == livekitRoomId ? _self.livekitRoomId : livekitRoomId // ignore: cast_nullable_to_non_nullable
as String,callStatus: null == callStatus ? _self.callStatus : callStatus // ignore: cast_nullable_to_non_nullable
as FriendCallStatus,docId: null == docId ? _self.docId : docId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FriendCallModel].
extension FriendCallModelPatterns on FriendCallModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendCallModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendCallModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendCallModel value)  $default,){
final _that = this;
switch (_that) {
case _FriendCallModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendCallModel value)?  $default,){
final _that = this;
switch (_that) {
case _FriendCallModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callerName,  String recieverName,  String callerUsername,  String recieverUsername,  String callerUid,  String recieverUid,  String callerProfileImageUrl,  String recieverProfileImageUrl,  String livekitRoomId,  FriendCallStatus callStatus, @JsonKey(name: "\$id", includeToJson: false)  String docId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendCallModel() when $default != null:
return $default(_that.callerName,_that.recieverName,_that.callerUsername,_that.recieverUsername,_that.callerUid,_that.recieverUid,_that.callerProfileImageUrl,_that.recieverProfileImageUrl,_that.livekitRoomId,_that.callStatus,_that.docId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callerName,  String recieverName,  String callerUsername,  String recieverUsername,  String callerUid,  String recieverUid,  String callerProfileImageUrl,  String recieverProfileImageUrl,  String livekitRoomId,  FriendCallStatus callStatus, @JsonKey(name: "\$id", includeToJson: false)  String docId)  $default,) {final _that = this;
switch (_that) {
case _FriendCallModel():
return $default(_that.callerName,_that.recieverName,_that.callerUsername,_that.recieverUsername,_that.callerUid,_that.recieverUid,_that.callerProfileImageUrl,_that.recieverProfileImageUrl,_that.livekitRoomId,_that.callStatus,_that.docId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callerName,  String recieverName,  String callerUsername,  String recieverUsername,  String callerUid,  String recieverUid,  String callerProfileImageUrl,  String recieverProfileImageUrl,  String livekitRoomId,  FriendCallStatus callStatus, @JsonKey(name: "\$id", includeToJson: false)  String docId)?  $default,) {final _that = this;
switch (_that) {
case _FriendCallModel() when $default != null:
return $default(_that.callerName,_that.recieverName,_that.callerUsername,_that.recieverUsername,_that.callerUid,_that.recieverUid,_that.callerProfileImageUrl,_that.recieverProfileImageUrl,_that.livekitRoomId,_that.callStatus,_that.docId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendCallModel implements FriendCallModel {
   _FriendCallModel({required this.callerName, required this.recieverName, required this.callerUsername, required this.recieverUsername, required this.callerUid, required this.recieverUid, required this.callerProfileImageUrl, required this.recieverProfileImageUrl, required this.livekitRoomId, required this.callStatus, @JsonKey(name: "\$id", includeToJson: false) required this.docId});
  factory _FriendCallModel.fromJson(Map<String, dynamic> json) => _$FriendCallModelFromJson(json);

@override final  String callerName;
@override final  String recieverName;
@override final  String callerUsername;
@override final  String recieverUsername;
@override final  String callerUid;
@override final  String recieverUid;
@override final  String callerProfileImageUrl;
@override final  String recieverProfileImageUrl;
@override final  String livekitRoomId;
@override final  FriendCallStatus callStatus;
@override@JsonKey(name: "\$id", includeToJson: false) final  String docId;

/// Create a copy of FriendCallModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendCallModelCopyWith<_FriendCallModel> get copyWith => __$FriendCallModelCopyWithImpl<_FriendCallModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendCallModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendCallModel&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.recieverName, recieverName) || other.recieverName == recieverName)&&(identical(other.callerUsername, callerUsername) || other.callerUsername == callerUsername)&&(identical(other.recieverUsername, recieverUsername) || other.recieverUsername == recieverUsername)&&(identical(other.callerUid, callerUid) || other.callerUid == callerUid)&&(identical(other.recieverUid, recieverUid) || other.recieverUid == recieverUid)&&(identical(other.callerProfileImageUrl, callerProfileImageUrl) || other.callerProfileImageUrl == callerProfileImageUrl)&&(identical(other.recieverProfileImageUrl, recieverProfileImageUrl) || other.recieverProfileImageUrl == recieverProfileImageUrl)&&(identical(other.livekitRoomId, livekitRoomId) || other.livekitRoomId == livekitRoomId)&&(identical(other.callStatus, callStatus) || other.callStatus == callStatus)&&(identical(other.docId, docId) || other.docId == docId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callerName,recieverName,callerUsername,recieverUsername,callerUid,recieverUid,callerProfileImageUrl,recieverProfileImageUrl,livekitRoomId,callStatus,docId);

@override
String toString() {
  return 'FriendCallModel(callerName: $callerName, recieverName: $recieverName, callerUsername: $callerUsername, recieverUsername: $recieverUsername, callerUid: $callerUid, recieverUid: $recieverUid, callerProfileImageUrl: $callerProfileImageUrl, recieverProfileImageUrl: $recieverProfileImageUrl, livekitRoomId: $livekitRoomId, callStatus: $callStatus, docId: $docId)';
}


}

/// @nodoc
abstract mixin class _$FriendCallModelCopyWith<$Res> implements $FriendCallModelCopyWith<$Res> {
  factory _$FriendCallModelCopyWith(_FriendCallModel value, $Res Function(_FriendCallModel) _then) = __$FriendCallModelCopyWithImpl;
@override @useResult
$Res call({
 String callerName, String recieverName, String callerUsername, String recieverUsername, String callerUid, String recieverUid, String callerProfileImageUrl, String recieverProfileImageUrl, String livekitRoomId, FriendCallStatus callStatus,@JsonKey(name: "\$id", includeToJson: false) String docId
});




}
/// @nodoc
class __$FriendCallModelCopyWithImpl<$Res>
    implements _$FriendCallModelCopyWith<$Res> {
  __$FriendCallModelCopyWithImpl(this._self, this._then);

  final _FriendCallModel _self;
  final $Res Function(_FriendCallModel) _then;

/// Create a copy of FriendCallModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callerName = null,Object? recieverName = null,Object? callerUsername = null,Object? recieverUsername = null,Object? callerUid = null,Object? recieverUid = null,Object? callerProfileImageUrl = null,Object? recieverProfileImageUrl = null,Object? livekitRoomId = null,Object? callStatus = null,Object? docId = null,}) {
  return _then(_FriendCallModel(
callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,recieverName: null == recieverName ? _self.recieverName : recieverName // ignore: cast_nullable_to_non_nullable
as String,callerUsername: null == callerUsername ? _self.callerUsername : callerUsername // ignore: cast_nullable_to_non_nullable
as String,recieverUsername: null == recieverUsername ? _self.recieverUsername : recieverUsername // ignore: cast_nullable_to_non_nullable
as String,callerUid: null == callerUid ? _self.callerUid : callerUid // ignore: cast_nullable_to_non_nullable
as String,recieverUid: null == recieverUid ? _self.recieverUid : recieverUid // ignore: cast_nullable_to_non_nullable
as String,callerProfileImageUrl: null == callerProfileImageUrl ? _self.callerProfileImageUrl : callerProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String,recieverProfileImageUrl: null == recieverProfileImageUrl ? _self.recieverProfileImageUrl : recieverProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String,livekitRoomId: null == livekitRoomId ? _self.livekitRoomId : livekitRoomId // ignore: cast_nullable_to_non_nullable
as String,callStatus: null == callStatus ? _self.callStatus : callStatus // ignore: cast_nullable_to_non_nullable
as FriendCallStatus,docId: null == docId ? _self.docId : docId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
