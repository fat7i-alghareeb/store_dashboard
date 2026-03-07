// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthViewState {

 BlocStatus<void> get signInStatus;
/// Create a copy of AuthViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthViewStateCopyWith<AuthViewState> get copyWith => _$AuthViewStateCopyWithImpl<AuthViewState>(this as AuthViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthViewState&&(identical(other.signInStatus, signInStatus) || other.signInStatus == signInStatus));
}


@override
int get hashCode => Object.hash(runtimeType,signInStatus);

@override
String toString() {
  return 'AuthViewState(signInStatus: $signInStatus)';
}


}

/// @nodoc
abstract mixin class $AuthViewStateCopyWith<$Res>  {
  factory $AuthViewStateCopyWith(AuthViewState value, $Res Function(AuthViewState) _then) = _$AuthViewStateCopyWithImpl;
@useResult
$Res call({
 BlocStatus<void> signInStatus
});


$BlocStatusCopyWith<void, $Res> get signInStatus;

}
/// @nodoc
class _$AuthViewStateCopyWithImpl<$Res>
    implements $AuthViewStateCopyWith<$Res> {
  _$AuthViewStateCopyWithImpl(this._self, this._then);

  final AuthViewState _self;
  final $Res Function(AuthViewState) _then;

/// Create a copy of AuthViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? signInStatus = null,}) {
  return _then(_self.copyWith(
signInStatus: null == signInStatus ? _self.signInStatus : signInStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<void>,
  ));
}
/// Create a copy of AuthViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<void, $Res> get signInStatus {
  
  return $BlocStatusCopyWith<void, $Res>(_self.signInStatus, (value) {
    return _then(_self.copyWith(signInStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthViewState].
extension AuthViewStatePatterns on AuthViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthViewState value)  $default,){
final _that = this;
switch (_that) {
case _AuthViewState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthViewState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BlocStatus<void> signInStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthViewState() when $default != null:
return $default(_that.signInStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BlocStatus<void> signInStatus)  $default,) {final _that = this;
switch (_that) {
case _AuthViewState():
return $default(_that.signInStatus);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BlocStatus<void> signInStatus)?  $default,) {final _that = this;
switch (_that) {
case _AuthViewState() when $default != null:
return $default(_that.signInStatus);case _:
  return null;

}
}

}

/// @nodoc


class _AuthViewState extends AuthViewState {
  const _AuthViewState({required this.signInStatus}): super._();
  

@override final  BlocStatus<void> signInStatus;

/// Create a copy of AuthViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthViewStateCopyWith<_AuthViewState> get copyWith => __$AuthViewStateCopyWithImpl<_AuthViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthViewState&&(identical(other.signInStatus, signInStatus) || other.signInStatus == signInStatus));
}


@override
int get hashCode => Object.hash(runtimeType,signInStatus);

@override
String toString() {
  return 'AuthViewState(signInStatus: $signInStatus)';
}


}

/// @nodoc
abstract mixin class _$AuthViewStateCopyWith<$Res> implements $AuthViewStateCopyWith<$Res> {
  factory _$AuthViewStateCopyWith(_AuthViewState value, $Res Function(_AuthViewState) _then) = __$AuthViewStateCopyWithImpl;
@override @useResult
$Res call({
 BlocStatus<void> signInStatus
});


@override $BlocStatusCopyWith<void, $Res> get signInStatus;

}
/// @nodoc
class __$AuthViewStateCopyWithImpl<$Res>
    implements _$AuthViewStateCopyWith<$Res> {
  __$AuthViewStateCopyWithImpl(this._self, this._then);

  final _AuthViewState _self;
  final $Res Function(_AuthViewState) _then;

/// Create a copy of AuthViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? signInStatus = null,}) {
  return _then(_AuthViewState(
signInStatus: null == signInStatus ? _self.signInStatus : signInStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<void>,
  ));
}

/// Create a copy of AuthViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<void, $Res> get signInStatus {
  
  return $BlocStatusCopyWith<void, $Res>(_self.signInStatus, (value) {
    return _then(_self.copyWith(signInStatus: value));
  });
}
}

// dart format on
