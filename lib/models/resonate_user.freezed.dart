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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
abstract class _$$_ResonateUserCopyWith<$Res>
    implements $ResonateUserCopyWith<$Res> {
  factory _$$_ResonateUserCopyWith(
          _$_ResonateUser value, $Res Function(_$_ResonateUser) then) =
      __$$_ResonateUserCopyWithImpl<$Res>;
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
class __$$_ResonateUserCopyWithImpl<$Res>
    extends _$ResonateUserCopyWithImpl<$Res, _$_ResonateUser>
    implements _$$_ResonateUserCopyWith<$Res> {
  __$$_ResonateUserCopyWithImpl(
      _$_ResonateUser _value, $Res Function(_$_ResonateUser) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? userName = freezed,
    Object? profileImageUrl = freezed,
    Object? gender = freezed,
    Object? dateOfBirth = freezed,
  }) {
    return _then(_$_ResonateUser(
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
class _$_ResonateUser implements _ResonateUser {
  const _$_ResonateUser(
      {this.uid,
      this.userName,
      this.profileImageUrl,
      this.gender,
      this.dateOfBirth});

  factory _$_ResonateUser.fromJson(Map<String, dynamic> json) =>
      _$$_ResonateUserFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ResonateUser &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uid, userName, profileImageUrl, gender, dateOfBirth);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ResonateUserCopyWith<_$_ResonateUser> get copyWith =>
      __$$_ResonateUserCopyWithImpl<_$_ResonateUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ResonateUserToJson(
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
      final String? dateOfBirth}) = _$_ResonateUser;

  factory _ResonateUser.fromJson(Map<String, dynamic> json) =
      _$_ResonateUser.fromJson;

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
  @override
  @JsonKey(ignore: true)
  _$$_ResonateUserCopyWith<_$_ResonateUser> get copyWith =>
      throw _privateConstructorUsedError;
}
