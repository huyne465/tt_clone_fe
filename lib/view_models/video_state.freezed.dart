// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoState {

 List<VideoModel> get videos; bool get isLoading; int get currentIndex; String? get errorMessage;
/// Create a copy of VideoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoStateCopyWith<VideoState> get copyWith => _$VideoStateCopyWithImpl<VideoState>(this as VideoState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoState&&const DeepCollectionEquality().equals(other.videos, videos)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(videos),isLoading,currentIndex,errorMessage);

@override
String toString() {
  return 'VideoState(videos: $videos, isLoading: $isLoading, currentIndex: $currentIndex, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $VideoStateCopyWith<$Res>  {
  factory $VideoStateCopyWith(VideoState value, $Res Function(VideoState) _then) = _$VideoStateCopyWithImpl;
@useResult
$Res call({
 List<VideoModel> videos, bool isLoading, int currentIndex, String? errorMessage
});




}
/// @nodoc
class _$VideoStateCopyWithImpl<$Res>
    implements $VideoStateCopyWith<$Res> {
  _$VideoStateCopyWithImpl(this._self, this._then);

  final VideoState _self;
  final $Res Function(VideoState) _then;

/// Create a copy of VideoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videos = null,Object? isLoading = null,Object? currentIndex = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
videos: null == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as List<VideoModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoState].
extension VideoStatePatterns on VideoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoState value)  $default,){
final _that = this;
switch (_that) {
case _VideoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoState value)?  $default,){
final _that = this;
switch (_that) {
case _VideoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VideoModel> videos,  bool isLoading,  int currentIndex,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoState() when $default != null:
return $default(_that.videos,_that.isLoading,_that.currentIndex,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VideoModel> videos,  bool isLoading,  int currentIndex,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _VideoState():
return $default(_that.videos,_that.isLoading,_that.currentIndex,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VideoModel> videos,  bool isLoading,  int currentIndex,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _VideoState() when $default != null:
return $default(_that.videos,_that.isLoading,_that.currentIndex,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _VideoState implements VideoState {
  const _VideoState({final  List<VideoModel> videos = const [], this.isLoading = true, this.currentIndex = 0, this.errorMessage}): _videos = videos;
  

 final  List<VideoModel> _videos;
@override@JsonKey() List<VideoModel> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int currentIndex;
@override final  String? errorMessage;

/// Create a copy of VideoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoStateCopyWith<_VideoState> get copyWith => __$VideoStateCopyWithImpl<_VideoState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoState&&const DeepCollectionEquality().equals(other._videos, _videos)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_videos),isLoading,currentIndex,errorMessage);

@override
String toString() {
  return 'VideoState(videos: $videos, isLoading: $isLoading, currentIndex: $currentIndex, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$VideoStateCopyWith<$Res> implements $VideoStateCopyWith<$Res> {
  factory _$VideoStateCopyWith(_VideoState value, $Res Function(_VideoState) _then) = __$VideoStateCopyWithImpl;
@override @useResult
$Res call({
 List<VideoModel> videos, bool isLoading, int currentIndex, String? errorMessage
});




}
/// @nodoc
class __$VideoStateCopyWithImpl<$Res>
    implements _$VideoStateCopyWith<$Res> {
  __$VideoStateCopyWithImpl(this._self, this._then);

  final _VideoState _self;
  final $Res Function(_VideoState) _then;

/// Create a copy of VideoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videos = null,Object? isLoading = null,Object? currentIndex = null,Object? errorMessage = freezed,}) {
  return _then(_VideoState(
videos: null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<VideoModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
