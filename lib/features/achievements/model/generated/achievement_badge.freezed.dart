// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../achievement_badge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AchievementBadge {

 String get id; BadgeCategory get category; BadgeMetric get metric; int get threshold; int get tier;
/// Create a copy of AchievementBadge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AchievementBadgeCopyWith<AchievementBadge> get copyWith => _$AchievementBadgeCopyWithImpl<AchievementBadge>(this as AchievementBadge, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AchievementBadge&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.metric, metric) || other.metric == metric)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.tier, tier) || other.tier == tier));
}


@override
int get hashCode => Object.hash(runtimeType,id,category,metric,threshold,tier);

@override
String toString() {
  return 'AchievementBadge(id: $id, category: $category, metric: $metric, threshold: $threshold, tier: $tier)';
}


}

/// @nodoc
abstract mixin class $AchievementBadgeCopyWith<$Res>  {
  factory $AchievementBadgeCopyWith(AchievementBadge value, $Res Function(AchievementBadge) _then) = _$AchievementBadgeCopyWithImpl;
@useResult
$Res call({
 String id, BadgeCategory category, BadgeMetric metric, int threshold, int tier
});




}
/// @nodoc
class _$AchievementBadgeCopyWithImpl<$Res>
    implements $AchievementBadgeCopyWith<$Res> {
  _$AchievementBadgeCopyWithImpl(this._self, this._then);

  final AchievementBadge _self;
  final $Res Function(AchievementBadge) _then;

/// Create a copy of AchievementBadge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? metric = null,Object? threshold = null,Object? tier = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as BadgeCategory,metric: null == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as BadgeMetric,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AchievementBadge].
extension AchievementBadgePatterns on AchievementBadge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AchievementBadge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AchievementBadge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AchievementBadge value)  $default,){
final _that = this;
switch (_that) {
case _AchievementBadge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AchievementBadge value)?  $default,){
final _that = this;
switch (_that) {
case _AchievementBadge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  BadgeCategory category,  BadgeMetric metric,  int threshold,  int tier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AchievementBadge() when $default != null:
return $default(_that.id,_that.category,_that.metric,_that.threshold,_that.tier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  BadgeCategory category,  BadgeMetric metric,  int threshold,  int tier)  $default,) {final _that = this;
switch (_that) {
case _AchievementBadge():
return $default(_that.id,_that.category,_that.metric,_that.threshold,_that.tier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  BadgeCategory category,  BadgeMetric metric,  int threshold,  int tier)?  $default,) {final _that = this;
switch (_that) {
case _AchievementBadge() when $default != null:
return $default(_that.id,_that.category,_that.metric,_that.threshold,_that.tier);case _:
  return null;

}
}

}

/// @nodoc


class _AchievementBadge implements AchievementBadge {
  const _AchievementBadge({required this.id, required this.category, required this.metric, required this.threshold, required this.tier});
  

@override final  String id;
@override final  BadgeCategory category;
@override final  BadgeMetric metric;
@override final  int threshold;
@override final  int tier;

/// Create a copy of AchievementBadge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AchievementBadgeCopyWith<_AchievementBadge> get copyWith => __$AchievementBadgeCopyWithImpl<_AchievementBadge>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AchievementBadge&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.metric, metric) || other.metric == metric)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.tier, tier) || other.tier == tier));
}


@override
int get hashCode => Object.hash(runtimeType,id,category,metric,threshold,tier);

@override
String toString() {
  return 'AchievementBadge(id: $id, category: $category, metric: $metric, threshold: $threshold, tier: $tier)';
}


}

/// @nodoc
abstract mixin class _$AchievementBadgeCopyWith<$Res> implements $AchievementBadgeCopyWith<$Res> {
  factory _$AchievementBadgeCopyWith(_AchievementBadge value, $Res Function(_AchievementBadge) _then) = __$AchievementBadgeCopyWithImpl;
@override @useResult
$Res call({
 String id, BadgeCategory category, BadgeMetric metric, int threshold, int tier
});




}
/// @nodoc
class __$AchievementBadgeCopyWithImpl<$Res>
    implements _$AchievementBadgeCopyWith<$Res> {
  __$AchievementBadgeCopyWithImpl(this._self, this._then);

  final _AchievementBadge _self;
  final $Res Function(_AchievementBadge) _then;

/// Create a copy of AchievementBadge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? metric = null,Object? threshold = null,Object? tier = null,}) {
  return _then(_AchievementBadge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as BadgeCategory,metric: null == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as BadgeMetric,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
