// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../pair_chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PairChatState {

 bool get isAnonymous; String get languageIso; bool get isMicOn; bool get isLoudSpeakerOn; String? get requestDocId; String? get activePairDocId; String? get pairUsername; String? get pairProfileImageUrl; double get pairRating; List<ResonateUser> get onlineUsers; bool get isUserListLoading;// showing the rating sheet and returning to the tab view.
 bool get ended;
/// Create a copy of PairChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairChatStateCopyWith<PairChatState> get copyWith => _$PairChatStateCopyWithImpl<PairChatState>(this as PairChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairChatState&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.languageIso, languageIso) || other.languageIso == languageIso)&&(identical(other.isMicOn, isMicOn) || other.isMicOn == isMicOn)&&(identical(other.isLoudSpeakerOn, isLoudSpeakerOn) || other.isLoudSpeakerOn == isLoudSpeakerOn)&&(identical(other.requestDocId, requestDocId) || other.requestDocId == requestDocId)&&(identical(other.activePairDocId, activePairDocId) || other.activePairDocId == activePairDocId)&&(identical(other.pairUsername, pairUsername) || other.pairUsername == pairUsername)&&(identical(other.pairProfileImageUrl, pairProfileImageUrl) || other.pairProfileImageUrl == pairProfileImageUrl)&&(identical(other.pairRating, pairRating) || other.pairRating == pairRating)&&const DeepCollectionEquality().equals(other.onlineUsers, onlineUsers)&&(identical(other.isUserListLoading, isUserListLoading) || other.isUserListLoading == isUserListLoading)&&(identical(other.ended, ended) || other.ended == ended));
}


@override
int get hashCode => Object.hash(runtimeType,isAnonymous,languageIso,isMicOn,isLoudSpeakerOn,requestDocId,activePairDocId,pairUsername,pairProfileImageUrl,pairRating,const DeepCollectionEquality().hash(onlineUsers),isUserListLoading,ended);

@override
String toString() {
  return 'PairChatState(isAnonymous: $isAnonymous, languageIso: $languageIso, isMicOn: $isMicOn, isLoudSpeakerOn: $isLoudSpeakerOn, requestDocId: $requestDocId, activePairDocId: $activePairDocId, pairUsername: $pairUsername, pairProfileImageUrl: $pairProfileImageUrl, pairRating: $pairRating, onlineUsers: $onlineUsers, isUserListLoading: $isUserListLoading, ended: $ended)';
}


}

