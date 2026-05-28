// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../reply_to.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReplyTo {

 String get messageId; String get creatorUsername; String get creatorImgUrl; int get index; String get content;
/// Create a copy of ReplyTo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplyToCopyWith<ReplyTo> get copyWith => _$ReplyToCopyWithImpl<ReplyTo>(this as ReplyTo, _$identity);

  /// Serializes this ReplyTo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplyTo&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.creatorUsername, creatorUsername) || other.creatorUsername == creatorUsername)&&(identical(other.creatorImgUrl, creatorImgUrl) || other.creatorImgUrl == creatorImgUrl)&&(identical(other.index, index) || other.index == index)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,creatorUsername,creatorImgUrl,index,content);

@override
String toString() {
  return 'ReplyTo(messageId: $messageId, creatorUsername: $creatorUsername, creatorImgUrl: $creatorImgUrl, index: $index, content: $content)';
}


}

/// @nodoc
abstract mixin class $ReplyToCopyWith<$Res>  {
  factory $ReplyToCopyWith(ReplyTo value, $Res Function(ReplyTo) _then) = _$ReplyToCopyWithImpl;
@useResult
$Res call({
 String messageId, String creatorUsername, String creatorImgUrl, int index, String content
});




}
/// @nodoc
class _$ReplyToCopyWithImpl<$Res>
    implements $ReplyToCopyWith<$Res> {
  _$ReplyToCopyWithImpl(this._self, this._then);

  final ReplyTo _self;
  final $Res Function(ReplyTo) _then;

/// Create a copy of ReplyTo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? creatorUsername = null,Object? creatorImgUrl = null,Object? index = null,Object? content = null,}) {
  return _then(_self.copyWith(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,creatorUsername: null == creatorUsername ? _self.creatorUsername : creatorUsername // ignore: cast_nullable_to_non_nullable
as String,creatorImgUrl: null == creatorImgUrl ? _self.creatorImgUrl : creatorImgUrl // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReplyTo].
extension ReplyToPatterns on ReplyTo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReplyTo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReplyTo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReplyTo value)  $default,){
final _that = this;
switch (_that) {
case _ReplyTo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReplyTo value)?  $default,){
final _that = this;
switch (_that) {
case _ReplyTo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String messageId,  String creatorUsername,  String creatorImgUrl,  int index,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReplyTo() when $default != null:
return $default(_that.messageId,_that.creatorUsername,_that.creatorImgUrl,_that.index,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String messageId,  String creatorUsername,  String creatorImgUrl,  int index,  String content)  $default,) {final _that = this;
switch (_that) {
case _ReplyTo():
return $default(_that.messageId,_that.creatorUsername,_that.creatorImgUrl,_that.index,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String messageId,  String creatorUsername,  String creatorImgUrl,  int index,  String content)?  $default,) {final _that = this;
switch (_that) {
case _ReplyTo() when $default != null:
return $default(_that.messageId,_that.creatorUsername,_that.creatorImgUrl,_that.index,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReplyTo implements ReplyTo {
  const _ReplyTo({required this.messageId, required this.creatorUsername, required this.creatorImgUrl, required this.index, required this.content});
  factory _ReplyTo.fromJson(Map<String, dynamic> json) => _$ReplyToFromJson(json);

@override final  String messageId;
@override final  String creatorUsername;
@override final  String creatorImgUrl;
@override final  int index;
@override final  String content;

/// Create a copy of ReplyTo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplyToCopyWith<_ReplyTo> get copyWith => __$ReplyToCopyWithImpl<_ReplyTo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReplyToToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplyTo&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.creatorUsername, creatorUsername) || other.creatorUsername == creatorUsername)&&(identical(other.creatorImgUrl, creatorImgUrl) || other.creatorImgUrl == creatorImgUrl)&&(identical(other.index, index) || other.index == index)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageId,creatorUsername,creatorImgUrl,index,content);

@override
String toString() {
  return 'ReplyTo(messageId: $messageId, creatorUsername: $creatorUsername, creatorImgUrl: $creatorImgUrl, index: $index, content: $content)';
}


}

/// @nodoc
abstract mixin class _$ReplyToCopyWith<$Res> implements $ReplyToCopyWith<$Res> {
  factory _$ReplyToCopyWith(_ReplyTo value, $Res Function(_ReplyTo) _then) = __$ReplyToCopyWithImpl;
@override @useResult
$Res call({
 String messageId, String creatorUsername, String creatorImgUrl, int index, String content
});




}
/// @nodoc
class __$ReplyToCopyWithImpl<$Res>
    implements _$ReplyToCopyWith<$Res> {
  __$ReplyToCopyWithImpl(this._self, this._then);

  final _ReplyTo _self;
  final $Res Function(_ReplyTo) _then;

/// Create a copy of ReplyTo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? creatorUsername = null,Object? creatorImgUrl = null,Object? index = null,Object? content = null,}) {
  return _then(_ReplyTo(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,creatorUsername: null == creatorUsername ? _self.creatorUsername : creatorUsername // ignore: cast_nullable_to_non_nullable
as String,creatorImgUrl: null == creatorImgUrl ? _self.creatorImgUrl : creatorImgUrl // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
