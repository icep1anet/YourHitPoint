import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:your_hit_point/client/backend.dart';
import 'package:your_hit_point/components/friend_card.dart';
import 'package:your_hit_point/model/friend_state.dart';
import 'package:your_hit_point/client/oauth_fitbit.dart';
part 'friend_data_notifier.g.dart';

@riverpod
class FriendData extends _$FriendData {
  @override
  List<FriendState> build() {
    return <FriendState>[];
  }

  void add(FriendState newFriendData) {
    state = [...state, newFriendData];
  }

  void deleteAll() {
    state = [];
  }

  Widget createFriendCardWidget(index) {
    return FriendCardWidget(state[index].currentHP, state[index].friendName,
        state[index].avatarUrl, state[index].hpFontColor);
  }

  Future<void> fetchFriendData() async {
    deleteAll();
    Map friendIdDict = await getFriends();
    // fitbitからfriendIdデータを取得
    // {"id": "name"}
    Map friendDataDict = await getFriendData(friendIdDict);
    // バックエンドからfriendのHP等を取得
    // {"id":
    //    {"frined_hp": currentHP,
    //     "friend_avatar_image":avatarUrl
    //     }}
    friendDataDict.forEach((key, value) {
      add(FriendState(
          friendName: friendIdDict[key],
          currentHP: value["friend_hp"].toInt(),
          avatarUrl: value["friend_avatar_image"],
          hpFontColor: selectHPfontColor(value["friend_hp"].toInt())));
    });
  }

  Color selectHPfontColor(int hp) {
    if (80 < hp) {
      return const Color(0xFF32cd32);
    } else if (30 < hp && hp <= 80) {
      return const Color(0xff00ff7f);
    } else if (0 < hp && hp <= 30) {
      return const Color(0xffffd700);
    } else {
      return const Color(0xffdc143c);
    }
  }
}
