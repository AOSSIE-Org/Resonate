// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../friends_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FriendsFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendsFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FriendsFailure()';
}


}

/// @nodoc
class $FriendsFailureCopyWith<$Res>  {
$FriendsFailureCopyWith(FriendsFailure _, $Res Function(FriendsFailure) __);
}


/// Adds pattern-matching-related methods to [FriendsFailure].
extension FriendsFailurePatterns on FriendsFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FriendsFailureNotFound value)?  notFound,TResult Function( FriendsFailureNetwork value)?  network,TResult Function( FriendsFailurePermissionDenied value)?  permissionDenied,TResult Function( FriendsFailureUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FriendsFailureNotFound() when notFound != null:
return notFound(_that);case FriendsFailureNetwork() when network != null:
return network(_that);case FriendsFailurePermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case FriendsFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FriendsFailureNotFound value)  notFound,required TResult Function( FriendsFailureNetwork value)  network,required TResult Function( FriendsFailurePermissionDenied value)  permissionDenied,required TResult Function( FriendsFailureUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case FriendsFailureNotFound():
return notFound(_that);case FriendsFailureNetwork():
return network(_that);case FriendsFailurePermissionDenied():
return permissionDenied(_that);case FriendsFailureUnknown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FriendsFailureNotFound value)?  notFound,TResult? Function( FriendsFailureNetwork value)?  network,TResult? Function( FriendsFailurePermissionDenied value)?  permissionDenied,TResult? Function( FriendsFailureUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case FriendsFailureNotFound() when notFound != null:
return notFound(_that);case FriendsFailureNetwork() when network != null:
return network(_that);case FriendsFailurePermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case FriendsFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  notFound,TResult Function()?  network,TResult Function()?  permissionDenied,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FriendsFailureNotFound() when notFound != null:
return notFound();case FriendsFailureNetwork() when network != null:
return network();case FriendsFailurePermissionDenied() when permissionDenied != null:
return permissionDenied();case FriendsFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  notFound,required TResult Function()  network,required TResult Function()  permissionDenied,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case FriendsFailureNotFound():
return notFound();case FriendsFailureNetwork():
return network();case FriendsFailurePermissionDenied():
return permissionDenied();case FriendsFailureUnknown():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  notFound,TResult? Function()?  network,TResult? Function()?  permissionDenied,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case FriendsFailureNotFound() when notFound != null:
return notFound();case FriendsFailureNetwork() when network != null:
return network();case FriendsFailurePermissionDenied() when permissionDenied != null:
return permissionDenied();case FriendsFailureUnknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class FriendsFailureNotFound implements FriendsFailure {
  const FriendsFailureNotFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendsFailureNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FriendsFailure.notFound()';
}


}




/// @nodoc


class FriendsFailureNetwork implements FriendsFailure {
  const FriendsFailureNetwork();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendsFailureNetwork);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FriendsFailure.network()';
}


}




/// @nodoc


class FriendsFailurePermissionDenied implements FriendsFailure {
  const FriendsFailurePermissionDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendsFailurePermissionDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FriendsFailure.permissionDenied()';
}


}




/// @nodoc


class FriendsFailureUnknown implements FriendsFailure {
  const FriendsFailureUnknown(this.message);
  

 final  String message;

/// Create a copy of FriendsFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendsFailureUnknownCopyWith<FriendsFailureUnknown> get copyWith => _$FriendsFailureUnknownCopyWithImpl<FriendsFailureUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendsFailureUnknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FriendsFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $FriendsFailureUnknownCopyWith<$Res> implements $FriendsFailureCopyWith<$Res> {
  factory $FriendsFailureUnknownCopyWith(FriendsFailureUnknown value, $Res Function(FriendsFailureUnknown) _then) = _$FriendsFailureUnknownCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FriendsFailureUnknownCopyWithImpl<$Res>
    implements $FriendsFailureUnknownCopyWith<$Res> {
  _$FriendsFailureUnknownCopyWithImpl(this._self, this._then);

  final FriendsFailureUnknown _self;
  final $Res Function(FriendsFailureUnknown) _then;

/// Create a copy of FriendsFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(FriendsFailureUnknown(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
