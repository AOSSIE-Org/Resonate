// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../rooms_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomsState {

 List<AppwriteRoom> get rooms; List<AppwriteRoom> get filteredRooms; bool get isSearching; bool get searchBarIsEmpty;
/// Create a copy of RoomsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomsStateCopyWith<RoomsState> get copyWith => _$RoomsStateCopyWithImpl<RoomsState>(this as RoomsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomsState&&const DeepCollectionEquality().equals(other.rooms, rooms)&&const DeepCollectionEquality().equals(other.filteredRooms, filteredRooms)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.searchBarIsEmpty, searchBarIsEmpty) || other.searchBarIsEmpty == searchBarIsEmpty));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rooms),const DeepCollectionEquality().hash(filteredRooms),isSearching,searchBarIsEmpty);

@override
String toString() {
  return 'RoomsState(rooms: $rooms, filteredRooms: $filteredRooms, isSearching: $isSearching, searchBarIsEmpty: $searchBarIsEmpty)';
}


}

/// @nodoc
abstract mixin class $RoomsStateCopyWith<$Res>  {
  factory $RoomsStateCopyWith(RoomsState value, $Res Function(RoomsState) _then) = _$RoomsStateCopyWithImpl;
@useResult
$Res call({
 List<AppwriteRoom> rooms, List<AppwriteRoom> filteredRooms, bool isSearching, bool searchBarIsEmpty
});




}
/// @nodoc
class _$RoomsStateCopyWithImpl<$Res>
    implements $RoomsStateCopyWith<$Res> {
  _$RoomsStateCopyWithImpl(this._self, this._then);

  final RoomsState _self;
  final $Res Function(RoomsState) _then;

/// Create a copy of RoomsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rooms = null,Object? filteredRooms = null,Object? isSearching = null,Object? searchBarIsEmpty = null,}) {
  return _then(_self.copyWith(
rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<AppwriteRoom>,filteredRooms: null == filteredRooms ? _self.filteredRooms : filteredRooms // ignore: cast_nullable_to_non_nullable
as List<AppwriteRoom>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,searchBarIsEmpty: null == searchBarIsEmpty ? _self.searchBarIsEmpty : searchBarIsEmpty // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomsState].
extension RoomsStatePatterns on RoomsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RoomsStateReady value)?  ready,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RoomsStateReady() when ready != null:
return ready(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RoomsStateReady value)  ready,}){
final _that = this;
switch (_that) {
case RoomsStateReady():
return ready(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RoomsStateReady value)?  ready,}){
final _that = this;
switch (_that) {
case RoomsStateReady() when ready != null:
return ready(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<AppwriteRoom> rooms,  List<AppwriteRoom> filteredRooms,  bool isSearching,  bool searchBarIsEmpty)?  ready,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RoomsStateReady() when ready != null:
return ready(_that.rooms,_that.filteredRooms,_that.isSearching,_that.searchBarIsEmpty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<AppwriteRoom> rooms,  List<AppwriteRoom> filteredRooms,  bool isSearching,  bool searchBarIsEmpty)  ready,}) {final _that = this;
switch (_that) {
case RoomsStateReady():
return ready(_that.rooms,_that.filteredRooms,_that.isSearching,_that.searchBarIsEmpty);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<AppwriteRoom> rooms,  List<AppwriteRoom> filteredRooms,  bool isSearching,  bool searchBarIsEmpty)?  ready,}) {final _that = this;
switch (_that) {
case RoomsStateReady() when ready != null:
return ready(_that.rooms,_that.filteredRooms,_that.isSearching,_that.searchBarIsEmpty);case _:
  return null;

}
}

}

/// @nodoc


class RoomsStateReady extends RoomsState {
  const RoomsStateReady({final  List<AppwriteRoom> rooms = const <AppwriteRoom>[], final  List<AppwriteRoom> filteredRooms = const <AppwriteRoom>[], this.isSearching = false, this.searchBarIsEmpty = true}): _rooms = rooms,_filteredRooms = filteredRooms,super._();
  

 final  List<AppwriteRoom> _rooms;
@override@JsonKey() List<AppwriteRoom> get rooms {
  if (_rooms is EqualUnmodifiableListView) return _rooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rooms);
}

 final  List<AppwriteRoom> _filteredRooms;
@override@JsonKey() List<AppwriteRoom> get filteredRooms {
  if (_filteredRooms is EqualUnmodifiableListView) return _filteredRooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredRooms);
}

@override@JsonKey() final  bool isSearching;
@override@JsonKey() final  bool searchBarIsEmpty;

/// Create a copy of RoomsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomsStateReadyCopyWith<RoomsStateReady> get copyWith => _$RoomsStateReadyCopyWithImpl<RoomsStateReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomsStateReady&&const DeepCollectionEquality().equals(other._rooms, _rooms)&&const DeepCollectionEquality().equals(other._filteredRooms, _filteredRooms)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&(identical(other.searchBarIsEmpty, searchBarIsEmpty) || other.searchBarIsEmpty == searchBarIsEmpty));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rooms),const DeepCollectionEquality().hash(_filteredRooms),isSearching,searchBarIsEmpty);

@override
String toString() {
  return 'RoomsState.ready(rooms: $rooms, filteredRooms: $filteredRooms, isSearching: $isSearching, searchBarIsEmpty: $searchBarIsEmpty)';
}


}

/// @nodoc
abstract mixin class $RoomsStateReadyCopyWith<$Res> implements $RoomsStateCopyWith<$Res> {
  factory $RoomsStateReadyCopyWith(RoomsStateReady value, $Res Function(RoomsStateReady) _then) = _$RoomsStateReadyCopyWithImpl;
@override @useResult
$Res call({
 List<AppwriteRoom> rooms, List<AppwriteRoom> filteredRooms, bool isSearching, bool searchBarIsEmpty
});




}
/// @nodoc
class _$RoomsStateReadyCopyWithImpl<$Res>
    implements $RoomsStateReadyCopyWith<$Res> {
  _$RoomsStateReadyCopyWithImpl(this._self, this._then);

  final RoomsStateReady _self;
  final $Res Function(RoomsStateReady) _then;

/// Create a copy of RoomsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rooms = null,Object? filteredRooms = null,Object? isSearching = null,Object? searchBarIsEmpty = null,}) {
  return _then(RoomsStateReady(
rooms: null == rooms ? _self._rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<AppwriteRoom>,filteredRooms: null == filteredRooms ? _self._filteredRooms : filteredRooms // ignore: cast_nullable_to_non_nullable
as List<AppwriteRoom>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,searchBarIsEmpty: null == searchBarIsEmpty ? _self.searchBarIsEmpty : searchBarIsEmpty // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
