// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsersState {

 BlocStatus<List<UserItem>> get usersStatus; BlocStatus<void> get actionStatus; UsersQuery get lastQuery;
/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersStateCopyWith<UsersState> get copyWith => _$UsersStateCopyWithImpl<UsersState>(this as UsersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersState&&(identical(other.usersStatus, usersStatus) || other.usersStatus == usersStatus)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus)&&(identical(other.lastQuery, lastQuery) || other.lastQuery == lastQuery));
}


@override
int get hashCode => Object.hash(runtimeType,usersStatus,actionStatus,lastQuery);

@override
String toString() {
  return 'UsersState(usersStatus: $usersStatus, actionStatus: $actionStatus, lastQuery: $lastQuery)';
}


}

/// @nodoc
abstract mixin class $UsersStateCopyWith<$Res>  {
  factory $UsersStateCopyWith(UsersState value, $Res Function(UsersState) _then) = _$UsersStateCopyWithImpl;
@useResult
$Res call({
 BlocStatus<List<UserItem>> usersStatus, BlocStatus<void> actionStatus, UsersQuery lastQuery
});


$BlocStatusCopyWith<List<UserItem>, $Res> get usersStatus;$BlocStatusCopyWith<void, $Res> get actionStatus;$UsersQueryCopyWith<$Res> get lastQuery;

}
/// @nodoc
class _$UsersStateCopyWithImpl<$Res>
    implements $UsersStateCopyWith<$Res> {
  _$UsersStateCopyWithImpl(this._self, this._then);

  final UsersState _self;
  final $Res Function(UsersState) _then;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? usersStatus = null,Object? actionStatus = null,Object? lastQuery = null,}) {
  return _then(_self.copyWith(
usersStatus: null == usersStatus ? _self.usersStatus : usersStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<List<UserItem>>,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<void>,lastQuery: null == lastQuery ? _self.lastQuery : lastQuery // ignore: cast_nullable_to_non_nullable
as UsersQuery,
  ));
}
/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<List<UserItem>, $Res> get usersStatus {
  
  return $BlocStatusCopyWith<List<UserItem>, $Res>(_self.usersStatus, (value) {
    return _then(_self.copyWith(usersStatus: value));
  });
}/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<void, $Res> get actionStatus {
  
  return $BlocStatusCopyWith<void, $Res>(_self.actionStatus, (value) {
    return _then(_self.copyWith(actionStatus: value));
  });
}/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UsersQueryCopyWith<$Res> get lastQuery {
  
  return $UsersQueryCopyWith<$Res>(_self.lastQuery, (value) {
    return _then(_self.copyWith(lastQuery: value));
  });
}
}


/// Adds pattern-matching-related methods to [UsersState].
extension UsersStatePatterns on UsersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsersState value)  $default,){
final _that = this;
switch (_that) {
case _UsersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsersState value)?  $default,){
final _that = this;
switch (_that) {
case _UsersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BlocStatus<List<UserItem>> usersStatus,  BlocStatus<void> actionStatus,  UsersQuery lastQuery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsersState() when $default != null:
return $default(_that.usersStatus,_that.actionStatus,_that.lastQuery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BlocStatus<List<UserItem>> usersStatus,  BlocStatus<void> actionStatus,  UsersQuery lastQuery)  $default,) {final _that = this;
switch (_that) {
case _UsersState():
return $default(_that.usersStatus,_that.actionStatus,_that.lastQuery);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BlocStatus<List<UserItem>> usersStatus,  BlocStatus<void> actionStatus,  UsersQuery lastQuery)?  $default,) {final _that = this;
switch (_that) {
case _UsersState() when $default != null:
return $default(_that.usersStatus,_that.actionStatus,_that.lastQuery);case _:
  return null;

}
}

}

/// @nodoc


class _UsersState extends UsersState {
  const _UsersState({required this.usersStatus, required this.actionStatus, required this.lastQuery}): super._();
  

@override final  BlocStatus<List<UserItem>> usersStatus;
@override final  BlocStatus<void> actionStatus;
@override final  UsersQuery lastQuery;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsersStateCopyWith<_UsersState> get copyWith => __$UsersStateCopyWithImpl<_UsersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersState&&(identical(other.usersStatus, usersStatus) || other.usersStatus == usersStatus)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus)&&(identical(other.lastQuery, lastQuery) || other.lastQuery == lastQuery));
}


@override
int get hashCode => Object.hash(runtimeType,usersStatus,actionStatus,lastQuery);

@override
String toString() {
  return 'UsersState(usersStatus: $usersStatus, actionStatus: $actionStatus, lastQuery: $lastQuery)';
}


}

