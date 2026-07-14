// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../appwrite_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppwriteRoom {

 String get id; String get name; String get description; int get totalParticipants; List<String> get tags; List<String> get memberAvatarUrls; RoomState get state; bool get isUserAdmin; List<String> get reportedUsers; String? get myDocId;
/// Create a copy of AppwriteRoom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppwriteRoomCopyWith<AppwriteRoom> get copyWith => _$AppwriteRoomCopyWithImpl<AppwriteRoom>(this as AppwriteRoom, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppwriteRoom&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.memberAvatarUrls, memberAvatarUrls)&&(identical(other.state, state) || other.state == state)&&(identical(other.isUserAdmin, isUserAdmin) || other.isUserAdmin == isUserAdmin)&&const DeepCollectionEquality().equals(other.reportedUsers, reportedUsers)&&(identical(other.myDocId, myDocId) || other.myDocId == myDocId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,totalParticipants,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(memberAvatarUrls),state,isUserAdmin,const DeepCollectionEquality().hash(reportedUsers),myDocId);

@override
String toString() {
  return 'AppwriteRoom(id: $id, name: $name, description: $description, totalParticipants: $totalParticipants, tags: $tags, memberAvatarUrls: $memberAvatarUrls, state: $state, isUserAdmin: $isUserAdmin, reportedUsers: $reportedUsers, myDocId: $myDocId)';
}


}

/// @nodoc
abstract mixin class $AppwriteRoomCopyWith<$Res>  {
  factory $AppwriteRoomCopyWith(AppwriteRoom value, $Res Function(AppwriteRoom) _then) = _$AppwriteRoomCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, int totalParticipants, List<String> tags, List<String> memberAvatarUrls, RoomState state, bool isUserAdmin, List<String> reportedUsers, String? myDocId
});




}
/// @nodoc
class _$AppwriteRoomCopyWithImpl<$Res>
    implements $AppwriteRoomCopyWith<$Res> {
  _$AppwriteRoomCopyWithImpl(this._self, this._then);

  final AppwriteRoom _self;
  final $Res Function(AppwriteRoom) _then;

/// Create a copy of AppwriteRoom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? totalParticipants = null,Object? tags = null,Object? memberAvatarUrls = null,Object? state = null,Object? isUserAdmin = null,Object? reportedUsers = null,Object? myDocId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,memberAvatarUrls: null == memberAvatarUrls ? _self.memberAvatarUrls : memberAvatarUrls // ignore: cast_nullable_to_non_nullable
as List<String>,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as RoomState,isUserAdmin: null == isUserAdmin ? _self.isUserAdmin : isUserAdmin // ignore: cast_nullable_to_non_nullable
as bool,reportedUsers: null == reportedUsers ? _self.reportedUsers : reportedUsers // ignore: cast_nullable_to_non_nullable
as List<String>,myDocId: freezed == myDocId ? _self.myDocId : myDocId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppwriteRoom].
extension AppwriteRoomPatterns on AppwriteRoom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppwriteRoom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppwriteRoom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppwriteRoom value)  $default,){
final _that = this;
switch (_that) {
case _AppwriteRoom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppwriteRoom value)?  $default,){
final _that = this;
switch (_that) {
case _AppwriteRoom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int totalParticipants,  List<String> tags,  List<String> memberAvatarUrls,  RoomState state,  bool isUserAdmin,  List<String> reportedUsers,  String? myDocId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppwriteRoom() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.totalParticipants,_that.tags,_that.memberAvatarUrls,_that.state,_that.isUserAdmin,_that.reportedUsers,_that.myDocId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int totalParticipants,  List<String> tags,  List<String> memberAvatarUrls,  RoomState state,  bool isUserAdmin,  List<String> reportedUsers,  String? myDocId)  $default,) {final _that = this;
switch (_that) {
case _AppwriteRoom():
return $default(_that.id,_that.name,_that.description,_that.totalParticipants,_that.tags,_that.memberAvatarUrls,_that.state,_that.isUserAdmin,_that.reportedUsers,_that.myDocId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  int totalParticipants,  List<String> tags,  List<String> memberAvatarUrls,  RoomState state,  bool isUserAdmin,  List<String> reportedUsers,  String? myDocId)?  $default,) {final _that = this;
switch (_that) {
case _AppwriteRoom() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.totalParticipants,_that.tags,_that.memberAvatarUrls,_that.state,_that.isUserAdmin,_that.reportedUsers,_that.myDocId);case _:
  return null;

}
}

}

