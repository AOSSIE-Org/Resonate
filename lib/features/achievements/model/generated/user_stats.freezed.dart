// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserStats {

 int get roomsHosted; int get roomsModerated; int get interactions; int get activeDays; int get currentStreak; int get longestStreak; List<String> get badges; List<String> get displayedBadges; String? get avatarBadge;
/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatsCopyWith<UserStats> get copyWith => _$UserStatsCopyWithImpl<UserStats>(this as UserStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStats&&(identical(other.roomsHosted, roomsHosted) || other.roomsHosted == roomsHosted)&&(identical(other.roomsModerated, roomsModerated) || other.roomsModerated == roomsModerated)&&(identical(other.interactions, interactions) || other.interactions == interactions)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&const DeepCollectionEquality().equals(other.badges, badges)&&const DeepCollectionEquality().equals(other.displayedBadges, displayedBadges)&&(identical(other.avatarBadge, avatarBadge) || other.avatarBadge == avatarBadge));
}


@override
int get hashCode => Object.hash(runtimeType,roomsHosted,roomsModerated,interactions,activeDays,currentStreak,longestStreak,const DeepCollectionEquality().hash(badges),const DeepCollectionEquality().hash(displayedBadges),avatarBadge);

@override
String toString() {
  return 'UserStats(roomsHosted: $roomsHosted, roomsModerated: $roomsModerated, interactions: $interactions, activeDays: $activeDays, currentStreak: $currentStreak, longestStreak: $longestStreak, badges: $badges, displayedBadges: $displayedBadges, avatarBadge: $avatarBadge)';
}


}

/// @nodoc
abstract mixin class $UserStatsCopyWith<$Res>  {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) _then) = _$UserStatsCopyWithImpl;
@useResult
$Res call({
 int roomsHosted, int roomsModerated, int interactions, int activeDays, int currentStreak, int longestStreak, List<String> badges, List<String> displayedBadges, String? avatarBadge
});




}
/// @nodoc
class _$UserStatsCopyWithImpl<$Res>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._self, this._then);

  final UserStats _self;
  final $Res Function(UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomsHosted = null,Object? roomsModerated = null,Object? interactions = null,Object? activeDays = null,Object? currentStreak = null,Object? longestStreak = null,Object? badges = null,Object? displayedBadges = null,Object? avatarBadge = freezed,}) {
  return _then(_self.copyWith(
roomsHosted: null == roomsHosted ? _self.roomsHosted : roomsHosted // ignore: cast_nullable_to_non_nullable
as int,roomsModerated: null == roomsModerated ? _self.roomsModerated : roomsModerated // ignore: cast_nullable_to_non_nullable
as int,interactions: null == interactions ? _self.interactions : interactions // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,displayedBadges: null == displayedBadges ? _self.displayedBadges : displayedBadges // ignore: cast_nullable_to_non_nullable
as List<String>,avatarBadge: freezed == avatarBadge ? _self.avatarBadge : avatarBadge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserStats].
extension UserStatsPatterns on UserStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStats value)  $default,){
final _that = this;
switch (_that) {
case _UserStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStats value)?  $default,){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int roomsHosted,  int roomsModerated,  int interactions,  int activeDays,  int currentStreak,  int longestStreak,  List<String> badges,  List<String> displayedBadges,  String? avatarBadge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.roomsHosted,_that.roomsModerated,_that.interactions,_that.activeDays,_that.currentStreak,_that.longestStreak,_that.badges,_that.displayedBadges,_that.avatarBadge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int roomsHosted,  int roomsModerated,  int interactions,  int activeDays,  int currentStreak,  int longestStreak,  List<String> badges,  List<String> displayedBadges,  String? avatarBadge)  $default,) {final _that = this;
switch (_that) {
case _UserStats():
return $default(_that.roomsHosted,_that.roomsModerated,_that.interactions,_that.activeDays,_that.currentStreak,_that.longestStreak,_that.badges,_that.displayedBadges,_that.avatarBadge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int roomsHosted,  int roomsModerated,  int interactions,  int activeDays,  int currentStreak,  int longestStreak,  List<String> badges,  List<String> displayedBadges,  String? avatarBadge)?  $default,) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.roomsHosted,_that.roomsModerated,_that.interactions,_that.activeDays,_that.currentStreak,_that.longestStreak,_that.badges,_that.displayedBadges,_that.avatarBadge);case _:
  return null;

}
}

}

