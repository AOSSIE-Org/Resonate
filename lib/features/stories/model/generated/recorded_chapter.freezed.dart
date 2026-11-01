// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../recorded_chapter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecordedChapter {

 String get id; String get title; String get description; String get audioFilePath; int get durationMs; String get transcript;// Stored UTC; the detail view converts it for display.
 DateTime get recordedAt;
/// Create a copy of RecordedChapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordedChapterCopyWith<RecordedChapter> get copyWith => _$RecordedChapterCopyWithImpl<RecordedChapter>(this as RecordedChapter, _$identity);

  /// Serializes this RecordedChapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordedChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.audioFilePath, audioFilePath) || other.audioFilePath == audioFilePath)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,audioFilePath,durationMs,transcript,recordedAt);

@override
String toString() {
  return 'RecordedChapter(id: $id, title: $title, description: $description, audioFilePath: $audioFilePath, durationMs: $durationMs, transcript: $transcript, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $RecordedChapterCopyWith<$Res>  {
  factory $RecordedChapterCopyWith(RecordedChapter value, $Res Function(RecordedChapter) _then) = _$RecordedChapterCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String audioFilePath, int durationMs, String transcript, DateTime recordedAt
});




}
/// @nodoc
class _$RecordedChapterCopyWithImpl<$Res>
    implements $RecordedChapterCopyWith<$Res> {
  _$RecordedChapterCopyWithImpl(this._self, this._then);

  final RecordedChapter _self;
  final $Res Function(RecordedChapter) _then;

/// Create a copy of RecordedChapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? audioFilePath = null,Object? durationMs = null,Object? transcript = null,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,audioFilePath: null == audioFilePath ? _self.audioFilePath : audioFilePath // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordedChapter].
extension RecordedChapterPatterns on RecordedChapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordedChapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordedChapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordedChapter value)  $default,){
final _that = this;
switch (_that) {
case _RecordedChapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordedChapter value)?  $default,){
final _that = this;
switch (_that) {
case _RecordedChapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String audioFilePath,  int durationMs,  String transcript,  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordedChapter() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.audioFilePath,_that.durationMs,_that.transcript,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String audioFilePath,  int durationMs,  String transcript,  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _RecordedChapter():
return $default(_that.id,_that.title,_that.description,_that.audioFilePath,_that.durationMs,_that.transcript,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String audioFilePath,  int durationMs,  String transcript,  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _RecordedChapter() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.audioFilePath,_that.durationMs,_that.transcript,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecordedChapter implements RecordedChapter {
  const _RecordedChapter({required this.id, required this.title, required this.description, required this.audioFilePath, required this.durationMs, required this.transcript, required this.recordedAt});
  factory _RecordedChapter.fromJson(Map<String, dynamic> json) => _$RecordedChapterFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String audioFilePath;
@override final  int durationMs;
@override final  String transcript;
// Stored UTC; the detail view converts it for display.
@override final  DateTime recordedAt;

/// Create a copy of RecordedChapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordedChapterCopyWith<_RecordedChapter> get copyWith => __$RecordedChapterCopyWithImpl<_RecordedChapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecordedChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordedChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.audioFilePath, audioFilePath) || other.audioFilePath == audioFilePath)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,audioFilePath,durationMs,transcript,recordedAt);

@override
String toString() {
  return 'RecordedChapter(id: $id, title: $title, description: $description, audioFilePath: $audioFilePath, durationMs: $durationMs, transcript: $transcript, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$RecordedChapterCopyWith<$Res> implements $RecordedChapterCopyWith<$Res> {
  factory _$RecordedChapterCopyWith(_RecordedChapter value, $Res Function(_RecordedChapter) _then) = __$RecordedChapterCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String audioFilePath, int durationMs, String transcript, DateTime recordedAt
});




}
/// @nodoc
class __$RecordedChapterCopyWithImpl<$Res>
    implements _$RecordedChapterCopyWith<$Res> {
  __$RecordedChapterCopyWithImpl(this._self, this._then);

  final _RecordedChapter _self;
  final $Res Function(_RecordedChapter) _then;

/// Create a copy of RecordedChapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? audioFilePath = null,Object? durationMs = null,Object? transcript = null,Object? recordedAt = null,}) {
  return _then(_RecordedChapter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,audioFilePath: null == audioFilePath ? _self.audioFilePath : audioFilePath // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,transcript: null == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
