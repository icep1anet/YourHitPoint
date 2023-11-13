// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FriendState {
  int get currentHP => throw _privateConstructorUsedError;
  String get friendName => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;
  Color get hpFontColor => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FriendStateCopyWith<FriendState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendStateCopyWith<$Res> {
  factory $FriendStateCopyWith(
          FriendState value, $Res Function(FriendState) then) =
      _$FriendStateCopyWithImpl<$Res, FriendState>;
  @useResult
  $Res call(
      {int currentHP, String friendName, String avatarUrl, Color hpFontColor});
}

/// @nodoc
class _$FriendStateCopyWithImpl<$Res, $Val extends FriendState>
    implements $FriendStateCopyWith<$Res> {
  _$FriendStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentHP = null,
    Object? friendName = null,
    Object? avatarUrl = null,
    Object? hpFontColor = null,
  }) {
    return _then(_value.copyWith(
      currentHP: null == currentHP
          ? _value.currentHP
          : currentHP // ignore: cast_nullable_to_non_nullable
              as int,
      friendName: null == friendName
          ? _value.friendName
          : friendName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      hpFontColor: null == hpFontColor
          ? _value.hpFontColor
          : hpFontColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FriendStateImplCopyWith<$Res>
    implements $FriendStateCopyWith<$Res> {
  factory _$$FriendStateImplCopyWith(
          _$FriendStateImpl value, $Res Function(_$FriendStateImpl) then) =
      __$$FriendStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentHP, String friendName, String avatarUrl, Color hpFontColor});
}

/// @nodoc
class __$$FriendStateImplCopyWithImpl<$Res>
    extends _$FriendStateCopyWithImpl<$Res, _$FriendStateImpl>
    implements _$$FriendStateImplCopyWith<$Res> {
  __$$FriendStateImplCopyWithImpl(
      _$FriendStateImpl _value, $Res Function(_$FriendStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentHP = null,
    Object? friendName = null,
    Object? avatarUrl = null,
    Object? hpFontColor = null,
  }) {
    return _then(_$FriendStateImpl(
      currentHP: null == currentHP
          ? _value.currentHP
          : currentHP // ignore: cast_nullable_to_non_nullable
              as int,
      friendName: null == friendName
          ? _value.friendName
          : friendName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      hpFontColor: null == hpFontColor
          ? _value.hpFontColor
          : hpFontColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$FriendStateImpl implements _FriendState {
  const _$FriendStateImpl(
      {this.currentHP = 100,
      this.friendName = "",
      this.avatarUrl = "",
      this.hpFontColor = Colors.white});

  @override
  @JsonKey()
  final int currentHP;
  @override
  @JsonKey()
  final String friendName;
  @override
  @JsonKey()
  final String avatarUrl;
  @override
  @JsonKey()
  final Color hpFontColor;

  @override
  String toString() {
    return 'FriendState(currentHP: $currentHP, friendName: $friendName, avatarUrl: $avatarUrl, hpFontColor: $hpFontColor)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendStateImpl &&
            (identical(other.currentHP, currentHP) ||
                other.currentHP == currentHP) &&
            (identical(other.friendName, friendName) ||
                other.friendName == friendName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.hpFontColor, hpFontColor) ||
                other.hpFontColor == hpFontColor));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, currentHP, friendName, avatarUrl, hpFontColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendStateImplCopyWith<_$FriendStateImpl> get copyWith =>
      __$$FriendStateImplCopyWithImpl<_$FriendStateImpl>(this, _$identity);
}

abstract class _FriendState implements FriendState {
  const factory _FriendState(
      {final int currentHP,
      final String friendName,
      final String avatarUrl,
      final Color hpFontColor}) = _$FriendStateImpl;

  @override
  int get currentHP;
  @override
  String get friendName;
  @override
  String get avatarUrl;
  @override
  Color get hpFontColor;
  @override
  @JsonKey(ignore: true)
  _$$FriendStateImplCopyWith<_$FriendStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