/// @nodoc
abstract mixin class _$UsersStateCopyWith<$Res> implements $UsersStateCopyWith<$Res> {
  factory _$UsersStateCopyWith(_UsersState value, $Res Function(_UsersState) _then) = __$UsersStateCopyWithImpl;
@override @useResult
$Res call({
 BlocStatus<List<UserItem>> usersStatus, BlocStatus<void> actionStatus, UsersQuery lastQuery
});


@override $BlocStatusCopyWith<List<UserItem>, $Res> get usersStatus;@override $BlocStatusCopyWith<void, $Res> get actionStatus;@override $UsersQueryCopyWith<$Res> get lastQuery;

}
/// @nodoc
class __$UsersStateCopyWithImpl<$Res>
    implements _$UsersStateCopyWith<$Res> {
  __$UsersStateCopyWithImpl(this._self, this._then);

  final _UsersState _self;
  final $Res Function(_UsersState) _then;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? usersStatus = null,Object? actionStatus = null,Object? lastQuery = null,}) {
  return _then(_UsersState(
usersStatus: null == usersStatus ? _self.usersStatus : usersStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<List<UserItem>>,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as BlocStatus<void>,lastQuery: null == lastQuery ? _self.lastQuery : lastQuery // ignore: cast_nullable_to_non_nullable
as UsersQuery,
  ));
}

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<List<UserItem>, $Res> get usersStatus {
  
  return $BlocStatusCopyWith<List<UserItem>, $Res>(_self.usersStatus, (value) {
    return _then(_self.copyWith(usersStatus: value));
  });
}/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlocStatusCopyWith<void, $Res> get actionStatus {
  
  return $BlocStatusCopyWith<void, $Res>(_self.actionStatus, (value) {
    return _then(_self.copyWith(actionStatus: value));
  });
}/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UsersQueryCopyWith<$Res> get lastQuery {
  
  return $UsersQueryCopyWith<$Res>(_self.lastQuery, (value) {
    return _then(_self.copyWith(lastQuery: value));
  });
}
}

/// @nodoc
mixin _$UsersQuery {

 String get query; UsersSort get sort;
/// Create a copy of UsersQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersQueryCopyWith<UsersQuery> get copyWith => _$UsersQueryCopyWithImpl<UsersQuery>(this as UsersQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersQuery&&(identical(other.query, query) || other.query == query)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,query,sort);

@override
String toString() {
  return 'UsersQuery(query: $query, sort: $sort)';
}


}

/// @nodoc
abstract mixin class $UsersQueryCopyWith<$Res>  {
  factory $UsersQueryCopyWith(UsersQuery value, $Res Function(UsersQuery) _then) = _$UsersQueryCopyWithImpl;
@useResult
$Res call({
 String query, UsersSort sort
});




}
/// @nodoc
class _$UsersQueryCopyWithImpl<$Res>
    implements $UsersQueryCopyWith<$Res> {
  _$UsersQueryCopyWithImpl(this._self, this._then);

  final UsersQuery _self;
  final $Res Function(UsersQuery) _then;

/// Create a copy of UsersQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? sort = null,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as UsersSort,
  ));
}

}


/// Adds pattern-matching-related methods to [UsersQuery].
extension UsersQueryPatterns on UsersQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsersQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsersQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsersQuery value)  $default,){
final _that = this;
switch (_that) {
case _UsersQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsersQuery value)?  $default,){
final _that = this;
switch (_that) {
case _UsersQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  UsersSort sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsersQuery() when $default != null:
return $default(_that.query,_that.sort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  UsersSort sort)  $default,) {final _that = this;
switch (_that) {
case _UsersQuery():
return $default(_that.query,_that.sort);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  UsersSort sort)?  $default,) {final _that = this;
switch (_that) {
case _UsersQuery() when $default != null:
return $default(_that.query,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _UsersQuery implements UsersQuery {
  const _UsersQuery({required this.query, required this.sort});
  

@override final  String query;
@override final  UsersSort sort;

/// Create a copy of UsersQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsersQueryCopyWith<_UsersQuery> get copyWith => __$UsersQueryCopyWithImpl<_UsersQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersQuery&&(identical(other.query, query) || other.query == query)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,query,sort);

@override
String toString() {
  return 'UsersQuery(query: $query, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$UsersQueryCopyWith<$Res> implements $UsersQueryCopyWith<$Res> {
  factory _$UsersQueryCopyWith(_UsersQuery value, $Res Function(_UsersQuery) _then) = __$UsersQueryCopyWithImpl;
@override @useResult
$Res call({
 String query, UsersSort sort
});




}
/// @nodoc
class __$UsersQueryCopyWithImpl<$Res>
    implements _$UsersQueryCopyWith<$Res> {
  __$UsersQueryCopyWithImpl(this._self, this._then);

  final _UsersQuery _self;
  final $Res Function(_UsersQuery) _then;

/// Create a copy of UsersQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? sort = null,}) {
  return _then(_UsersQuery(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as UsersSort,
  ));
}


}

// dart format on
