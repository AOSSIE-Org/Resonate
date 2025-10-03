// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserReportModel {

 String get reporterUid; String get reportedUid; String? get reportText; ReportTypeEnum get reportType; String get reportedUser;
/// Create a copy of UserReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserReportModelCopyWith<UserReportModel> get copyWith => _$UserReportModelCopyWithImpl<UserReportModel>(this as UserReportModel, _$identity);

  /// Serializes this UserReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserReportModel&&(identical(other.reporterUid, reporterUid) || other.reporterUid == reporterUid)&&(identical(other.reportedUid, reportedUid) || other.reportedUid == reportedUid)&&(identical(other.reportText, reportText) || other.reportText == reportText)&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.reportedUser, reportedUser) || other.reportedUser == reportedUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reporterUid,reportedUid,reportText,reportType,reportedUser);

@override
String toString() {
  return 'UserReportModel(reporterUid: $reporterUid, reportedUid: $reportedUid, reportText: $reportText, reportType: $reportType, reportedUser: $reportedUser)';
}


}

/// @nodoc
abstract mixin class $UserReportModelCopyWith<$Res>  {
  factory $UserReportModelCopyWith(UserReportModel value, $Res Function(UserReportModel) _then) = _$UserReportModelCopyWithImpl;
@useResult
$Res call({
 String reporterUid, String reportedUid, String? reportText, ReportTypeEnum reportType, String reportedUser
});




}
/// @nodoc
class _$UserReportModelCopyWithImpl<$Res>
    implements $UserReportModelCopyWith<$Res> {
  _$UserReportModelCopyWithImpl(this._self, this._then);

  final UserReportModel _self;
  final $Res Function(UserReportModel) _then;

/// Create a copy of UserReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reporterUid = null,Object? reportedUid = null,Object? reportText = freezed,Object? reportType = null,Object? reportedUser = null,}) {
  return _then(_self.copyWith(
reporterUid: null == reporterUid ? _self.reporterUid : reporterUid // ignore: cast_nullable_to_non_nullable
as String,reportedUid: null == reportedUid ? _self.reportedUid : reportedUid // ignore: cast_nullable_to_non_nullable
as String,reportText: freezed == reportText ? _self.reportText : reportText // ignore: cast_nullable_to_non_nullable
as String?,reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as ReportTypeEnum,reportedUser: null == reportedUser ? _self.reportedUser : reportedUser // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserReportModel].
extension UserReportModelPatterns on UserReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserReportModel value)  $default,){
final _that = this;
switch (_that) {
case _UserReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reporterUid,  String reportedUid,  String? reportText,  ReportTypeEnum reportType,  String reportedUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserReportModel() when $default != null:
return $default(_that.reporterUid,_that.reportedUid,_that.reportText,_that.reportType,_that.reportedUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reporterUid,  String reportedUid,  String? reportText,  ReportTypeEnum reportType,  String reportedUser)  $default,) {final _that = this;
switch (_that) {
case _UserReportModel():
return $default(_that.reporterUid,_that.reportedUid,_that.reportText,_that.reportType,_that.reportedUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reporterUid,  String reportedUid,  String? reportText,  ReportTypeEnum reportType,  String reportedUser)?  $default,) {final _that = this;
switch (_that) {
case _UserReportModel() when $default != null:
return $default(_that.reporterUid,_that.reportedUid,_that.reportText,_that.reportType,_that.reportedUser);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserReportModel implements UserReportModel {
   _UserReportModel({required this.reporterUid, required this.reportedUid, this.reportText, required this.reportType, required this.reportedUser});
  factory _UserReportModel.fromJson(Map<String, dynamic> json) => _$UserReportModelFromJson(json);

@override final  String reporterUid;
@override final  String reportedUid;
@override final  String? reportText;
@override final  ReportTypeEnum reportType;
@override final  String reportedUser;

/// Create a copy of UserReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserReportModelCopyWith<_UserReportModel> get copyWith => __$UserReportModelCopyWithImpl<_UserReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserReportModel&&(identical(other.reporterUid, reporterUid) || other.reporterUid == reporterUid)&&(identical(other.reportedUid, reportedUid) || other.reportedUid == reportedUid)&&(identical(other.reportText, reportText) || other.reportText == reportText)&&(identical(other.reportType, reportType) || other.reportType == reportType)&&(identical(other.reportedUser, reportedUser) || other.reportedUser == reportedUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reporterUid,reportedUid,reportText,reportType,reportedUser);

@override
String toString() {
  return 'UserReportModel(reporterUid: $reporterUid, reportedUid: $reportedUid, reportText: $reportText, reportType: $reportType, reportedUser: $reportedUser)';
}


}

/// @nodoc
abstract mixin class _$UserReportModelCopyWith<$Res> implements $UserReportModelCopyWith<$Res> {
  factory _$UserReportModelCopyWith(_UserReportModel value, $Res Function(_UserReportModel) _then) = __$UserReportModelCopyWithImpl;
@override @useResult
$Res call({
 String reporterUid, String reportedUid, String? reportText, ReportTypeEnum reportType, String reportedUser
});




}
/// @nodoc
class __$UserReportModelCopyWithImpl<$Res>
    implements _$UserReportModelCopyWith<$Res> {
  __$UserReportModelCopyWithImpl(this._self, this._then);

  final _UserReportModel _self;
  final $Res Function(_UserReportModel) _then;

/// Create a copy of UserReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reporterUid = null,Object? reportedUid = null,Object? reportText = freezed,Object? reportType = null,Object? reportedUser = null,}) {
  return _then(_UserReportModel(
reporterUid: null == reporterUid ? _self.reporterUid : reporterUid // ignore: cast_nullable_to_non_nullable
as String,reportedUid: null == reportedUid ? _self.reportedUid : reportedUid // ignore: cast_nullable_to_non_nullable
as String,reportText: freezed == reportText ? _self.reportText : reportText // ignore: cast_nullable_to_non_nullable
as String?,reportType: null == reportType ? _self.reportType : reportType // ignore: cast_nullable_to_non_nullable
as ReportTypeEnum,reportedUser: null == reportedUser ? _self.reportedUser : reportedUser // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
