// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_chapter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LiveChapterModel {

 String get livekitRoomId; String get authorUid; String get authorProfileImageUrl; String get authorName; String get chapterTitle; String get chapterDescription; String get storyId; List<String> get followersFCMToken;@JsonKey(includeToJson: false, includeFromJson: false) LiveChapterAttendeesModel? get attendees;@JsonKey(name: '\$id', includeToJson: false) String get id;
/// Create a copy of LiveChapterModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveChapterModelCopyWith<LiveChapterModel> get copyWith => _$LiveChapterModelCopyWithImpl<LiveChapterModel>(this as LiveChapterModel, _$identity);

  /// Serializes this LiveChapterModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveChapterModel&&(identical(other.livekitRoomId, livekitRoomId) || other.livekitRoomId == livekitRoomId)&&(identical(other.authorUid, authorUid) || other.authorUid == authorUid)&&(identical(other.authorProfileImageUrl, authorProfileImageUrl) || other.authorProfileImageUrl == authorProfileImageUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.chapterDescription, chapterDescription) || other.chapterDescription == chapterDescription)&&(identical(other.storyId, storyId) || other.storyId == storyId)&&const DeepCollectionEquality().equals(other.followersFCMToken, followersFCMToken)&&(identical(other.attendees, attendees) || other.attendees == attendees)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,livekitRoomId,authorUid,authorProfileImageUrl,authorName,chapterTitle,chapterDescription,storyId,const DeepCollectionEquality().hash(followersFCMToken),attendees,id);

@override
String toString() {
  return 'LiveChapterModel(livekitRoomId: $livekitRoomId, authorUid: $authorUid, authorProfileImageUrl: $authorProfileImageUrl, authorName: $authorName, chapterTitle: $chapterTitle, chapterDescription: $chapterDescription, storyId: $storyId, followersFCMToken: $followersFCMToken, attendees: $attendees, id: $id)';
}


}

