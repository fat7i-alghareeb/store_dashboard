// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductsState {

 BlocStatus<List<ProductSummaryItem>> get productsStatus; BlocStatus<List<ProductColor>> get colorsStatus; BlocStatus<List<CategoryItem>> get categoriesStatus; BlocStatus<void> get actionStatus;
/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductsStateCopyWith<ProductsState> get copyWith => _$ProductsStateCopyWithImpl<ProductsState>(this as ProductsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsState&&(identical(other.productsStatus, productsStatus) || other.productsStatus == productsStatus)&&(identical(other.colorsStatus, colorsStatus) || other.colorsStatus == colorsStatus)&&(identical(other.categoriesStatus, categoriesStatus) || other.categoriesStatus == categoriesStatus)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus));
}


@override
int get hashCode => Object.hash(runtimeType,productsStatus,colorsStatus,categoriesStatus,actionStatus);

@override
String toString() {
  return 'ProductsState(productsStatus: $productsStatus, colorsStatus: $colorsStatus, categoriesStatus: $categoriesStatus, actionStatus: $actionStatus)';
}


}

/// @nodoc
abstract mixin class $ProductsStateCopyWith<$Res>  {
  factory $ProductsStateCopyWith(ProductsState value, $Res Function(ProductsState) _then) = _$ProductsStateCopyWithImpl;
@useResult
$Res call({
 BlocStatus<List<ProductSummaryItem>> productsStatus, BlocStatus<List<ProductColor>> colorsStatus, BlocStatus<List<CategoryItem>> categoriesStatus, BlocStatus<void> actionStatus
});


$BlocStatusCopyWith<List<ProductSummaryItem>, $Res> get productsStatus;$BlocStatusCopyWith<List<ProductColor>, $Res> get colorsStatus;$BlocStatusCopyWith<List<CategoryItem>, $Res> get categoriesStatus;$BlocStatusCopyWith<void, $Res> get actionStatus;

}
/// @nodoc
class _$ProductsStateCopyWithImpl<$Res>
    implements $ProductsStateCopyWith<$Res> {
  _$ProductsStateCopyWithImpl(this._self, this._then);

  final ProductsState _self;
  final $Res Function(ProductsState) _then;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productsStatus = null,Object? colorsStatus = null,Object? categoriesStatus = null,Object? actionStatus = null,}) {
  return _then(_self.copyWith(
productsStatus: null == productsStatus ? _self.productsStatus : productsStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<List<ProductSummaryItem>>,colorsStatus: null == colorsStatus ? _self.colorsStatus : colorsStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<List<ProductColor>>,categoriesStatus: null == categoriesStatus ? _self.categoriesStatus : categoriesStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<List<CategoryItem>>,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<void>,
  ));
}
/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<List<ProductSummaryItem>, $Res> get productsStatus {
  
  return $BlocStatusCopyWith<List<ProductSummaryItem>, $Res>(_self.productsStatus, (value) {
    return _then(_self.copyWith(productsStatus: value));
  });
}/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<List<ProductColor>, $Res> get colorsStatus {
  
  return $BlocStatusCopyWith<List<ProductColor>, $Res>(_self.colorsStatus, (value) {
    return _then(_self.copyWith(colorsStatus: value));
  });
}/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<List<CategoryItem>, $Res> get categoriesStatus {
  
  return $BlocStatusCopyWith<List<CategoryItem>, $Res>(_self.categoriesStatus, (value) {
    return _then(_self.copyWith(categoriesStatus: value));
  });
}/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<void, $Res> get actionStatus {
  
  return $BlocStatusCopyWith<void, $Res>(_self.actionStatus, (value) {
    return _then(_self.copyWith(actionStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductsState].
extension ProductsStatePatterns on ProductsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductsState value)  $default,){
final _that = this;
switch (_that) {
case _ProductsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductsState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BlocStatus<List<ProductSummaryItem>> productsStatus,  BlocStatus<List<ProductColor>> colorsStatus,  BlocStatus<List<CategoryItem>> categoriesStatus,  BlocStatus<void> actionStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
return $default(_that.productsStatus,_that.colorsStatus,_that.categoriesStatus,_that.actionStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BlocStatus<List<ProductSummaryItem>> productsStatus,  BlocStatus<List<ProductColor>> colorsStatus,  BlocStatus<List<CategoryItem>> categoriesStatus,  BlocStatus<void> actionStatus)  $default,) {final _that = this;
switch (_that) {
case _ProductsState():
return $default(_that.productsStatus,_that.colorsStatus,_that.categoriesStatus,_that.actionStatus);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BlocStatus<List<ProductSummaryItem>> productsStatus,  BlocStatus<List<ProductColor>> colorsStatus,  BlocStatus<List<CategoryItem>> categoriesStatus,  BlocStatus<void> actionStatus)?  $default,) {final _that = this;
switch (_that) {
case _ProductsState() when $default != null:
return $default(_that.productsStatus,_that.colorsStatus,_that.categoriesStatus,_that.actionStatus);case _:
  return null;

}
}

}

/// @nodoc


class _ProductsState extends ProductsState {
  const _ProductsState({required this.productsStatus, required this.colorsStatus, required this.categoriesStatus, required this.actionStatus}): super._();
  

@override final  BlocStatus<List<ProductSummaryItem>> productsStatus;
@override final  BlocStatus<List<ProductColor>> colorsStatus;
@override final  BlocStatus<List<CategoryItem>> categoriesStatus;
@override final  BlocStatus<void> actionStatus;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductsStateCopyWith<_ProductsState> get copyWith => __$ProductsStateCopyWithImpl<_ProductsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductsState&&(identical(other.productsStatus, productsStatus) || other.productsStatus == productsStatus)&&(identical(other.colorsStatus, colorsStatus) || other.colorsStatus == colorsStatus)&&(identical(other.categoriesStatus, categoriesStatus) || other.categoriesStatus == categoriesStatus)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus));
}


