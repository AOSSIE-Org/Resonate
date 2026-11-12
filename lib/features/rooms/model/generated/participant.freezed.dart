// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Participant {

 String get uid; String get email; String get name; String get dpUrl; bool get isAdmin; bool get isMicOn; bool get isModerator; bool get isSpeaker; bool get hasRequestedToBeSpeaker;
/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantCopyWith<Participant> get copyWith => _$ParticipantCopyWithImpl<Participant>(this as Participant, _$identity);

  /// Serializes this Participant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Participant&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.dpUrl, dpUrl) || other.dpUrl == dpUrl)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isMicOn, isMicOn) || other.isMicOn == isMicOn)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator)&&(identical(other.isSpeaker, isSpeaker) || other.isSpeaker == isSpeaker)&&(identical(other.hasRequestedToBeSpeaker, hasRequestedToBeSpeaker) || other.hasRequestedToBeSpeaker == hasRequestedToBeSpeaker));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,name,dpUrl,isAdmin,isMicOn,isModerator,isSpeaker,hasRequestedToBeSpeaker);

@override
String toString() {
  return 'Participant(uid: $uid, email: $email, name: $name, dpUrl: $dpUrl, isAdmin: $isAdmin, isMicOn: $isMicOn, isModerator: $isModerator, isSpeaker: $isSpeaker, hasRequestedToBeSpeaker: $hasRequestedToBeSpeaker)';
}


}

/// @nodoc
abstract mixin class $ParticipantCopyWith<$Res>  {
  factory $ParticipantCopyWith(Participant value, $Res Function(Participant) _then) = _$ParticipantCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String name, String dpUrl, bool isAdmin, bool isMicOn, bool isModerator, bool isSpeaker, bool hasRequestedToBeSpeaker
});




}
/// @nodoc
class _$ParticipantCopyWithImpl<$Res>
    implements $ParticipantCopyWith<$Res> {
  _$ParticipantCopyWithImpl(this._self, this._then);

  final Participant _self;
  final $Res Function(Participant) _then;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? name = null,Object? dpUrl = null,Object? isAdmin = null,Object? isMicOn = null,Object? isModerator = null,Object? isSpeaker = null,Object? hasRequestedToBeSpeaker = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dpUrl: null == dpUrl ? _self.dpUrl : dpUrl // ignore: cast_nullable_to_non_nullable
as String,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,isMicOn: null == isMicOn ? _self.isMicOn : isMicOn // ignore: cast_nullable_to_non_nullable
as bool,isModerator: null == isModerator ? _self.isModerator : isModerator // ignore: cast_nullable_to_non_nullable
as bool,isSpeaker: null == isSpeaker ? _self.isSpeaker : isSpeaker // ignore: cast_nullable_to_non_nullable
as bool,hasRequestedToBeSpeaker: null == hasRequestedToBeSpeaker ? _self.hasRequestedToBeSpeaker : hasRequestedToBeSpeaker // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Participant].
extension ParticipantPatterns on Participant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Participant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Participant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Participant value)  $default,){
final _that = this;
switch (_that) {
case _Participant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Participant value)?  $default,){
final _that = this;
switch (_that) {
case _Participant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String name,  String dpUrl,  bool isAdmin,  bool isMicOn,  bool isModerator,  bool isSpeaker,  bool hasRequestedToBeSpeaker)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Participant() when $default != null:
return $default(_that.uid,_that.email,_that.name,_that.dpUrl,_that.isAdmin,_that.isMicOn,_that.isModerator,_that.isSpeaker,_that.hasRequestedToBeSpeaker);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String name,  String dpUrl,  bool isAdmin,  bool isMicOn,  bool isModerator,  bool isSpeaker,  bool hasRequestedToBeSpeaker)  $default,) {final _that = this;
switch (_that) {
case _Participant():
return $default(_that.uid,_that.email,_that.name,_that.dpUrl,_that.isAdmin,_that.isMicOn,_that.isModerator,_that.isSpeaker,_that.hasRequestedToBeSpeaker);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String name,  String dpUrl,  bool isAdmin,  bool isMicOn,  bool isModerator,  bool isSpeaker,  bool hasRequestedToBeSpeaker)?  $default,) {final _that = this;
switch (_that) {
case _Participant() when $default != null:
return $default(_that.uid,_that.email,_that.name,_that.dpUrl,_that.isAdmin,_that.isMicOn,_that.isModerator,_that.isSpeaker,_that.hasRequestedToBeSpeaker);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Participant implements Participant {
  const _Participant({required this.uid, required this.email, required this.name, required this.dpUrl, required this.isAdmin, required this.isMicOn, required this.isModerator, required this.isSpeaker, required this.hasRequestedToBeSpeaker});
  factory _Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);

@override final  String uid;
@override final  String email;
@override final  String name;
@override final  String dpUrl;
@override final  bool isAdmin;
@override final  bool isMicOn;
@override final  bool isModerator;
@override final  bool isSpeaker;
@override final  bool hasRequestedToBeSpeaker;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipantCopyWith<_Participant> get copyWith => __$ParticipantCopyWithImpl<_Participant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Participant&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.dpUrl, dpUrl) || other.dpUrl == dpUrl)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.isMicOn, isMicOn) || other.isMicOn == isMicOn)&&(identical(other.isModerator, isModerator) || other.isModerator == isModerator)&&(identical(other.isSpeaker, isSpeaker) || other.isSpeaker == isSpeaker)&&(identical(other.hasRequestedToBeSpeaker, hasRequestedToBeSpeaker) || other.hasRequestedToBeSpeaker == hasRequestedToBeSpeaker));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,name,dpUrl,isAdmin,isMicOn,isModerator,isSpeaker,hasRequestedToBeSpeaker);