/// @nodoc


class _UserStats extends UserStats {
  const _UserStats({this.roomsHosted = 0, this.roomsModerated = 0, this.interactions = 0, this.activeDays = 0, this.currentStreak = 0, this.longestStreak = 0, final  List<String> badges = const <String>[], final  List<String> displayedBadges = const <String>[], this.avatarBadge}): _badges = badges,_displayedBadges = displayedBadges,super._();
  

@override@JsonKey() final  int roomsHosted;
@override@JsonKey() final  int roomsModerated;
@override@JsonKey() final  int interactions;
@override@JsonKey() final  int activeDays;
@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
 final  List<String> _badges;
@override@JsonKey() List<String> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

 final  List<String> _displayedBadges;
@override@JsonKey() List<String> get displayedBadges {
  if (_displayedBadges is EqualUnmodifiableListView) return _displayedBadges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_displayedBadges);
}

@override final  String? avatarBadge;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatsCopyWith<_UserStats> get copyWith => __$UserStatsCopyWithImpl<_UserStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStats&&(identical(other.roomsHosted, roomsHosted) || other.roomsHosted == roomsHosted)&&(identical(other.roomsModerated, roomsModerated) || other.roomsModerated == roomsModerated)&&(identical(other.interactions, interactions) || other.interactions == interactions)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&const DeepCollectionEquality().equals(other._badges, _badges)&&const DeepCollectionEquality().equals(other._displayedBadges, _displayedBadges)&&(identical(other.avatarBadge, avatarBadge) || other.avatarBadge == avatarBadge));
}


@override
int get hashCode => Object.hash(runtimeType,roomsHosted,roomsModerated,interactions,activeDays,currentStreak,longestStreak,const DeepCollectionEquality().hash(_badges),const DeepCollectionEquality().hash(_displayedBadges),avatarBadge);

@override
String toString() {
  return 'UserStats(roomsHosted: $roomsHosted, roomsModerated: $roomsModerated, interactions: $interactions, activeDays: $activeDays, currentStreak: $currentStreak, longestStreak: $longestStreak, badges: $badges, displayedBadges: $displayedBadges, avatarBadge: $avatarBadge)';
}


}

/// @nodoc
abstract mixin class _$UserStatsCopyWith<$Res> implements $UserStatsCopyWith<$Res> {
  factory _$UserStatsCopyWith(_UserStats value, $Res Function(_UserStats) _then) = __$UserStatsCopyWithImpl;
@override @useResult
$Res call({
 int roomsHosted, int roomsModerated, int interactions, int activeDays, int currentStreak, int longestStreak, List<String> badges, List<String> displayedBadges, String? avatarBadge
});




}
/// @nodoc
class __$UserStatsCopyWithImpl<$Res>
    implements _$UserStatsCopyWith<$Res> {
  __$UserStatsCopyWithImpl(this._self, this._then);

  final _UserStats _self;
  final $Res Function(_UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomsHosted = null,Object? roomsModerated = null,Object? interactions = null,Object? activeDays = null,Object? currentStreak = null,Object? longestStreak = null,Object? badges = null,Object? displayedBadges = null,Object? avatarBadge = freezed,}) {
  return _then(_UserStats(
roomsHosted: null == roomsHosted ? _self.roomsHosted : roomsHosted // ignore: cast_nullable_to_non_nullable
as int,roomsModerated: null == roomsModerated ? _self.roomsModerated : roomsModerated // ignore: cast_nullable_to_non_nullable
as int,interactions: null == interactions ? _self.interactions : interactions // ignore: cast_nullable_to_non_nullable
as int,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,displayedBadges: null == displayedBadges ? _self._displayedBadges : displayedBadges // ignore: cast_nullable_to_non_nullable
as List<String>,avatarBadge: freezed == avatarBadge ? _self.avatarBadge : avatarBadge // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
