// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../auth_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthUser {

 String get uid; String get email; String get displayName; bool get isEmailVerified; bool get isProfileComplete; String? get userName; String? get profileImageUrl; String? get profileImageID; double get ratingTotal; int get ratingCount; List<FollowerUserModel> get followers; int get reportsCount;
/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUserCopyWith<AuthUser> get copyWith => _$AuthUserCopyWithImpl<AuthUser>(this as AuthUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.profileImageID, profileImageID) || other.profileImageID == profileImageID)&&(identical(other.ratingTotal, ratingTotal) || other.ratingTotal == ratingTotal)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&const DeepCollectionEquality().equals(other.followers, followers)&&(identical(other.reportsCount, reportsCount) || other.reportsCount == reportsCount));
}


@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,isEmailVerified,isProfileComplete,userName,profileImageUrl,profileImageID,ratingTotal,ratingCount,const DeepCollectionEquality().hash(followers),reportsCount);

@override
String toString() {
  return 'AuthUser(uid: $uid, email: $email, displayName: $displayName, isEmailVerified: $isEmailVerified, isProfileComplete: $isProfileComplete, userName: $userName, profileImageUrl: $profileImageUrl, profileImageID: $profileImageID, ratingTotal: $ratingTotal, ratingCount: $ratingCount, followers: $followers, reportsCount: $reportsCount)';
}


}

/// @nodoc
abstract mixin class $AuthUserCopyWith<$Res>  {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) _then) = _$AuthUserCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String displayName, bool isEmailVerified, bool isProfileComplete, String? userName, String? profileImageUrl, String? profileImageID, double ratingTotal, int ratingCount, List<FollowerUserModel> followers, int reportsCount
});




}
/// @nodoc
class _$AuthUserCopyWithImpl<$Res>
    implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._self, this._then);

  final AuthUser _self;
  final $Res Function(AuthUser) _then;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? isEmailVerified = null,Object? isProfileComplete = null,Object? userName = freezed,Object? profileImageUrl = freezed,Object? profileImageID = freezed,Object? ratingTotal = null,Object? ratingCount = null,Object? followers = null,Object? reportsCount = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,profileImageID: freezed == profileImageID ? _self.profileImageID : profileImageID // ignore: cast_nullable_to_non_nullable
as String?,ratingTotal: null == ratingTotal ? _self.ratingTotal : ratingTotal // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as List<FollowerUserModel>,reportsCount: null == reportsCount ? _self.reportsCount : reportsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthUser].
extension AuthUserPatterns on AuthUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthUser value)  $default,){
final _that = this;
switch (_that) {
case _AuthUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthUser value)?  $default,){
final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String displayName,  bool isEmailVerified,  bool isProfileComplete,  String? userName,  String? profileImageUrl,  String? profileImageID,  double ratingTotal,  int ratingCount,  List<FollowerUserModel> followers,  int reportsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.isEmailVerified,_that.isProfileComplete,_that.userName,_that.profileImageUrl,_that.profileImageID,_that.ratingTotal,_that.ratingCount,_that.followers,_that.reportsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String displayName,  bool isEmailVerified,  bool isProfileComplete,  String? userName,  String? profileImageUrl,  String? profileImageID,  double ratingTotal,  int ratingCount,  List<FollowerUserModel> followers,  int reportsCount)  $default,) {final _that = this;
switch (_that) {
case _AuthUser():
return $default(_that.uid,_that.email,_that.displayName,_that.isEmailVerified,_that.isProfileComplete,_that.userName,_that.profileImageUrl,_that.profileImageID,_that.ratingTotal,_that.ratingCount,_that.followers,_that.reportsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String displayName,  bool isEmailVerified,  bool isProfileComplete,  String? userName,  String? profileImageUrl,  String? profileImageID,  double ratingTotal,  int ratingCount,  List<FollowerUserModel> followers,  int reportsCount)?  $default,) {final _that = this;
switch (_that) {
case _AuthUser() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.isEmailVerified,_that.isProfileComplete,_that.userName,_that.profileImageUrl,_that.profileImageID,_that.ratingTotal,_that.ratingCount,_that.followers,_that.reportsCount);case _:
  return null;

}
}

}