@override
String toString() {
  return 'Participant(uid: $uid, email: $email, name: $name, dpUrl: $dpUrl, isAdmin: $isAdmin, isMicOn: $isMicOn, isModerator: $isModerator, isSpeaker: $isSpeaker, hasRequestedToBeSpeaker: $hasRequestedToBeSpeaker)';
}


}

/// @nodoc
abstract mixin class _$ParticipantCopyWith<$Res> implements $ParticipantCopyWith<$Res> {
  factory _$ParticipantCopyWith(_Participant value, $Res Function(_Participant) _then) = __$ParticipantCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String name, String dpUrl, bool isAdmin, bool isMicOn, bool isModerator, bool isSpeaker, bool hasRequestedToBeSpeaker
});




}
/// @nodoc
class __$ParticipantCopyWithImpl<$Res>
    implements _$ParticipantCopyWith<$Res> {
  __$ParticipantCopyWithImpl(this._self, this._then);

  final _Participant _self;
  final $Res Function(_Participant) _then;

/// Create a copy of Participant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? name = null,Object? dpUrl = null,Object? isAdmin = null,Object? isMicOn = null,Object? isModerator = null,Object? isSpeaker = null,Object? hasRequestedToBeSpeaker = null,}) {
  return _then(_Participant(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dpUrl: null == dpUrl ? _self.dpUrl : dpUrl // ignore: cast_nullable_to_non_nullable
as String,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,isMicOn: null == isMicOn ? _self.isMicOn : isMicOn // ignore: cast_nullable_to_non_nullable
as bool,isModerator: null == isModerator ? _self.isModerator : isModerator // ignore: cast_nullable_to_non_nullable
as bool,isSpeaker: null == isSpeaker ? _self.isSpeaker : isSpeaker // ignore: cast_nullable_to_non_nullable
as bool,hasRequestedToBeSpeaker: null == hasRequestedToBeSpeaker ? _self.hasRequestedToBeSpeaker : hasRequestedToBeSpeaker // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
