// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resonate_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResonateUser _$ResonateUserFromJson(Map<String, dynamic> json) {
  return _ResonateUser.fromJson(json);
}

/// @nodoc
mixin _$ResonateUser {
  String? get uid => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get dateOfBirth => throw _privateConstructorUsedError;

  /// Serializes this ResonateUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResonateUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResonateUserCopyWith<ResonateUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResonateUserCopyWith<$Res> {
  factory $ResonateUserCopyWith(
          ResonateUser value, $Res Function(ResonateUser) then) =
      _$ResonateUserCopyWithImpl<$Res, ResonateUser>;
  @useResult
  $Res call(
      {String? uid,
      String? userName,
      String? profileImageUrl,
      String? gender,
      String? dateOfBirth});
}

/// @nodoc
class _$ResonateUserCopyWithImpl<$Res, $Val extends ResonateUser>
    implements $ResonateUserCopyWith<$Res> {
  _$ResonateUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResonateUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? userName = freezed,
    Object? profileImageUrl = freezed,
    Object? gender = freezed,
    Object? dateOfBirth = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResonateUserImplCopyWith<$Res>
    implements $ResonateUserCopyWith<$Res> {
  factory _$$ResonateUserImplCopyWith(
          _$ResonateUserImpl value, $Res Function(_$ResonateUserImpl) then) =
      __$$ResonateUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uid,
      String? userName,
      String? profileImageUrl,
      String? gender,
      String? dateOfBirth});
}

/// @nodoc
class __$$ResonateUserImplCopyWithImpl<$Res>
    extends _$ResonateUserCopyWithImpl<$Res, _$ResonateUserImpl>
    implements _$$ResonateUserImplCopyWith<$Res> {
  __$$ResonateUserImplCopyWithImpl(
      _$ResonateUserImpl _value, $Res Function(_$ResonateUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResonateUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? userName = freezed,
    Object? profileImageUrl = freezed,
    Object? gender = freezed,
    Object? dateOfBirth = freezed,
  }) {
    return _then(_$ResonateUserImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResonateUserImpl implements _ResonateUser {
  const _$ResonateUserImpl(
      {this.uid,
      this.userName,
      this.profileImageUrl,
      this.gender,
      this.dateOfBirth});

  factory _$ResonateUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResonateUserImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? userName;
  @override
  final String? profileImageUrl;
  @override
  final String? gender;
  @override
  final String? dateOfBirth;

  @override
  String toString() {
    return 'ResonateUser(uid: $uid, userName: $userName, profileImageUrl: $profileImageUrl, gender: $gender, dateOfBirth: $dateOfBirth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResonateUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, uid, userName, profileImageUrl, gender, dateOfBirth);

  /// Create a copy of ResonateUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResonateUserImplCopyWith<_$ResonateUserImpl> get copyWith =>
      __$$ResonateUserImplCopyWithImpl<_$ResonateUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResonateUserImplToJson(
      this,
    );
  }
}

abstract class _ResonateUser implements ResonateUser {
  const factory _ResonateUser(
      {final String? uid,
      final String? userName,
      final String? profileImageUrl,
      final String? gender,
      final String? dateOfBirth}) = _$ResonateUserImpl;

  factory _ResonateUser.fromJson(Map<String, dynamic> json) =
      _$ResonateUserImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get userName;
  @override
  String? get profileImageUrl;
  @override
  String? get gender;
  @override
  String? get dateOfBirth;

  /// Create a copy of ResonateUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResonateUserImplCopyWith<_$ResonateUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