/// @nodoc
abstract mixin class $PairChatStateCopyWith<$Res>  {
  factory $PairChatStateCopyWith(PairChatState value, $Res Function(PairChatState) _then) = _$PairChatStateCopyWithImpl;
@useResult
$Res call({
 bool isAnonymous, String languageIso, bool isMicOn, bool isLoudSpeakerOn, String? requestDocId, String? activePairDocId, String? pairUsername, String? pairProfileImageUrl, double pairRating, List<ResonateUser> onlineUsers, bool isUserListLoading, bool ended
});




}
/// @nodoc
class _$PairChatStateCopyWithImpl<$Res>
    implements $PairChatStateCopyWith<$Res> {
  _$PairChatStateCopyWithImpl(this._self, this._then);

  final PairChatState _self;
  final $Res Function(PairChatState) _then;

/// Create a copy of PairChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAnonymous = null,Object? languageIso = null,Object? isMicOn = null,Object? isLoudSpeakerOn = null,Object? requestDocId = freezed,Object? activePairDocId = freezed,Object? pairUsername = freezed,Object? pairProfileImageUrl = freezed,Object? pairRating = null,Object? onlineUsers = null,Object? isUserListLoading = null,Object? ended = null,}) {
  return _then(_self.copyWith(
isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,languageIso: null == languageIso ? _self.languageIso : languageIso // ignore: cast_nullable_to_non_nullable
as String,isMicOn: null == isMicOn ? _self.isMicOn : isMicOn // ignore: cast_nullable_to_non_nullable
as bool,isLoudSpeakerOn: null == isLoudSpeakerOn ? _self.isLoudSpeakerOn : isLoudSpeakerOn // ignore: cast_nullable_to_non_nullable
as bool,requestDocId: freezed == requestDocId ? _self.requestDocId : requestDocId // ignore: cast_nullable_to_non_nullable
as String?,activePairDocId: freezed == activePairDocId ? _self.activePairDocId : activePairDocId // ignore: cast_nullable_to_non_nullable
as String?,pairUsername: freezed == pairUsername ? _self.pairUsername : pairUsername // ignore: cast_nullable_to_non_nullable
as String?,pairProfileImageUrl: freezed == pairProfileImageUrl ? _self.pairProfileImageUrl : pairProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,pairRating: null == pairRating ? _self.pairRating : pairRating // ignore: cast_nullable_to_non_nullable
as double,onlineUsers: null == onlineUsers ? _self.onlineUsers : onlineUsers // ignore: cast_nullable_to_non_nullable
as List<ResonateUser>,isUserListLoading: null == isUserListLoading ? _self.isUserListLoading : isUserListLoading // ignore: cast_nullable_to_non_nullable
as bool,ended: null == ended ? _self.ended : ended // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PairChatState].
extension PairChatStatePatterns on PairChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PairChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PairChatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PairChatState value)  $default,){
final _that = this;
switch (_that) {
case _PairChatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PairChatState value)?  $default,){
final _that = this;
switch (_that) {
case _PairChatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isAnonymous,  String languageIso,  bool isMicOn,  bool isLoudSpeakerOn,  String? requestDocId,  String? activePairDocId,  String? pairUsername,  String? pairProfileImageUrl,  double pairRating,  List<ResonateUser> onlineUsers,  bool isUserListLoading,  bool ended)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PairChatState() when $default != null:
return $default(_that.isAnonymous,_that.languageIso,_that.isMicOn,_that.isLoudSpeakerOn,_that.requestDocId,_that.activePairDocId,_that.pairUsername,_that.pairProfileImageUrl,_that.pairRating,_that.onlineUsers,_that.isUserListLoading,_that.ended);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isAnonymous,  String languageIso,  bool isMicOn,  bool isLoudSpeakerOn,  String? requestDocId,  String? activePairDocId,  String? pairUsername,  String? pairProfileImageUrl,  double pairRating,  List<ResonateUser> onlineUsers,  bool isUserListLoading,  bool ended)  $default,) {final _that = this;
switch (_that) {
case _PairChatState():
return $default(_that.isAnonymous,_that.languageIso,_that.isMicOn,_that.isLoudSpeakerOn,_that.requestDocId,_that.activePairDocId,_that.pairUsername,_that.pairProfileImageUrl,_that.pairRating,_that.onlineUsers,_that.isUserListLoading,_that.ended);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isAnonymous,  String languageIso,  bool isMicOn,  bool isLoudSpeakerOn,  String? requestDocId,  String? activePairDocId,  String? pairUsername,  String? pairProfileImageUrl,  double pairRating,  List<ResonateUser> onlineUsers,  bool isUserListLoading,  bool ended)?  $default,) {final _that = this;
switch (_that) {
case _PairChatState() when $default != null:
return $default(_that.isAnonymous,_that.languageIso,_that.isMicOn,_that.isLoudSpeakerOn,_that.requestDocId,_that.activePairDocId,_that.pairUsername,_that.pairProfileImageUrl,_that.pairRating,_that.onlineUsers,_that.isUserListLoading,_that.ended);case _:
  return null;

}
}

}

/// @nodoc


class _PairChatState implements PairChatState {
  const _PairChatState({this.isAnonymous = true, this.languageIso = 'en', this.isMicOn = false, this.isLoudSpeakerOn = true, this.requestDocId, this.activePairDocId, this.pairUsername, this.pairProfileImageUrl, this.pairRating = 2.5, final  List<ResonateUser> onlineUsers = const <ResonateUser>[], this.isUserListLoading = false, this.ended = false}): _onlineUsers = onlineUsers;
  

@override@JsonKey() final  bool isAnonymous;
@override@JsonKey() final  String languageIso;
@override@JsonKey() final  bool isMicOn;
@override@JsonKey() final  bool isLoudSpeakerOn;
@override final  String? requestDocId;
@override final  String? activePairDocId;
@override final  String? pairUsername;
@override final  String? pairProfileImageUrl;
@override@JsonKey() final  double pairRating;
 final  List<ResonateUser> _onlineUsers;
@override@JsonKey() List<ResonateUser> get onlineUsers {
  if (_onlineUsers is EqualUnmodifiableListView) return _onlineUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_onlineUsers);
}

@override@JsonKey() final  bool isUserListLoading;
// showing the rating sheet and returning to the tab view.
@override@JsonKey() final  bool ended;