/// @nodoc
abstract mixin class $LiveChapterModelCopyWith<$Res>  {
  factory $LiveChapterModelCopyWith(LiveChapterModel value, $Res Function(LiveChapterModel) _then) = _$LiveChapterModelCopyWithImpl;
@useResult
$Res call({
 String livekitRoomId, String authorUid, String authorProfileImageUrl, String authorName, String chapterTitle, String chapterDescription, String storyId, List<String> followersFCMToken,@JsonKey(includeToJson: false, includeFromJson: false) LiveChapterAttendeesModel? attendees,@JsonKey(name: '\$id', includeToJson: false) String id
});


$LiveChapterAttendeesModelCopyWith<$Res>? get attendees;

}
/// @nodoc
class _$LiveChapterModelCopyWithImpl<$Res>
    implements $LiveChapterModelCopyWith<$Res> {
  _$LiveChapterModelCopyWithImpl(this._self, this._then);

  final LiveChapterModel _self;
  final $Res Function(LiveChapterModel) _then;

/// Create a copy of LiveChapterModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? livekitRoomId = null,Object? authorUid = null,Object? authorProfileImageUrl = null,Object? authorName = null,Object? chapterTitle = null,Object? chapterDescription = null,Object? storyId = null,Object? followersFCMToken = null,Object? attendees = freezed,Object? id = null,}) {
  return _then(_self.copyWith(
livekitRoomId: null == livekitRoomId ? _self.livekitRoomId : livekitRoomId // ignore: cast_nullable_to_non_nullable
as String,authorUid: null == authorUid ? _self.authorUid : authorUid // ignore: cast_nullable_to_non_nullable
as String,authorProfileImageUrl: null == authorProfileImageUrl ? _self.authorProfileImageUrl : authorProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,chapterTitle: null == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String,chapterDescription: null == chapterDescription ? _self.chapterDescription : chapterDescription // ignore: cast_nullable_to_non_nullable
as String,storyId: null == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String,followersFCMToken: null == followersFCMToken ? _self.followersFCMToken : followersFCMToken // ignore: cast_nullable_to_non_nullable
as List<String>,attendees: freezed == attendees ? _self.attendees : attendees // ignore: cast_nullable_to_non_nullable
as LiveChapterAttendeesModel?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of LiveChapterModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveChapterAttendeesModelCopyWith<$Res>? get attendees {
    if (_self.attendees == null) {
    return null;
  }

  return $LiveChapterAttendeesModelCopyWith<$Res>(_self.attendees!, (value) {
    return _then(_self.copyWith(attendees: value));
  });
}
}


/// Adds pattern-matching-related methods to [LiveChapterModel].
extension LiveChapterModelPatterns on LiveChapterModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveChapterModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveChapterModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveChapterModel value)  $default,){
final _that = this;
switch (_that) {
case _LiveChapterModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveChapterModel value)?  $default,){
final _that = this;
switch (_that) {
case _LiveChapterModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String livekitRoomId,  String authorUid,  String authorProfileImageUrl,  String authorName,  String chapterTitle,  String chapterDescription,  String storyId,  List<String> followersFCMToken, @JsonKey(includeToJson: false, includeFromJson: false)  LiveChapterAttendeesModel? attendees, @JsonKey(name: '\$id', includeToJson: false)  String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveChapterModel() when $default != null:
return $default(_that.livekitRoomId,_that.authorUid,_that.authorProfileImageUrl,_that.authorName,_that.chapterTitle,_that.chapterDescription,_that.storyId,_that.followersFCMToken,_that.attendees,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String livekitRoomId,  String authorUid,  String authorProfileImageUrl,  String authorName,  String chapterTitle,  String chapterDescription,  String storyId,  List<String> followersFCMToken, @JsonKey(includeToJson: false, includeFromJson: false)  LiveChapterAttendeesModel? attendees, @JsonKey(name: '\$id', includeToJson: false)  String id)  $default,) {final _that = this;
switch (_that) {
case _LiveChapterModel():
return $default(_that.livekitRoomId,_that.authorUid,_that.authorProfileImageUrl,_that.authorName,_that.chapterTitle,_that.chapterDescription,_that.storyId,_that.followersFCMToken,_that.attendees,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String livekitRoomId,  String authorUid,  String authorProfileImageUrl,  String authorName,  String chapterTitle,  String chapterDescription,  String storyId,  List<String> followersFCMToken, @JsonKey(includeToJson: false, includeFromJson: false)  LiveChapterAttendeesModel? attendees, @JsonKey(name: '\$id', includeToJson: false)  String id)?  $default,) {final _that = this;
switch (_that) {
case _LiveChapterModel() when $default != null:
return $default(_that.livekitRoomId,_that.authorUid,_that.authorProfileImageUrl,_that.authorName,_that.chapterTitle,_that.chapterDescription,_that.storyId,_that.followersFCMToken,_that.attendees,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LiveChapterModel implements LiveChapterModel {
   _LiveChapterModel({required this.livekitRoomId, required this.authorUid, required this.authorProfileImageUrl, required this.authorName, required this.chapterTitle, required this.chapterDescription, required this.storyId, required final  List<String> followersFCMToken, @JsonKey(includeToJson: false, includeFromJson: false) this.attendees, @JsonKey(name: '\$id', includeToJson: false) required this.id}): _followersFCMToken = followersFCMToken;
  factory _LiveChapterModel.fromJson(Map<String, dynamic> json) => _$LiveChapterModelFromJson(json);

@override final  String livekitRoomId;
@override final  String authorUid;
@override final  String authorProfileImageUrl;
@override final  String authorName;
@override final  String chapterTitle;
@override final  String chapterDescription;
@override final  String storyId;
 final  List<String> _followersFCMToken;
@override List<String> get followersFCMToken {
  if (_followersFCMToken is EqualUnmodifiableListView) return _followersFCMToken;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followersFCMToken);
}

@override@JsonKey(includeToJson: false, includeFromJson: false) final  LiveChapterAttendeesModel? attendees;
@override@JsonKey(name: '\$id', includeToJson: false) final  String id;

/// Create a copy of LiveChapterModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveChapterModelCopyWith<_LiveChapterModel> get copyWith => __$LiveChapterModelCopyWithImpl<_LiveChapterModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiveChapterModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveChapterModel&&(identical(other.livekitRoomId, livekitRoomId) || other.livekitRoomId == livekitRoomId)&&(identical(other.authorUid, authorUid) || other.authorUid == authorUid)&&(identical(other.authorProfileImageUrl, authorProfileImageUrl) || other.authorProfileImageUrl == authorProfileImageUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.chapterDescription, chapterDescription) || other.chapterDescription == chapterDescription)&&(identical(other.storyId, storyId) || other.storyId == storyId)&&const DeepCollectionEquality().equals(other._followersFCMToken, _followersFCMToken)&&(identical(other.attendees, attendees) || other.attendees == attendees)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,livekitRoomId,authorUid,authorProfileImageUrl,authorName,chapterTitle,chapterDescription,storyId,const DeepCollectionEquality().hash(_followersFCMToken),attendees,id);

@override
String toString() {
  return 'LiveChapterModel(livekitRoomId: $livekitRoomId, authorUid: $authorUid, authorProfileImageUrl: $authorProfileImageUrl, authorName: $authorName, chapterTitle: $chapterTitle, chapterDescription: $chapterDescription, storyId: $storyId, followersFCMToken: $followersFCMToken, attendees: $attendees, id: $id)';
}


}

/// @nodoc
abstract mixin class _$LiveChapterModelCopyWith<$Res> implements $LiveChapterModelCopyWith<$Res> {
  factory _$LiveChapterModelCopyWith(_LiveChapterModel value, $Res Function(_LiveChapterModel) _then) = __$LiveChapterModelCopyWithImpl;
@override @useResult
$Res call({
 String livekitRoomId, String authorUid, String authorProfileImageUrl, String authorName, String chapterTitle, String chapterDescription, String storyId, List<String> followersFCMToken,@JsonKey(includeToJson: false, includeFromJson: false) LiveChapterAttendeesModel? attendees,@JsonKey(name: '\$id', includeToJson: false) String id
});


@override $LiveChapterAttendeesModelCopyWith<$Res>? get attendees;

}
/// @nodoc
class __$LiveChapterModelCopyWithImpl<$Res>
    implements _$LiveChapterModelCopyWith<$Res> {
  __$LiveChapterModelCopyWithImpl(this._self, this._then);

  final _LiveChapterModel _self;
  final $Res Function(_LiveChapterModel) _then;

/// Create a copy of LiveChapterModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? livekitRoomId = null,Object? authorUid = null,Object? authorProfileImageUrl = null,Object? authorName = null,Object? chapterTitle = null,Object? chapterDescription = null,Object? storyId = null,Object? followersFCMToken = null,Object? attendees = freezed,Object? id = null,}) {
  return _then(_LiveChapterModel(
livekitRoomId: null == livekitRoomId ? _self.livekitRoomId : livekitRoomId // ignore: cast_nullable_to_non_nullable
as String,authorUid: null == authorUid ? _self.authorUid : authorUid // ignore: cast_nullable_to_non_nullable
as String,authorProfileImageUrl: null == authorProfileImageUrl ? _self.authorProfileImageUrl : authorProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,chapterTitle: null == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String,chapterDescription: null == chapterDescription ? _self.chapterDescription : chapterDescription // ignore: cast_nullable_to_non_nullable
as String,storyId: null == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String,followersFCMToken: null == followersFCMToken ? _self._followersFCMToken : followersFCMToken // ignore: cast_nullable_to_non_nullable
as List<String>,attendees: freezed == attendees ? _self.attendees : attendees // ignore: cast_nullable_to_non_nullable
as LiveChapterAttendeesModel?,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of LiveChapterModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LiveChapterAttendeesModelCopyWith<$Res>? get attendees {
    if (_self.attendees == null) {
    return null;
  }

  return $LiveChapterAttendeesModelCopyWith<$Res>(_self.attendees!, (value) {
    return _then(_self.copyWith(attendees: value));
  });
}
}

// dart format on
