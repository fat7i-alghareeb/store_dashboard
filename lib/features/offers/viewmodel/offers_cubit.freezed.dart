// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offers_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OffersState {

 BlocStatus<List<OfferItem>> get offersStatus; BlocStatus<void> get actionStatus;
/// Create a copy of OffersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OffersStateCopyWith<OffersState> get copyWith => _$OffersStateCopyWithImpl<OffersState>(this as OffersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OffersState&&(identical(other.offersStatus, offersStatus) || other.offersStatus == offersStatus)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus));
}


@override
int get hashCode => Object.hash(runtimeType,offersStatus,actionStatus);

@override
String toString() {
  return 'OffersState(offersStatus: $offersStatus, actionStatus: $actionStatus)';
}


}

/// @nodoc
abstract mixin class $OffersStateCopyWith<$Res>  {
  factory $OffersStateCopyWith(OffersState value, $Res Function(OffersState) _then) = _$OffersStateCopyWithImpl;
@useResult
$Res call({
 BlocStatus<List<OfferItem>> offersStatus, BlocStatus<void> actionStatus
});


$BlocStatusCopyWith<List<OfferItem>, $Res> get offersStatus;$BlocStatusCopyWith<void, $Res> get actionStatus;

}
/// @nodoc
class _$OffersStateCopyWithImpl<$Res>
    implements $OffersStateCopyWith<$Res> {
  _$OffersStateCopyWithImpl(this._self, this._then);

  final OffersState _self;
  final $Res Function(OffersState) _then;

/// Create a copy of OffersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? offersStatus = null,Object? actionStatus = null,}) {
  return _then(_self.copyWith(
offersStatus: null == offersStatus ? _self.offersStatus : offersStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<List<OfferItem>>,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<void>,
  ));
}
/// Create a copy of OffersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<List<OfferItem>, $Res> get offersStatus {
  
  return $BlocStatusCopyWith<List<OfferItem>, $Res>(_self.offersStatus, (value) {
    return _then(_self.copyWith(offersStatus: value));
  });
}/// Create a copy of OffersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<void, $Res> get actionStatus {
  
  return $BlocStatusCopyWith<void, $Res>(_self.actionStatus, (value) {
    return _then(_self.copyWith(actionStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [OffersState].
extension OffersStatePatterns on OffersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OffersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OffersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OffersState value)  $default,){
final _that = this;
switch (_that) {
case _OffersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OffersState value)?  $default,){
final _that = this;
switch (_that) {
case _OffersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BlocStatus<List<OfferItem>> offersStatus,  BlocStatus<void> actionStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OffersState() when $default != null:
return $default(_that.offersStatus,_that.actionStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BlocStatus<List<OfferItem>> offersStatus,  BlocStatus<void> actionStatus)  $default,) {final _that = this;
switch (_that) {
case _OffersState():
return $default(_that.offersStatus,_that.actionStatus);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BlocStatus<List<OfferItem>> offersStatus,  BlocStatus<void> actionStatus)?  $default,) {final _that = this;
switch (_that) {
case _OffersState() when $default != null:
return $default(_that.offersStatus,_that.actionStatus);case _:
  return null;

}
}

}

/// @nodoc


class _OffersState extends OffersState {
  const _OffersState({required this.offersStatus, required this.actionStatus}): super._();
  

@override final  BlocStatus<List<OfferItem>> offersStatus;
@override final  BlocStatus<void> actionStatus;

/// Create a copy of OffersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OffersStateCopyWith<_OffersState> get copyWith => __$OffersStateCopyWithImpl<_OffersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OffersState&&(identical(other.offersStatus, offersStatus) || other.offersStatus == offersStatus)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus));
}


@override
int get hashCode => Object.hash(runtimeType,offersStatus,actionStatus);

@override
String toString() {
  return 'OffersState(offersStatus: $offersStatus, actionStatus: $actionStatus)';
}


}

/// @nodoc
abstract mixin class _$OffersStateCopyWith<$Res> implements $OffersStateCopyWith<$Res> {
  factory _$OffersStateCopyWith(_OffersState value, $Res Function(_OffersState) _then) = __$OffersStateCopyWithImpl;
@override @useResult
$Res call({
 BlocStatus<List<OfferItem>> offersStatus, BlocStatus<void> actionStatus
});


@override $BlocStatusCopyWith<List<OfferItem>, $Res> get offersStatus;@override $BlocStatusCopyWith<void, $Res> get actionStatus;

}
/// @nodoc
class __$OffersStateCopyWithImpl<$Res>
    implements _$OffersStateCopyWith<$Res> {
  __$OffersStateCopyWithImpl(this._self, this._then);

  final _OffersState _self;
  final $Res Function(_OffersState) _then;

/// Create a copy of OffersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? offersStatus = null,Object? actionStatus = null,}) {
  return _then(_OffersState(
offersStatus: null == offersStatus ? _self.offersStatus : offersStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<List<OfferItem>>,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<void>,
  ));
}

/// Create a copy of OffersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<List<OfferItem>, $Res> get offersStatus {
  
  return $BlocStatusCopyWith<List<OfferItem>, $Res>(_self.offersStatus, (value) {
    return _then(_self.copyWith(offersStatus: value));
  });
}/// Create a copy of OffersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<void, $Res> get actionStatus {
  
  return $BlocStatusCopyWith<void, $Res>(_self.actionStatus, (value) {
    return _then(_self.copyWith(actionStatus: value));
  });
}
}

// dart format on
