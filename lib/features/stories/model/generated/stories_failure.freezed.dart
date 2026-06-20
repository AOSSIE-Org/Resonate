// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../stories_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoriesFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoriesFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoriesFailure()';
}


}

/// @nodoc
class $StoriesFailureCopyWith<$Res>  {
$StoriesFailureCopyWith(StoriesFailure _, $Res Function(StoriesFailure) __);
}


/// Adds pattern-matching-related methods to [StoriesFailure].
extension StoriesFailurePatterns on StoriesFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StoriesFailureUpload value)?  upload,TResult Function( StoriesFailureNetwork value)?  network,TResult Function( StoriesFailureUnknown value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StoriesFailureUpload() when upload != null:
return upload(_that);case StoriesFailureNetwork() when network != null:
return network(_that);case StoriesFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StoriesFailureUpload value)  upload,required TResult Function( StoriesFailureNetwork value)  network,required TResult Function( StoriesFailureUnknown value)  unknown,}){
final _that = this;
switch (_that) {
case StoriesFailureUpload():
return upload(_that);case StoriesFailureNetwork():
return network(_that);case StoriesFailureUnknown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StoriesFailureUpload value)?  upload,TResult? Function( StoriesFailureNetwork value)?  network,TResult? Function( StoriesFailureUnknown value)?  unknown,}){
final _that = this;
switch (_that) {
case StoriesFailureUpload() when upload != null:
return upload(_that);case StoriesFailureNetwork() when network != null:
return network(_that);case StoriesFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String what)?  upload,TResult Function()?  network,TResult Function( String message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StoriesFailureUpload() when upload != null:
return upload(_that.what);case StoriesFailureNetwork() when network != null:
return network();case StoriesFailureUnknown() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String what)  upload,required TResult Function()  network,required TResult Function( String message)  unknown,}) {final _that = this;
switch (_that) {
case StoriesFailureUpload():
return upload(_that.what);case StoriesFailureNetwork():
return network();case StoriesFailureUnknown():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String what)?  upload,TResult? Function()?  network,TResult? Function( String message)?  unknown,}) {final _that = this;
switch (_that) {
case StoriesFailureUpload() when upload != null:
return upload(_that.what);case StoriesFailureNetwork() when network != null:
return network();case StoriesFailureUnknown() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class StoriesFailureUpload implements StoriesFailure {
  const StoriesFailureUpload(this.what);
  

 final  String what;

/// Create a copy of StoriesFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoriesFailureUploadCopyWith<StoriesFailureUpload> get copyWith => _$StoriesFailureUploadCopyWithImpl<StoriesFailureUpload>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoriesFailureUpload&&(identical(other.what, what) || other.what == what));
}


@override
int get hashCode => Object.hash(runtimeType,what);

@override
String toString() {
  return 'StoriesFailure.upload(what: $what)';
}


}

/// @nodoc
abstract mixin class $StoriesFailureUploadCopyWith<$Res> implements $StoriesFailureCopyWith<$Res> {
  factory $StoriesFailureUploadCopyWith(StoriesFailureUpload value, $Res Function(StoriesFailureUpload) _then) = _$StoriesFailureUploadCopyWithImpl;
@useResult
$Res call({
 String what
});




}
/// @nodoc
class _$StoriesFailureUploadCopyWithImpl<$Res>
    implements $StoriesFailureUploadCopyWith<$Res> {
  _$StoriesFailureUploadCopyWithImpl(this._self, this._then);

  final StoriesFailureUpload _self;
  final $Res Function(StoriesFailureUpload) _then;

/// Create a copy of StoriesFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? what = null,}) {
  return _then(StoriesFailureUpload(
null == what ? _self.what : what // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class StoriesFailureNetwork implements StoriesFailure {
  const StoriesFailureNetwork();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoriesFailureNetwork);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoriesFailure.network()';
}


}




/// @nodoc


class StoriesFailureUnknown implements StoriesFailure {
  const StoriesFailureUnknown(this.message);
  

 final  String message;

/// Create a copy of StoriesFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoriesFailureUnknownCopyWith<StoriesFailureUnknown> get copyWith => _$StoriesFailureUnknownCopyWithImpl<StoriesFailureUnknown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoriesFailureUnknown&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'StoriesFailure.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $StoriesFailureUnknownCopyWith<$Res> implements $StoriesFailureCopyWith<$Res> {
  factory $StoriesFailureUnknownCopyWith(StoriesFailureUnknown value, $Res Function(StoriesFailureUnknown) _then) = _$StoriesFailureUnknownCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$StoriesFailureUnknownCopyWithImpl<$Res>
    implements $StoriesFailureUnknownCopyWith<$Res> {
  _$StoriesFailureUnknownCopyWithImpl(this._self, this._then);

  final StoriesFailureUnknown _self;
  final $Res Function(StoriesFailureUnknown) _then;

/// Create a copy of StoriesFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(StoriesFailureUnknown(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
