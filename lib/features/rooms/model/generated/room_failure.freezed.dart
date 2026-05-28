// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../room_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoomFailure()';
}


}

/// @nodoc
class $RoomFailureCopyWith<$Res>  {
$RoomFailureCopyWith(RoomFailure _, $Res Function(RoomFailure) __);
}


/// Adds pattern-matching-related methods to [RoomFailure].
extension RoomFailurePatterns on RoomFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RoomFailureNotFound value)?  notFound,TResult Function( RoomFailureNetwork value)?  network,TResult Function( RoomFailureLiveKit value)?  liveKit,TResult Function( RoomFailurePermissionDenied value)?  permissionDenied,TResult Function( RoomFailureUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RoomFailureNotFound() when notFound != null:
return notFound(_that);case RoomFailureNetwork() when network != null:
return network(_that);case RoomFailureLiveKit() when liveKit != null:
return liveKit(_that);case RoomFailurePermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case RoomFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RoomFailureNotFound value)  notFound,required TResult Function( RoomFailureNetwork value)  network,required TResult Function( RoomFailureLiveKit value)  liveKit,required TResult Function( RoomFailurePermissionDenied value)  permissionDenied,required TResult Function( RoomFailureUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case RoomFailureNotFound():
return notFound(_that);case RoomFailureNetwork():
return network(_that);case RoomFailureLiveKit():
return liveKit(_that);case RoomFailurePermissionDenied():
return permissionDenied(_that);case RoomFailureUnknown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RoomFailureNotFound value)?  notFound,TResult? Function( RoomFailureNetwork value)?  network,TResult? Function( RoomFailureLiveKit value)?  liveKit,TResult? Function( RoomFailurePermissionDenied value)?  permissionDenied,TResult? Function( RoomFailureUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case RoomFailureNotFound() when notFound != null:
return notFound(_that);case RoomFailureNetwork() when network != null:
return network(_that);case RoomFailureLiveKit() when liveKit != null:
return liveKit(_that);case RoomFailurePermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case RoomFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  notFound,TResult Function()?  network,TResult Function( String message)?  liveKit,TResult Function()?  permissionDenied,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RoomFailureNotFound() when notFound != null:
return notFound();case RoomFailureNetwork() when network != null:
return network();case RoomFailureLiveKit() when liveKit != null:
return liveKit(_that.message);case RoomFailurePermissionDenied() when permissionDenied != null:
return permissionDenied();case RoomFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  notFound,required TResult Function()  network,required TResult Function( String message)  liveKit,required TResult Function()  permissionDenied,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case RoomFailureNotFound():
return notFound();case RoomFailureNetwork():
return network();case RoomFailureLiveKit():
return liveKit(_that.message);case RoomFailurePermissionDenied():
return permissionDenied();case RoomFailureUnknown():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  notFound,TResult? Function()?  network,TResult? Function( String message)?  liveKit,TResult? Function()?  permissionDenied,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case RoomFailureNotFound() when notFound != null:
return notFound();case RoomFailureNetwork() when network != null:
return network();case RoomFailureLiveKit() when liveKit != null:
return liveKit(_that.message);case RoomFailurePermissionDenied() when permissionDenied != null:
return permissionDenied();case RoomFailureUnknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class RoomFailureNotFound implements RoomFailure {
  const RoomFailureNotFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomFailureNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoomFailure.notFound()';
}


}




/// @nodoc


class RoomFailureNetwork implements RoomFailure {
  const RoomFailureNetwork();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomFailureNetwork);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoomFailure.network()';
}


}




/// @nodoc


class RoomFailureLiveKit implements RoomFailure {
  const RoomFailureLiveKit(this.message);
  

 final  String message;

/// Create a copy of RoomFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomFailureLiveKitCopyWith<RoomFailureLiveKit> get copyWith => _$RoomFailureLiveKitCopyWithImpl<RoomFailureLiveKit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomFailureLiveKit&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RoomFailure.liveKit(message: $message)';
}


}

/// @nodoc
abstract mixin class $RoomFailureLiveKitCopyWith<$Res> implements $RoomFailureCopyWith<$Res> {
  factory $RoomFailureLiveKitCopyWith(RoomFailureLiveKit value, $Res Function(RoomFailureLiveKit) _then) = _$RoomFailureLiveKitCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$RoomFailureLiveKitCopyWithImpl<$Res>
    implements $RoomFailureLiveKitCopyWith<$Res> {
  _$RoomFailureLiveKitCopyWithImpl(this._self, this._then);

  final RoomFailureLiveKit _self;
  final $Res Function(RoomFailureLiveKit) _then;

/// Create a copy of RoomFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(RoomFailureLiveKit(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RoomFailurePermissionDenied implements RoomFailure {
  const RoomFailurePermissionDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomFailurePermissionDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoomFailure.permissionDenied()';
}


}




/// @nodoc


class RoomFailureUnknown implements RoomFailure {
  const RoomFailureUnknown(this.message);
  

 final  String message;

/// Create a copy of RoomFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomFailureUnknownCopyWith<RoomFailureUnknown> get copyWith => _$RoomFailureUnknownCopyWithImpl<RoomFailureUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomFailureUnknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RoomFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $RoomFailureUnknownCopyWith<$Res> implements $RoomFailureCopyWith<$Res> {
  factory $RoomFailureUnknownCopyWith(RoomFailureUnknown value, $Res Function(RoomFailureUnknown) _then) = _$RoomFailureUnknownCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$RoomFailureUnknownCopyWithImpl<$Res>
    implements $RoomFailureUnknownCopyWith<$Res> {
  _$RoomFailureUnknownCopyWithImpl(this._self, this._then);

  final RoomFailureUnknown _self;
  final $Res Function(RoomFailureUnknown) _then;

/// Create a copy of RoomFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(RoomFailureUnknown(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
