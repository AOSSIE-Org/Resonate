// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_chapter_attendees_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LiveChapterAttendeesModel {

 String get liveChapterId;@JsonKey(includeToJson: false) List<Map<String, dynamic>> get users;@JsonKey(includeFromJson: false, name: "users", includeToJson: true) List<String>? get userIds;
/// Create a copy of LiveChapterAttendeesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveChapterAttendeesModelCopyWith<LiveChapterAttendeesModel> get copyWith => _$LiveChapterAttendeesModelCopyWithImpl<LiveChapterAttendeesModel>(this as LiveChapterAttendeesModel, _$identity);

  /// Serializes this LiveChapterAttendeesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveChapterAttendeesModel&&(identical(other.liveChapterId, liveChapterId) || other.liveChapterId == liveChapterId)&&const DeepCollectionEquality().equals(other.users, users)&&const DeepCollectionEquality().equals(other.userIds, userIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,liveChapterId,const DeepCollectionEquality().hash(users),const DeepCollectionEquality().hash(userIds));

@override
String toString() {
  return 'LiveChapterAttendeesModel(liveChapterId: $liveChapterId, users: $users, userIds: $userIds)';
}


}

/// @nodoc
abstract mixin class $LiveChapterAttendeesModelCopyWith<$Res>  {
  factory $LiveChapterAttendeesModelCopyWith(LiveChapterAttendeesModel value, $Res Function(LiveChapterAttendeesModel) _then) = _$LiveChapterAttendeesModelCopyWithImpl;
@useResult
$Res call({
 String liveChapterId,@JsonKey(includeToJson: false) List<Map<String, dynamic>> users,@JsonKey(includeFromJson: false, name: "users", includeToJson: true) List<String>? userIds
});




}
/// @nodoc
class _$LiveChapterAttendeesModelCopyWithImpl<$Res>
    implements $LiveChapterAttendeesModelCopyWith<$Res> {
  _$LiveChapterAttendeesModelCopyWithImpl(this._self, this._then);

  final LiveChapterAttendeesModel _self;
  final $Res Function(LiveChapterAttendeesModel) _then;

/// Create a copy of LiveChapterAttendeesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? liveChapterId = null,Object? users = null,Object? userIds = freezed,}) {
  return _then(_self.copyWith(
liveChapterId: null == liveChapterId ? _self.liveChapterId : liveChapterId // ignore: cast_nullable_to_non_nullable
as String,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,userIds: freezed == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveChapterAttendeesModel].
extension LiveChapterAttendeesModelPatterns on LiveChapterAttendeesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveChapterAttendeesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveChapterAttendeesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveChapterAttendeesModel value)  $default,){
final _that = this;
switch (_that) {
case _LiveChapterAttendeesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveChapterAttendeesModel value)?  $default,){
final _that = this;
switch (_that) {
case _LiveChapterAttendeesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String liveChapterId, @JsonKey(includeToJson: false)  List<Map<String, dynamic>> users, @JsonKey(includeFromJson: false, name: "users", includeToJson: true)  List<String>? userIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveChapterAttendeesModel() when $default != null:
return $default(_that.liveChapterId,_that.users,_that.userIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String liveChapterId, @JsonKey(includeToJson: false)  List<Map<String, dynamic>> users, @JsonKey(includeFromJson: false, name: "users", includeToJson: true)  List<String>? userIds)  $default,) {final _that = this;
switch (_that) {
case _LiveChapterAttendeesModel():
return $default(_that.liveChapterId,_that.users,_that.userIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String liveChapterId, @JsonKey(includeToJson: false)  List<Map<String, dynamic>> users, @JsonKey(includeFromJson: false, name: "users", includeToJson: true)  List<String>? userIds)?  $default,) {final _that = this;
switch (_that) {
case _LiveChapterAttendeesModel() when $default != null:
return $default(_that.liveChapterId,_that.users,_that.userIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LiveChapterAttendeesModel implements LiveChapterAttendeesModel {
   _LiveChapterAttendeesModel({required this.liveChapterId, @JsonKey(includeToJson: false) required final  List<Map<String, dynamic>> users, @JsonKey(includeFromJson: false, name: "users", includeToJson: true) final  List<String>? userIds}): _users = users,_userIds = userIds;
  factory _LiveChapterAttendeesModel.fromJson(Map<String, dynamic> json) => _$LiveChapterAttendeesModelFromJson(json);

@override final  String liveChapterId;
 final  List<Map<String, dynamic>> _users;
@override@JsonKey(includeToJson: false) List<Map<String, dynamic>> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

 final  List<String>? _userIds;
@override@JsonKey(includeFromJson: false, name: "users", includeToJson: true) List<String>? get userIds {
  final value = _userIds;
  if (value == null) return null;
  if (_userIds is EqualUnmodifiableListView) return _userIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LiveChapterAttendeesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveChapterAttendeesModelCopyWith<_LiveChapterAttendeesModel> get copyWith => __$LiveChapterAttendeesModelCopyWithImpl<_LiveChapterAttendeesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiveChapterAttendeesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveChapterAttendeesModel&&(identical(other.liveChapterId, liveChapterId) || other.liveChapterId == liveChapterId)&&const DeepCollectionEquality().equals(other._users, _users)&&const DeepCollectionEquality().equals(other._userIds, _userIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,liveChapterId,const DeepCollectionEquality().hash(_users),const DeepCollectionEquality().hash(_userIds));

@override
String toString() {
  return 'LiveChapterAttendeesModel(liveChapterId: $liveChapterId, users: $users, userIds: $userIds)';
}


}

/// @nodoc
abstract mixin class _$LiveChapterAttendeesModelCopyWith<$Res> implements $LiveChapterAttendeesModelCopyWith<$Res> {
  factory _$LiveChapterAttendeesModelCopyWith(_LiveChapterAttendeesModel value, $Res Function(_LiveChapterAttendeesModel) _then) = __$LiveChapterAttendeesModelCopyWithImpl;
@override @useResult
$Res call({
 String liveChapterId,@JsonKey(includeToJson: false) List<Map<String, dynamic>> users,@JsonKey(includeFromJson: false, name: "users", includeToJson: true) List<String>? userIds
});




}
/// @nodoc
class __$LiveChapterAttendeesModelCopyWithImpl<$Res>
    implements _$LiveChapterAttendeesModelCopyWith<$Res> {
  __$LiveChapterAttendeesModelCopyWithImpl(this._self, this._then);

  final _LiveChapterAttendeesModel _self;
  final $Res Function(_LiveChapterAttendeesModel) _then;

/// Create a copy of LiveChapterAttendeesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? liveChapterId = null,Object? users = null,Object? userIds = freezed,}) {
  return _then(_LiveChapterAttendeesModel(
liveChapterId: null == liveChapterId ? _self.liveChapterId : liveChapterId // ignore: cast_nullable_to_non_nullable
as String,users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,userIds: freezed == userIds ? _self._userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