/// @nodoc


class _AppwriteRoom implements AppwriteRoom {
  const _AppwriteRoom({required this.id, required this.name, required this.description, required this.totalParticipants, required final  List<String> tags, required final  List<String> memberAvatarUrls, required this.state, required this.isUserAdmin, final  List<String> reportedUsers = const <String>[], this.myDocId}): _tags = tags,_memberAvatarUrls = memberAvatarUrls,_reportedUsers = reportedUsers;
  

@override final  String id;
@override final  String name;
@override final  String description;
@override final  int totalParticipants;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<String> _memberAvatarUrls;
@override List<String> get memberAvatarUrls {
  if (_memberAvatarUrls is EqualUnmodifiableListView) return _memberAvatarUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberAvatarUrls);
}

@override final  RoomState state;
@override final  bool isUserAdmin;
 final  List<String> _reportedUsers;
@override@JsonKey() List<String> get reportedUsers {
  if (_reportedUsers is EqualUnmodifiableListView) return _reportedUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reportedUsers);
}

@override final  String? myDocId;

/// Create a copy of AppwriteRoom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppwriteRoomCopyWith<_AppwriteRoom> get copyWith => __$AppwriteRoomCopyWithImpl<_AppwriteRoom>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppwriteRoom&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._memberAvatarUrls, _memberAvatarUrls)&&(identical(other.state, state) || other.state == state)&&(identical(other.isUserAdmin, isUserAdmin) || other.isUserAdmin == isUserAdmin)&&const DeepCollectionEquality().equals(other._reportedUsers, _reportedUsers)&&(identical(other.myDocId, myDocId) || other.myDocId == myDocId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,totalParticipants,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_memberAvatarUrls),state,isUserAdmin,const DeepCollectionEquality().hash(_reportedUsers),myDocId);

@override
String toString() {
  return 'AppwriteRoom(id: $id, name: $name, description: $description, totalParticipants: $totalParticipants, tags: $tags, memberAvatarUrls: $memberAvatarUrls, state: $state, isUserAdmin: $isUserAdmin, reportedUsers: $reportedUsers, myDocId: $myDocId)';
}


}

/// @nodoc
abstract mixin class _$AppwriteRoomCopyWith<$Res> implements $AppwriteRoomCopyWith<$Res> {
  factory _$AppwriteRoomCopyWith(_AppwriteRoom value, $Res Function(_AppwriteRoom) _then) = __$AppwriteRoomCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, int totalParticipants, List<String> tags, List<String> memberAvatarUrls, RoomState state, bool isUserAdmin, List<String> reportedUsers, String? myDocId
});




}
/// @nodoc
class __$AppwriteRoomCopyWithImpl<$Res>
    implements _$AppwriteRoomCopyWith<$Res> {
  __$AppwriteRoomCopyWithImpl(this._self, this._then);

  final _AppwriteRoom _self;
  final $Res Function(_AppwriteRoom) _then;

/// Create a copy of AppwriteRoom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? totalParticipants = null,Object? tags = null,Object? memberAvatarUrls = null,Object? state = null,Object? isUserAdmin = null,Object? reportedUsers = null,Object? myDocId = freezed,}) {
  return _then(_AppwriteRoom(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,memberAvatarUrls: null == memberAvatarUrls ? _self._memberAvatarUrls : memberAvatarUrls // ignore: cast_nullable_to_non_nullable
as List<String>,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as RoomState,isUserAdmin: null == isUserAdmin ? _self.isUserAdmin : isUserAdmin // ignore: cast_nullable_to_non_nullable
as bool,reportedUsers: null == reportedUsers ? _self._reportedUsers : reportedUsers // ignore: cast_nullable_to_non_nullable
as List<String>,myDocId: freezed == myDocId ? _self.myDocId : myDocId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