/// @nodoc


class _AuthUser implements AuthUser {
  const _AuthUser({required this.uid, required this.email, required this.displayName, required this.isEmailVerified, required this.isProfileComplete, this.userName, this.profileImageUrl, this.profileImageID, this.ratingTotal = 5.0, this.ratingCount = 1, final  List<FollowerUserModel> followers = const <FollowerUserModel>[], this.reportsCount = 0}): _followers = followers;
  

@override final  String uid;
@override final  String email;
@override final  String displayName;
@override final  bool isEmailVerified;
@override final  bool isProfileComplete;
@override final  String? userName;
@override final  String? profileImageUrl;
@override final  String? profileImageID;
@override@JsonKey() final  double ratingTotal;
@override@JsonKey() final  int ratingCount;
 final  List<FollowerUserModel> _followers;
@override@JsonKey() List<FollowerUserModel> get followers {
  if (_followers is EqualUnmodifiableListView) return _followers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followers);
}

@override@JsonKey() final  int reportsCount;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthUserCopyWith<_AuthUser> get copyWith => __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified)&&(identical(other.isProfileComplete, isProfileComplete) || other.isProfileComplete == isProfileComplete)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.profileImageID, profileImageID) || other.profileImageID == profileImageID)&&(identical(other.ratingTotal, ratingTotal) || other.ratingTotal == ratingTotal)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&const DeepCollectionEquality().equals(other._followers, _followers)&&(identical(other.reportsCount, reportsCount) || other.reportsCount == reportsCount));
}


@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,isEmailVerified,isProfileComplete,userName,profileImageUrl,profileImageID,ratingTotal,ratingCount,const DeepCollectionEquality().hash(_followers),reportsCount);

@override
String toString() {
  return 'AuthUser(uid: $uid, email: $email, displayName: $displayName, isEmailVerified: $isEmailVerified, isProfileComplete: $isProfileComplete, userName: $userName, profileImageUrl: $profileImageUrl, profileImageID: $profileImageID, ratingTotal: $ratingTotal, ratingCount: $ratingCount, followers: $followers, reportsCount: $reportsCount)';
}


}

/// @nodoc
abstract mixin class _$AuthUserCopyWith<$Res> implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) _then) = __$AuthUserCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String displayName, bool isEmailVerified, bool isProfileComplete, String? userName, String? profileImageUrl, String? profileImageID, double ratingTotal, int ratingCount, List<FollowerUserModel> followers, int reportsCount
});




}
/// @nodoc
class __$AuthUserCopyWithImpl<$Res>
    implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(this._self, this._then);

  final _AuthUser _self;
  final $Res Function(_AuthUser) _then;

/// Create a copy of AuthUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? isEmailVerified = null,Object? isProfileComplete = null,Object? userName = freezed,Object? profileImageUrl = freezed,Object? profileImageID = freezed,Object? ratingTotal = null,Object? ratingCount = null,Object? followers = null,Object? reportsCount = null,}) {
  return _then(_AuthUser(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,isProfileComplete: null == isProfileComplete ? _self.isProfileComplete : isProfileComplete // ignore: cast_nullable_to_non_nullable
as bool,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,profileImageID: freezed == profileImageID ? _self.profileImageID : profileImageID // ignore: cast_nullable_to_non_nullable
as String?,ratingTotal: null == ratingTotal ? _self.ratingTotal : ratingTotal // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,followers: null == followers ? _self._followers : followers // ignore: cast_nullable_to_non_nullable
as List<FollowerUserModel>,reportsCount: null == reportsCount ? _self.reportsCount : reportsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