/// Create a copy of PairChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PairChatStateCopyWith<_PairChatState> get copyWith => __$PairChatStateCopyWithImpl<_PairChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PairChatState&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.languageIso, languageIso) || other.languageIso == languageIso)&&(identical(other.isMicOn, isMicOn) || other.isMicOn == isMicOn)&&(identical(other.isLoudSpeakerOn, isLoudSpeakerOn) || other.isLoudSpeakerOn == isLoudSpeakerOn)&&(identical(other.requestDocId, requestDocId) || other.requestDocId == requestDocId)&&(identical(other.activePairDocId, activePairDocId) || other.activePairDocId == activePairDocId)&&(identical(other.pairUsername, pairUsername) || other.pairUsername == pairUsername)&&(identical(other.pairProfileImageUrl, pairProfileImageUrl) || other.pairProfileImageUrl == pairProfileImageUrl)&&(identical(other.pairRating, pairRating) || other.pairRating == pairRating)&&const DeepCollectionEquality().equals(other._onlineUsers, _onlineUsers)&&(identical(other.isUserListLoading, isUserListLoading) || other.isUserListLoading == isUserListLoading)&&(identical(other.ended, ended) || other.ended == ended));
}


@override
int get hashCode => Object.hash(runtimeType,isAnonymous,languageIso,isMicOn,isLoudSpeakerOn,requestDocId,activePairDocId,pairUsername,pairProfileImageUrl,pairRating,const DeepCollectionEquality().hash(_onlineUsers),isUserListLoading,ended);

@override
String toString() {
  return 'PairChatState(isAnonymous: $isAnonymous, languageIso: $languageIso, isMicOn: $isMicOn, isLoudSpeakerOn: $isLoudSpeakerOn, requestDocId: $requestDocId, activePairDocId: $activePairDocId, pairUsername: $pairUsername, pairProfileImageUrl: $pairProfileImageUrl, pairRating: $pairRating, onlineUsers: $onlineUsers, isUserListLoading: $isUserListLoading, ended: $ended)';
}


}

/// @nodoc
abstract mixin class _$PairChatStateCopyWith<$Res> implements $PairChatStateCopyWith<$Res> {
  factory _$PairChatStateCopyWith(_PairChatState value, $Res Function(_PairChatState) _then) = __$PairChatStateCopyWithImpl;
@override @useResult
$Res call({
 bool isAnonymous, String languageIso, bool isMicOn, bool isLoudSpeakerOn, String? requestDocId, String? activePairDocId, String? pairUsername, String? pairProfileImageUrl, double pairRating, List<ResonateUser> onlineUsers, bool isUserListLoading, bool ended
});




}
/// @nodoc
class __$PairChatStateCopyWithImpl<$Res>
    implements _$PairChatStateCopyWith<$Res> {
  __$PairChatStateCopyWithImpl(this._self, this._then);

  final _PairChatState _self;
  final $Res Function(_PairChatState) _then;

/// Create a copy of PairChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAnonymous = null,Object? languageIso = null,Object? isMicOn = null,Object? isLoudSpeakerOn = null,Object? requestDocId = freezed,Object? activePairDocId = freezed,Object? pairUsername = freezed,Object? pairProfileImageUrl = freezed,Object? pairRating = null,Object? onlineUsers = null,Object? isUserListLoading = null,Object? ended = null,}) {
  return _then(_PairChatState(
isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,languageIso: null == languageIso ? _self.languageIso : languageIso // ignore: cast_nullable_to_non_nullable
as String,isMicOn: null == isMicOn ? _self.isMicOn : isMicOn // ignore: cast_nullable_to_non_nullable
as bool,isLoudSpeakerOn: null == isLoudSpeakerOn ? _self.isLoudSpeakerOn : isLoudSpeakerOn // ignore: cast_nullable_to_non_nullable
as bool,requestDocId: freezed == requestDocId ? _self.requestDocId : requestDocId // ignore: cast_nullable_to_non_nullable
as String?,activePairDocId: freezed == activePairDocId ? _self.activePairDocId : activePairDocId // ignore: cast_nullable_to_non_nullable
as String?,pairUsername: freezed == pairUsername ? _self.pairUsername : pairUsername // ignore: cast_nullable_to_non_nullable
as String?,pairProfileImageUrl: freezed == pairProfileImageUrl ? _self.pairProfileImageUrl : pairProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,pairRating: null == pairRating ? _self.pairRating : pairRating // ignore: cast_nullable_to_non_nullable
as double,onlineUsers: null == onlineUsers ? _self._onlineUsers : onlineUsers // ignore: cast_nullable_to_non_nullable
as List<ResonateUser>,isUserListLoading: null == isUserListLoading ? _self.isUserListLoading : isUserListLoading // ignore: cast_nullable_to_non_nullable
as bool,ended: null == ended ? _self.ended : ended // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
