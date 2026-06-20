// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../story_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryDetailState {

 List<Chapter> get chapters; int get likesCount; bool get isLikedByCurrentUser; LiveChapterModel? get liveChapter;
/// Create a copy of StoryDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryDetailStateCopyWith<StoryDetailState> get copyWith => _$StoryDetailStateCopyWithImpl<StoryDetailState>(this as StoryDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryDetailState&&const DeepCollectionEquality().equals(other.chapters, chapters)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.isLikedByCurrentUser, isLikedByCurrentUser) || other.isLikedByCurrentUser == isLikedByCurrentUser)&&(identical(other.liveChapter, liveChapter) || other.liveChapter == liveChapter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(chapters),likesCount,isLikedByCurrentUser,liveChapter);

@override
String toString() {
  return 'StoryDetailState(chapters: $chapters, likesCount: $likesCount, isLikedByCurrentUser: $isLikedByCurrentUser, liveChapter: $liveChapter)';
}


}

/// @nodoc
abstract mixin class $StoryDetailStateCopyWith<$Res>  {
  factory $StoryDetailStateCopyWith(StoryDetailState value, $Res Function(StoryDetailState) _then) = _$StoryDetailStateCopyWithImpl;
@useResult
$Res call({
 List<Chapter> chapters, int likesCount, bool isLikedByCurrentUser, LiveChapterModel? liveChapter
});


$LiveChapterModelCopyWith<$Res>? get liveChapter;

}
/// @nodoc
class _$StoryDetailStateCopyWithImpl<$Res>
    implements $StoryDetailStateCopyWith<$Res> {
  _$StoryDetailStateCopyWithImpl(this._self, this._then);

  final StoryDetailState _self;
  final $Res Function(StoryDetailState) _then;

/// Create a copy of StoryDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chapters = null,Object? likesCount = null,Object? isLikedByCurrentUser = null,Object? liveChapter = freezed,}) {
  return _then(_self.copyWith(
chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,isLikedByCurrentUser: null == isLikedByCurrentUser ? _self.isLikedByCurrentUser : isLikedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,liveChapter: freezed == liveChapter ? _self.liveChapter : liveChapter // ignore: cast_nullable_to_non_nullable
as LiveChapterModel?,
  ));
}
/// Create a copy of StoryDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveChapterModelCopyWith<$Res>? get liveChapter {
    if (_self.liveChapter == null) {
    return null;
  }

  return $LiveChapterModelCopyWith<$Res>(_self.liveChapter!, (value) {
    return _then(_self.copyWith(liveChapter: value));
  });
}
}


/// Adds pattern-matching-related methods to [StoryDetailState].
extension StoryDetailStatePatterns on StoryDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryDetailState value)  $default,){
final _that = this;
switch (_that) {
case _StoryDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _StoryDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Chapter> chapters,  int likesCount,  bool isLikedByCurrentUser,  LiveChapterModel? liveChapter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryDetailState() when $default != null:
return $default(_that.chapters,_that.likesCount,_that.isLikedByCurrentUser,_that.liveChapter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Chapter> chapters,  int likesCount,  bool isLikedByCurrentUser,  LiveChapterModel? liveChapter)  $default,) {final _that = this;
switch (_that) {
case _StoryDetailState():
return $default(_that.chapters,_that.likesCount,_that.isLikedByCurrentUser,_that.liveChapter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Chapter> chapters,  int likesCount,  bool isLikedByCurrentUser,  LiveChapterModel? liveChapter)?  $default,) {final _that = this;
switch (_that) {
case _StoryDetailState() when $default != null:
return $default(_that.chapters,_that.likesCount,_that.isLikedByCurrentUser,_that.liveChapter);case _:
  return null;

}
}

}

/// @nodoc


class _StoryDetailState implements StoryDetailState {
  const _StoryDetailState({final  List<Chapter> chapters = const <Chapter>[], this.likesCount = 0, this.isLikedByCurrentUser = false, this.liveChapter}): _chapters = chapters;
  

 final  List<Chapter> _chapters;
@override@JsonKey() List<Chapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}

@override@JsonKey() final  int likesCount;
@override@JsonKey() final  bool isLikedByCurrentUser;
@override final  LiveChapterModel? liveChapter;

/// Create a copy of StoryDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryDetailStateCopyWith<_StoryDetailState> get copyWith => __$StoryDetailStateCopyWithImpl<_StoryDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryDetailState&&const DeepCollectionEquality().equals(other._chapters, _chapters)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.isLikedByCurrentUser, isLikedByCurrentUser) || other.isLikedByCurrentUser == isLikedByCurrentUser)&&(identical(other.liveChapter, liveChapter) || other.liveChapter == liveChapter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_chapters),likesCount,isLikedByCurrentUser,liveChapter);

@override
String toString() {
  return 'StoryDetailState(chapters: $chapters, likesCount: $likesCount, isLikedByCurrentUser: $isLikedByCurrentUser, liveChapter: $liveChapter)';
}


}

/// @nodoc
abstract mixin class _$StoryDetailStateCopyWith<$Res> implements $StoryDetailStateCopyWith<$Res> {
  factory _$StoryDetailStateCopyWith(_StoryDetailState value, $Res Function(_StoryDetailState) _then) = __$StoryDetailStateCopyWithImpl;
@override @useResult
$Res call({
 List<Chapter> chapters, int likesCount, bool isLikedByCurrentUser, LiveChapterModel? liveChapter
});


@override $LiveChapterModelCopyWith<$Res>? get liveChapter;

}
/// @nodoc
class __$StoryDetailStateCopyWithImpl<$Res>
    implements _$StoryDetailStateCopyWith<$Res> {
  __$StoryDetailStateCopyWithImpl(this._self, this._then);

  final _StoryDetailState _self;
  final $Res Function(_StoryDetailState) _then;

/// Create a copy of StoryDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chapters = null,Object? likesCount = null,Object? isLikedByCurrentUser = null,Object? liveChapter = freezed,}) {
  return _then(_StoryDetailState(
chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,isLikedByCurrentUser: null == isLikedByCurrentUser ? _self.isLikedByCurrentUser : isLikedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,liveChapter: freezed == liveChapter ? _self.liveChapter : liveChapter // ignore: cast_nullable_to_non_nullable
as LiveChapterModel?,
  ));
}

/// Create a copy of StoryDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveChapterModelCopyWith<$Res>? get liveChapter {
    if (_self.liveChapter == null) {
    return null;
  }

  return $LiveChapterModelCopyWith<$Res>(_self.liveChapter!, (value) {
    return _then(_self.copyWith(liveChapter: value));
  });
}
}

// dart format on
