// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure()';
}


}

/// @nodoc
class $AuthFailureCopyWith<$Res>  {
$AuthFailureCopyWith(AuthFailure _, $Res Function(AuthFailure) __);
}


/// Adds pattern-matching-related methods to [AuthFailure].
extension AuthFailurePatterns on AuthFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthFailureInvalidCredentials value)?  invalidCredentials,TResult Function( AuthFailurePasswordTooShort value)?  passwordTooShort,TResult Function( AuthFailureUserAlreadyExists value)?  userAlreadyExists,TResult Function( AuthFailureNetwork value)?  network,TResult Function( AuthFailureUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthFailureInvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that);case AuthFailurePasswordTooShort() when passwordTooShort != null:
return passwordTooShort(_that);case AuthFailureUserAlreadyExists() when userAlreadyExists != null:
return userAlreadyExists(_that);case AuthFailureNetwork() when network != null:
return network(_that);case AuthFailureUnknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthFailureInvalidCredentials value)  invalidCredentials,required TResult Function( AuthFailurePasswordTooShort value)  passwordTooShort,required TResult Function( AuthFailureUserAlreadyExists value)  userAlreadyExists,required TResult Function( AuthFailureNetwork value)  network,required TResult Function( AuthFailureUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case AuthFailureInvalidCredentials():
return invalidCredentials(_that);case AuthFailurePasswordTooShort():
return passwordTooShort(_that);case AuthFailureUserAlreadyExists():
return userAlreadyExists(_that);case AuthFailureNetwork():
return network(_that);case AuthFailureUnknown():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthFailureInvalidCredentials value)?  invalidCredentials,TResult? Function( AuthFailurePasswordTooShort value)?  passwordTooShort,TResult? Function( AuthFailureUserAlreadyExists value)?  userAlreadyExists,TResult? Function( AuthFailureNetwork value)?  network,TResult? Function( AuthFailureUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case AuthFailureInvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that);case AuthFailurePasswordTooShort() when passwordTooShort != null:
return passwordTooShort(_that);case AuthFailureUserAlreadyExists() when userAlreadyExists != null:
return userAlreadyExists(_that);case AuthFailureNetwork() when network != null:
return network(_that);case AuthFailureUnknown() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalidCredentials,TResult Function()?  passwordTooShort,TResult Function()?  userAlreadyExists,TResult Function()?  network,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthFailureInvalidCredentials() when invalidCredentials != null:
return invalidCredentials();case AuthFailurePasswordTooShort() when passwordTooShort != null:
return passwordTooShort();case AuthFailureUserAlreadyExists() when userAlreadyExists != null:
return userAlreadyExists();case AuthFailureNetwork() when network != null:
return network();case AuthFailureUnknown() when unknown != null:
return unknown(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalidCredentials,required TResult Function()  passwordTooShort,required TResult Function()  userAlreadyExists,required TResult Function()  network,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case AuthFailureInvalidCredentials():
return invalidCredentials();case AuthFailurePasswordTooShort():
return passwordTooShort();case AuthFailureUserAlreadyExists():
return userAlreadyExists();case AuthFailureNetwork():
return network();case AuthFailureUnknown():
return unknown(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalidCredentials,TResult? Function()?  passwordTooShort,TResult? Function()?  userAlreadyExists,TResult? Function()?  network,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case AuthFailureInvalidCredentials() when invalidCredentials != null:
return invalidCredentials();case AuthFailurePasswordTooShort() when passwordTooShort != null:
return passwordTooShort();case AuthFailureUserAlreadyExists() when userAlreadyExists != null:
return userAlreadyExists();case AuthFailureNetwork() when network != null:
return network();case AuthFailureUnknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AuthFailureInvalidCredentials implements AuthFailure {
  const AuthFailureInvalidCredentials();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailureInvalidCredentials);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.invalidCredentials()';
}


}




/// @nodoc


class AuthFailurePasswordTooShort implements AuthFailure {
  const AuthFailurePasswordTooShort();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailurePasswordTooShort);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.passwordTooShort()';
}


}




/// @nodoc


class AuthFailureUserAlreadyExists implements AuthFailure {
  const AuthFailureUserAlreadyExists();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailureUserAlreadyExists);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.userAlreadyExists()';
}


}




/// @nodoc


class AuthFailureNetwork implements AuthFailure {
  const AuthFailureNetwork();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailureNetwork);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthFailure.network()';
}


}




/// @nodoc


class AuthFailureUnknown implements AuthFailure {
  const AuthFailureUnknown(this.message);
  

 final  String message;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthFailureUnknownCopyWith<AuthFailureUnknown> get copyWith => _$AuthFailureUnknownCopyWithImpl<AuthFailureUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailureUnknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthFailureUnknownCopyWith<$Res> implements $AuthFailureCopyWith<$Res> {
  factory $AuthFailureUnknownCopyWith(AuthFailureUnknown value, $Res Function(AuthFailureUnknown) _then) = _$AuthFailureUnknownCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthFailureUnknownCopyWithImpl<$Res>
    implements $AuthFailureUnknownCopyWith<$Res> {
  _$AuthFailureUnknownCopyWithImpl(this._self, this._then);

  final AuthFailureUnknown _self;
  final $Res Function(AuthFailureUnknown) _then;

/// Create a copy of AuthFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthFailureUnknown(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
