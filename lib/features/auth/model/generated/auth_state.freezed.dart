// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthStateUnknown value)?  unknown,TResult Function( AuthStateUnauthenticated value)?  unauthenticated,TResult Function( AuthStateNeedsOnboarding value)?  needsOnboarding,TResult Function( AuthStateBlocked value)?  blocked,TResult Function( AuthStateAuthenticated value)?  authenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthStateUnknown() when unknown != null:
return unknown(_that);case AuthStateUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthStateNeedsOnboarding() when needsOnboarding != null:
return needsOnboarding(_that);case AuthStateBlocked() when blocked != null:
return blocked(_that);case AuthStateAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthStateUnknown value)  unknown,required TResult Function( AuthStateUnauthenticated value)  unauthenticated,required TResult Function( AuthStateNeedsOnboarding value)  needsOnboarding,required TResult Function( AuthStateBlocked value)  blocked,required TResult Function( AuthStateAuthenticated value)  authenticated,}){
final _that = this;
switch (_that) {
case AuthStateUnknown():
return unknown(_that);case AuthStateUnauthenticated():
return unauthenticated(_that);case AuthStateNeedsOnboarding():
return needsOnboarding(_that);case AuthStateBlocked():
return blocked(_that);case AuthStateAuthenticated():
return authenticated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthStateUnknown value)?  unknown,TResult? Function( AuthStateUnauthenticated value)?  unauthenticated,TResult? Function( AuthStateNeedsOnboarding value)?  needsOnboarding,TResult? Function( AuthStateBlocked value)?  blocked,TResult? Function( AuthStateAuthenticated value)?  authenticated,}){
final _that = this;
switch (_that) {
case AuthStateUnknown() when unknown != null:
return unknown(_that);case AuthStateUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthStateNeedsOnboarding() when needsOnboarding != null:
return needsOnboarding(_that);case AuthStateBlocked() when blocked != null:
return blocked(_that);case AuthStateAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function()?  unauthenticated,TResult Function( AuthUser user)?  needsOnboarding,TResult Function( AuthUser user)?  blocked,TResult Function( AuthUser user)?  authenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthStateUnknown() when unknown != null:
return unknown();case AuthStateUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthStateNeedsOnboarding() when needsOnboarding != null:
return needsOnboarding(_that.user);case AuthStateBlocked() when blocked != null:
return blocked(_that.user);case AuthStateAuthenticated() when authenticated != null:
return authenticated(_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function()  unauthenticated,required TResult Function( AuthUser user)  needsOnboarding,required TResult Function( AuthUser user)  blocked,required TResult Function( AuthUser user)  authenticated,}) {final _that = this;
switch (_that) {
case AuthStateUnknown():
return unknown();case AuthStateUnauthenticated():
return unauthenticated();case AuthStateNeedsOnboarding():
return needsOnboarding(_that.user);case AuthStateBlocked():
return blocked(_that.user);case AuthStateAuthenticated():
return authenticated(_that.user);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function()?  unauthenticated,TResult? Function( AuthUser user)?  needsOnboarding,TResult? Function( AuthUser user)?  blocked,TResult? Function( AuthUser user)?  authenticated,}) {final _that = this;
switch (_that) {
case AuthStateUnknown() when unknown != null:
return unknown();case AuthStateUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthStateNeedsOnboarding() when needsOnboarding != null:
return needsOnboarding(_that.user);case AuthStateBlocked() when blocked != null:
return blocked(_that.user);case AuthStateAuthenticated() when authenticated != null:
return authenticated(_that.user);case _:
  return null;

}
}

}

/// @nodoc


class AuthStateUnknown extends AuthState {
  const AuthStateUnknown(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unknown()';
}


}




/// @nodoc


class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateUnauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class AuthStateNeedsOnboarding extends AuthState {
  const AuthStateNeedsOnboarding(this.user): super._();
  

 final  AuthUser user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateNeedsOnboardingCopyWith<AuthStateNeedsOnboarding> get copyWith => _$AuthStateNeedsOnboardingCopyWithImpl<AuthStateNeedsOnboarding>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateNeedsOnboarding&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.needsOnboarding(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthStateNeedsOnboardingCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthStateNeedsOnboardingCopyWith(AuthStateNeedsOnboarding value, $Res Function(AuthStateNeedsOnboarding) _then) = _$AuthStateNeedsOnboardingCopyWithImpl;
@useResult
$Res call({
 AuthUser user
});


$AuthUserCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthStateNeedsOnboardingCopyWithImpl<$Res>
    implements $AuthStateNeedsOnboardingCopyWith<$Res> {
  _$AuthStateNeedsOnboardingCopyWithImpl(this._self, this._then);

  final AuthStateNeedsOnboarding _self;
  final $Res Function(AuthStateNeedsOnboarding) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(AuthStateNeedsOnboarding(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res> get user {
  
  return $AuthUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class AuthStateBlocked extends AuthState {
  const AuthStateBlocked(this.user): super._();
  

 final  AuthUser user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateBlockedCopyWith<AuthStateBlocked> get copyWith => _$AuthStateBlockedCopyWithImpl<AuthStateBlocked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateBlocked&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.blocked(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthStateBlockedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthStateBlockedCopyWith(AuthStateBlocked value, $Res Function(AuthStateBlocked) _then) = _$AuthStateBlockedCopyWithImpl;
@useResult
$Res call({
 AuthUser user
});


$AuthUserCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthStateBlockedCopyWithImpl<$Res>
    implements $AuthStateBlockedCopyWith<$Res> {
  _$AuthStateBlockedCopyWithImpl(this._self, this._then);

  final AuthStateBlocked _self;
  final $Res Function(AuthStateBlocked) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(AuthStateBlocked(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res> get user {
  
  return $AuthUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated(this.user): super._();
  

 final  AuthUser user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateAuthenticatedCopyWith<AuthStateAuthenticated> get copyWith => _$AuthStateAuthenticatedCopyWithImpl<AuthStateAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateAuthenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthStateAuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthStateAuthenticatedCopyWith(AuthStateAuthenticated value, $Res Function(AuthStateAuthenticated) _then) = _$AuthStateAuthenticatedCopyWithImpl;
@useResult
$Res call({
 AuthUser user
});


$AuthUserCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthStateAuthenticatedCopyWithImpl<$Res>
    implements $AuthStateAuthenticatedCopyWith<$Res> {
  _$AuthStateAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthStateAuthenticated _self;
  final $Res Function(AuthStateAuthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(AuthStateAuthenticated(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUser,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserCopyWith<$Res> get user {
  
  return $AuthUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
