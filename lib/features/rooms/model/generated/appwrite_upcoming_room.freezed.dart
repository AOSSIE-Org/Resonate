// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../appwrite_upcoming_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppwriteUpcomingRoom {

 String get id; String get name; bool get isTime; DateTime get scheduledDateTime; String get description; int get totalSubscriberCount; List<String> get tags; List<String> get subscribersAvatarUrls; bool get userIsCreator; bool get hasUserSubscribed;
/// Create a copy of AppwriteUpcomingRoom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppwriteUpcomingRoomCopyWith<AppwriteUpcomingRoom> get copyWith => _$AppwriteUpcomingRoomCopyWithImpl<AppwriteUpcomingRoom>(this as AppwriteUpcomingRoom, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppwriteUpcomingRoom&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isTime, isTime) || other.isTime == isTime)&&(identical(other.scheduledDateTime, scheduledDateTime) || other.scheduledDateTime == scheduledDateTime)&&(identical(other.description, description) || other.description == description)&&(identical(other.totalSubscriberCount, totalSubscriberCount) || other.totalSubscriberCount == totalSubscriberCount)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.subscribersAvatarUrls, subscribersAvatarUrls)&&(identical(other.userIsCreator, userIsCreator) || other.userIsCreator == userIsCreator)&&(identical(other.hasUserSubscribed, hasUserSubscribed) || other.hasUserSubscribed == hasUserSubscribed));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,isTime,scheduledDateTime,description,totalSubscriberCount,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(subscribersAvatarUrls),userIsCreator,hasUserSubscribed);

@override
String toString() {
  return 'AppwriteUpcomingRoom(id: $id, name: $name, isTime: $isTime, scheduledDateTime: $scheduledDateTime, description: $description, totalSubscriberCount: $totalSubscriberCount, tags: $tags, subscribersAvatarUrls: $subscribersAvatarUrls, userIsCreator: $userIsCreator, hasUserSubscribed: $hasUserSubscribed)';
}


}

/// @nodoc
abstract mixin class $AppwriteUpcomingRoomCopyWith<$Res>  {
  factory $AppwriteUpcomingRoomCopyWith(AppwriteUpcomingRoom value, $Res Function(AppwriteUpcomingRoom) _then) = _$AppwriteUpcomingRoomCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool isTime, DateTime scheduledDateTime, String description, int totalSubscriberCount, List<String> tags, List<String> subscribersAvatarUrls, bool userIsCreator, bool hasUserSubscribed
});




}
/// @nodoc
class _$AppwriteUpcomingRoomCopyWithImpl<$Res>
    implements $AppwriteUpcomingRoomCopyWith<$Res> {
  _$AppwriteUpcomingRoomCopyWithImpl(this._self, this._then);

  final AppwriteUpcomingRoom _self;
  final $Res Function(AppwriteUpcomingRoom) _then;

/// Create a copy of AppwriteUpcomingRoom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isTime = null,Object? scheduledDateTime = null,Object? description = null,Object? totalSubscriberCount = null,Object? tags = null,Object? subscribersAvatarUrls = null,Object? userIsCreator = null,Object? hasUserSubscribed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isTime: null == isTime ? _self.isTime : isTime // ignore: cast_nullable_to_non_nullable
as bool,scheduledDateTime: null == scheduledDateTime ? _self.scheduledDateTime : scheduledDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,totalSubscriberCount: null == totalSubscriberCount ? _self.totalSubscriberCount : totalSubscriberCount // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,subscribersAvatarUrls: null == subscribersAvatarUrls ? _self.subscribersAvatarUrls : subscribersAvatarUrls // ignore: cast_nullable_to_non_nullable
as List<String>,userIsCreator: null == userIsCreator ? _self.userIsCreator : userIsCreator // ignore: cast_nullable_to_non_nullable
as bool,hasUserSubscribed: null == hasUserSubscribed ? _self.hasUserSubscribed : hasUserSubscribed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppwriteUpcomingRoom].
extension AppwriteUpcomingRoomPatterns on AppwriteUpcomingRoom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppwriteUpcomingRoom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppwriteUpcomingRoom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppwriteUpcomingRoom value)  $default,){
final _that = this;
switch (_that) {
case _AppwriteUpcomingRoom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppwriteUpcomingRoom value)?  $default,){
final _that = this;
switch (_that) {
case _AppwriteUpcomingRoom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool isTime,  DateTime scheduledDateTime,  String description,  int totalSubscriberCount,  List<String> tags,  List<String> subscribersAvatarUrls,  bool userIsCreator,  bool hasUserSubscribed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppwriteUpcomingRoom() when $default != null:
return $default(_that.id,_that.name,_that.isTime,_that.scheduledDateTime,_that.description,_that.totalSubscriberCount,_that.tags,_that.subscribersAvatarUrls,_that.userIsCreator,_that.hasUserSubscribed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool isTime,  DateTime scheduledDateTime,  String description,  int totalSubscriberCount,  List<String> tags,  List<String> subscribersAvatarUrls,  bool userIsCreator,  bool hasUserSubscribed)  $default,) {final _that = this;
switch (_that) {
case _AppwriteUpcomingRoom():
return $default(_that.id,_that.name,_that.isTime,_that.scheduledDateTime,_that.description,_that.totalSubscriberCount,_that.tags,_that.subscribersAvatarUrls,_that.userIsCreator,_that.hasUserSubscribed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool isTime,  DateTime scheduledDateTime,  String description,  int totalSubscriberCount,  List<String> tags,  List<String> subscribersAvatarUrls,  bool userIsCreator,  bool hasUserSubscribed)?  $default,) {final _that = this;
switch (_that) {
case _AppwriteUpcomingRoom() when $default != null:
return $default(_that.id,_that.name,_that.isTime,_that.scheduledDateTime,_that.description,_that.totalSubscriberCount,_that.tags,_that.subscribersAvatarUrls,_that.userIsCreator,_that.hasUserSubscribed);case _:
  return null;

}
}

}

/// @nodoc


class _AppwriteUpcomingRoom implements AppwriteUpcomingRoom {
  const _AppwriteUpcomingRoom({required this.id, required this.name, required this.isTime, required this.scheduledDateTime, required this.description, required this.totalSubscriberCount, required final  List<String> tags, required final  List<String> subscribersAvatarUrls, required this.userIsCreator, required this.hasUserSubscribed}): _tags = tags,_subscribersAvatarUrls = subscribersAvatarUrls;
  

@override final  String id;
@override final  String name;
@override final  bool isTime;
@override final  DateTime scheduledDateTime;
@override final  String description;
@override final  int totalSubscriberCount;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<String> _subscribersAvatarUrls;
@override List<String> get subscribersAvatarUrls {
  if (_subscribersAvatarUrls is EqualUnmodifiableListView) return _subscribersAvatarUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subscribersAvatarUrls);
}

@override final  bool userIsCreator;
@override final  bool hasUserSubscribed;

/// Create a copy of AppwriteUpcomingRoom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppwriteUpcomingRoomCopyWith<_AppwriteUpcomingRoom> get copyWith => __$AppwriteUpcomingRoomCopyWithImpl<_AppwriteUpcomingRoom>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppwriteUpcomingRoom&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isTime, isTime) || other.isTime == isTime)&&(identical(other.scheduledDateTime, scheduledDateTime) || other.scheduledDateTime == scheduledDateTime)&&(identical(other.description, description) || other.description == description)&&(identical(other.totalSubscriberCount, totalSubscriberCount) || other.totalSubscriberCount == totalSubscriberCount)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._subscribersAvatarUrls, _subscribersAvatarUrls)&&(identical(other.userIsCreator, userIsCreator) || other.userIsCreator == userIsCreator)&&(identical(other.hasUserSubscribed, hasUserSubscribed) || other.hasUserSubscribed == hasUserSubscribed));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,isTime,scheduledDateTime,description,totalSubscriberCount,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_subscribersAvatarUrls),userIsCreator,hasUserSubscribed);

@override
String toString() {
  return 'AppwriteUpcomingRoom(id: $id, name: $name, isTime: $isTime, scheduledDateTime: $scheduledDateTime, description: $description, totalSubscriberCount: $totalSubscriberCount, tags: $tags, subscribersAvatarUrls: $subscribersAvatarUrls, userIsCreator: $userIsCreator, hasUserSubscribed: $hasUserSubscribed)';
}


}

