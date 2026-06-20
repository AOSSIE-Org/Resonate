// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../story_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StorySearchState {

 List<Story> get stories; List<ResonateUser> get users;
/// Create a copy of StorySearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorySearchStateCopyWith<StorySearchState> get copyWith => _$StorySearchStateCopyWithImpl<StorySearchState>(this as StorySearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorySearchState&&const DeepCollectionEquality().equals(other.stories, stories)&&const DeepCollectionEquality().equals(other.users, users));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(stories),const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'StorySearchState(stories: $stories, users: $users)';
}


}

/// @nodoc
abstract mixin class $StorySearchStateCopyWith<$Res>  {
  factory $StorySearchStateCopyWith(StorySearchState value, $Res Function(StorySearchState) _then) = _$StorySearchStateCopyWithImpl;
@useResult
$Res call({
 List<Story> stories, List<ResonateUser> users
});




}
/// @nodoc
class _$StorySearchStateCopyWithImpl<$Res>
    implements $StorySearchStateCopyWith<$Res> {
  _$StorySearchStateCopyWithImpl(this._self, this._then);

  final StorySearchState _self;
  final $Res Function(StorySearchState) _then;

/// Create a copy of StorySearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stories = null,Object? users = null,}) {
  return _then(_self.copyWith(
stories: null == stories ? _self.stories : stories // ignore: cast_nullable_to_non_nullable
as List<Story>,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<ResonateUser>,
  ));
}

}


/// Adds pattern-matching-related methods to [StorySearchState].
extension StorySearchStatePatterns on StorySearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorySearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorySearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorySearchState value)  $default,){
final _that = this;
switch (_that) {
case _StorySearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorySearchState value)?  $default,){
final _that = this;
switch (_that) {
case _StorySearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Story> stories,  List<ResonateUser> users)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorySearchState() when $default != null:
return $default(_that.stories,_that.users);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Story> stories,  List<ResonateUser> users)  $default,) {final _that = this;
switch (_that) {
case _StorySearchState():
return $default(_that.stories,_that.users);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Story> stories,  List<ResonateUser> users)?  $default,) {final _that = this;
switch (_that) {
case _StorySearchState() when $default != null:
return $default(_that.stories,_that.users);case _:
  return null;

}
}

}

/// @nodoc


class _StorySearchState implements StorySearchState {
  const _StorySearchState({final  List<Story> stories = const <Story>[], final  List<ResonateUser> users = const <ResonateUser>[]}): _stories = stories,_users = users;
  

 final  List<Story> _stories;
@override@JsonKey() List<Story> get stories {
  if (_stories is EqualUnmodifiableListView) return _stories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stories);
}

 final  List<ResonateUser> _users;
@override@JsonKey() List<ResonateUser> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of StorySearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorySearchStateCopyWith<_StorySearchState> get copyWith => __$StorySearchStateCopyWithImpl<_StorySearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorySearchState&&const DeepCollectionEquality().equals(other._stories, _stories)&&const DeepCollectionEquality().equals(other._users, _users));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_stories),const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'StorySearchState(stories: $stories, users: $users)';
}


}

/// @nodoc
abstract mixin class _$StorySearchStateCopyWith<$Res> implements $StorySearchStateCopyWith<$Res> {
  factory _$StorySearchStateCopyWith(_StorySearchState value, $Res Function(_StorySearchState) _then) = __$StorySearchStateCopyWithImpl;
@override @useResult
$Res call({
 List<Story> stories, List<ResonateUser> users
});




}
/// @nodoc
class __$StorySearchStateCopyWithImpl<$Res>
    implements _$StorySearchStateCopyWith<$Res> {
  __$StorySearchStateCopyWithImpl(this._self, this._then);

  final _StorySearchState _self;
  final $Res Function(_StorySearchState) _then;

/// Create a copy of StorySearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stories = null,Object? users = null,}) {
  return _then(_StorySearchState(
stories: null == stories ? _self._stories : stories // ignore: cast_nullable_to_non_nullable
as List<Story>,users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<ResonateUser>,
  ));
}


}

// dart format on
