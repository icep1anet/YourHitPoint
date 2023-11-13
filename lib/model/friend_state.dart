import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'friend_state.freezed.dart';

@freezed
class FriendState with _$FriendState {
  const factory FriendState({
    @Default(100) int currentHP,
    @Default("") String friendName,
    @Default("") String avatarUrl,
    @Default(Colors.white) Color hpFontColor,
  }) = _FriendState;
}