/// @nodoc
abstract mixin class _$AppwriteUpcomingRoomCopyWith<$Res> implements $AppwriteUpcomingRoomCopyWith<$Res> {
  factory _$AppwriteUpcomingRoomCopyWith(_AppwriteUpcomingRoom value, $Res Function(_AppwriteUpcomingRoom) _then) = __$AppwriteUpcomingRoomCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool isTime, DateTime scheduledDateTime, String description, int totalSubscriberCount, List<String> tags, List<String> subscribersAvatarUrls, bool userIsCreator, bool hasUserSubscribed
});




}
/// @nodoc
class __$AppwriteUpcomingRoomCopyWithImpl<$Res>
    implements _$AppwriteUpcomingRoomCopyWith<$Res> {
  __$AppwriteUpcomingRoomCopyWithImpl(this._self, this._then);

  final _AppwriteUpcomingRoom _self;
  final $Res Function(_AppwriteUpcomingRoom) _then;

/// Create a copy of AppwriteUpcomingRoom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isTime = null,Object? scheduledDateTime = null,Object? description = null,Object? totalSubscriberCount = null,Object? tags = null,Object? subscribersAvatarUrls = null,Object? userIsCreator = null,Object? hasUserSubscribed = null,}) {
  return _then(_AppwriteUpcomingRoom(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isTime: null == isTime ? _self.isTime : isTime // ignore: cast_nullable_to_non_nullable
as bool,scheduledDateTime: null == scheduledDateTime ? _self.scheduledDateTime : scheduledDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,totalSubscriberCount: null == totalSubscriberCount ? _self.totalSubscriberCount : totalSubscriberCount // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,subscribersAvatarUrls: null == subscribersAvatarUrls ? _self._subscribersAvatarUrls : subscribersAvatarUrls // ignore: cast_nullable_to_non_nullable
as List<String>,userIsCreator: null == userIsCreator ? _self.userIsCreator : userIsCreator // ignore: cast_nullable_to_non_nullable
as bool,hasUserSubscribed: null == hasUserSubscribed ? _self.hasUserSubscribed : hasUserSubscribed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