@override
int get hashCode => Object.hash(runtimeType,productsStatus,colorsStatus,categoriesStatus,actionStatus);

@override
String toString() {
  return 'ProductsState(productsStatus: $productsStatus, colorsStatus: $colorsStatus, categoriesStatus: $categoriesStatus, actionStatus: $actionStatus)';
}


}

/// @nodoc
abstract mixin class _$ProductsStateCopyWith<$Res> implements $ProductsStateCopyWith<$Res> {
  factory _$ProductsStateCopyWith(_ProductsState value, $Res Function(_ProductsState) _then) = __$ProductsStateCopyWithImpl;
@override @useResult
$Res call({
 BlocStatus<List<ProductSummaryItem>> productsStatus, BlocStatus<List<ProductColor>> colorsStatus, BlocStatus<List<CategoryItem>> categoriesStatus, BlocStatus<void> actionStatus
});


@override $BlocStatusCopyWith<List<ProductSummaryItem>, $Res> get productsStatus;@override $BlocStatusCopyWith<List<ProductColor>, $Res> get colorsStatus;@override $BlocStatusCopyWith<List<CategoryItem>, $Res> get categoriesStatus;@override $BlocStatusCopyWith<void, $Res> get actionStatus;

}
/// @nodoc
class __$ProductsStateCopyWithImpl<$Res>
    implements _$ProductsStateCopyWith<$Res> {
  __$ProductsStateCopyWithImpl(this._self, this._then);

  final _ProductsState _self;
  final $Res Function(_ProductsState) _then;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productsStatus = null,Object? colorsStatus = null,Object? categoriesStatus = null,Object? actionStatus = null,}) {
  return _then(_ProductsState(
productsStatus: null == productsStatus ? _self.productsStatus : productsStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<List<ProductSummaryItem>>,colorsStatus: null == colorsStatus ? _self.colorsStatus : colorsStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<List<ProductColor>>,categoriesStatus: null == categoriesStatus ? _self.categoriesStatus : categoriesStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<List<CategoryItem>>,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<void>,
  ));
}

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<List<ProductSummaryItem>, $Res> get productsStatus {
  
  return $BlocStatusCopyWith<List<ProductSummaryItem>, $Res>(_self.productsStatus, (value) {
    return _then(_self.copyWith(productsStatus: value));
  });
}/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<List<ProductColor>, $Res> get colorsStatus {
  
  return $BlocStatusCopyWith<List<ProductColor>, $Res>(_self.colorsStatus, (value) {
    return _then(_self.copyWith(colorsStatus: value));
  });
}/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<List<CategoryItem>, $Res> get categoriesStatus {
  
  return $BlocStatusCopyWith<List<CategoryItem>, $Res>(_self.categoriesStatus, (value) {
    return _then(_self.copyWith(categoriesStatus: value));
  });
}/// Create a copy of ProductsState
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
