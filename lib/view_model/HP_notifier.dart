import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:fl_chart/fl_chart.dart";
import 'package:flutter/material.dart';
import "package:logger/logger.dart";
import 'package:your_hit_point/client/api.dart';
import 'package:your_hit_point/client/oauth_fitbit.dart';
import 'package:your_hit_point/main.dart';
import 'package:your_hit_point/model/HP_state.dart';
import 'package:your_hit_point/utils/hp_graph.dart';
import 'package:your_hit_point/view_model/user_data_notifier.dart';

var logger = Logger();
final hpProvider =
    StateNotifierProvider<HPNotifier, HPState>((ref) => HPNotifier());

class HPNotifier extends StateNotifier<HPState> {
  HPNotifier() : super(const HPState());

  Future<void> initMain(WidgetRef ref) async {
    // debug
    // deleteSecureStorage();
    //accessTokenがあるか確認
    String? accessToken = await getToken();
    if (accessToken != null) {
      logger.d("accessToken != null");
      // ref.watch(accessTokenProvider.notifier).state = 
      await updateUserData(ref);
      changeHP(ref);
    } else {
      logger.d("accessToken == null");
    }
    ref.watch(isFinishedMainProvider.notifier).state = true;
    // await updateUserData(ref);
    // changeHP();
  }

  Future<void> updateUserData(WidgetRef ref) async {
    Map befFetchedtime = calculateBeforeFetchedDatetime();
    DateTime hoursAgo = befFetchedtime["hoursAgo"];
    DateTime now = befFetchedtime["now"];
    String userId = ref.read(userDataProvider).userId!;
    Map responseBody = await fetchFirebaseData(hoursAgo, now, userId);
    if (!responseBody.containsKey("past_spots")) {
      return;
    }
    List<FlSpot> pastTmpSpots = convertHPSpotsList(responseBody["past_spots"]);
    removePastSpotsData(pastTmpSpots);
    state = state.copyWith(
      futureSpots: convertHPSpotsList(responseBody["future_spots"]),
      pastSpots: state.pastSpots + pastTmpSpots,
      imgUrl: responseBody["url"],
      recordHighHP: responseBody["recordHighHP"].toDouble(),
      recordLowHP: responseBody["recordLowHP"].toDouble(),
      activeLimitTime: responseBody["activeLimitTime"],
      // maxSleepDuration: responseBody["maxSleepDuration"],
      maxDayHP: responseBody["maxDayHP"].toInt(),
      // maxTotalDaySteps: responseBody["maxTotalDaySteps"],
      // maxSleepDuration: responseBody["maxSleepDuration"],
      // experienceLevel: responseBody["experienceLevel"],
      // experiencePoint: responseBody["experiencePoint"] % 360,
      latestDataTime: now,
      hpNumber: 0,
    );
    // logger.d("pastSpots: $state.pastSpots");

    updateMinMaxSpots();

    await setFriendDataList();
    //latestDataTimeの更新
  }

  void removePastSpotsData(List<FlSpot> pastTmpSpots) {
    //spotsにすでにデータがある場合は取ってきた新しい過去データの数だけ昔のspotsのデータをremove
    if (state.pastSpots.isNotEmpty && pastTmpSpots.isNotEmpty) {
      logger.d("spots is not Empty");
      //pastSpotsからremoveするデータの個数を計算
      // 32個に保つために 32 = 現在の個数 + 入ってくる個数 - 取り除く個数
      // <=> 取り除く個数 = 現在の個数 + 入ってくる個数 -32
      int removeCount = pastTmpSpots.length + state.pastSpots.length - 32;
      if (removeCount > 0) {
        List<FlSpot> pastSpots = state.pastSpots;
        pastSpots.removeRange(0, removeCount);
        state = state.copyWith(pastSpots: pastSpots);
      }
    } else {
      logger.d("spots is Empty or tes is Empty");
    }
  }

  Map calculateBeforeFetchedDatetime() {
    //リクエストのための時間計算
    logger.d("start before fetch time");
    DateTime now = DateTime.now();
    logger.d(now);
    DateTime hoursAgo = now.add(const Duration(hours: 8) * -1);
    if (state.latestDataTime != null) {
      if (state.latestDataTime!.compareTo(hoursAgo) == 1) {
        hoursAgo = state.latestDataTime!;
      }
    }
    var res = {};
    res["hoursAgo"] = hoursAgo;
    res["now"] = now;
    return res;
  }

  Future<void> setFriendDataList() async {
    // Map friendResponseBody = await fetchFriendData();
    // friendDataList = friendResponseBody["friendDataList"];
  }

  void changeHP(WidgetRef ref) {
    if (state.hpNumber < state.futureSpots.length) {
      state = state.copyWith(
          currentHP: state.futureSpots[state.hpNumber].y.toInt());
      double hpPercent = (state.currentHP / state.maxDayHP) * 100;
      if (state.currentHP < 0) {
        // currentHP = 0;
        hpPercent = 0;
      }
      if (80 < hpPercent) {
        state = state.copyWith(
            barColor: const Color(0xFF32cd32),
            fontColor: Colors.white,
            fontPosition: 60);
      } else if (40 < hpPercent && hpPercent <= 80) {
        state = state.copyWith(
            barColor: const Color.fromARGB(255, 0, 226, 113),
            fontColor: Colors.white,
            fontPosition: 60);
      } else if (30 < hpPercent && hpPercent <= 40) {
        state = state.copyWith(
            barColor: const Color.fromARGB(255, 0, 226, 113),
            fontColor: Colors.black,
            fontPosition: 0);
      } else if (0 < hpPercent && hpPercent <= 30) {
        state = state.copyWith(
            barColor: const Color(0xffffd700),
            fontColor: Colors.black,
            fontPosition: 0);
      } else {
        state = state.copyWith(
            barColor: const Color(0xffdc143c),
            fontColor: Colors.black,
            fontPosition: 0);
      }
      state = state.copyWith(hpNumber: state.hpNumber + 1);
    }
  }

  void updateMinMaxSpots() {
    //pastSpotsの0番目のデータからminxをとる
    if (state.pastSpots.isNotEmpty) {
      double? minGraphX = state.pastSpots.first.x.floor().toDouble();
      double? maxGraphY = state.pastSpots.first.y;
      //pastSpotsのyデータの最大値をmaxGraghYとする
      for (int i = 0; i < state.pastSpots.length; i++) {
        if (maxGraphY! < state.pastSpots[i].y) {
          maxGraphY = state.pastSpots[i].y;
        }
      }
      //maxYの値を5の倍数で切り上げる(例:32.4 -> 35.0)
      double tmpMaxY = maxGraphY!;
      maxGraphY = ((maxGraphY / 10).round().toDouble()) * 10;
      if (maxGraphY < tmpMaxY) {
        maxGraphY = maxGraphY + 5.0;
      }
      state = state.copyWith(
        minGraphX: minGraphX,
        maxGraphY: maxGraphY,
      );
    } else {
      state = state.copyWith(minGraphX: null, maxGraphY: null);
    }
    logger.d("futureSpots: $state.futureSpots");
    //futureSpotsの最後のデータからmaxXをとる
    if (state.futureSpots.isNotEmpty) {
      double? maxGraphX = state.futureSpots.last.x.ceil().toDouble();
      double? minGraphY = state.futureSpots.last.y;
      //pastSpotsとfutureSpotsのyデータの最小値をminGraghYとする
      for (int i = 0; i < state.futureSpots.length; i++) {
        if (minGraphY! > state.futureSpots[i].y) {
          minGraphY = state.futureSpots[i].y;
        }
      }
      if (state.pastSpots.isNotEmpty) {
        for (int i = 0; i < state.pastSpots.length; i++) {
          if (minGraphY! > state.pastSpots[i].y) {
            minGraphY = state.pastSpots[i].y;
          }
        }
      }
      //maxYの値を5の倍数で切り下げる(例:32.4 -> 30.0)
      double tmpMinY = minGraphY!;
      minGraphY = ((minGraphY / 10).round().toDouble()) * 10;
      if (minGraphY > tmpMinY) {
        minGraphY = minGraphY - 5.0;
      }
      state = state.copyWith(
        maxGraphX: maxGraphX,
        minGraphY: minGraphY,
      );
    } else {
      state = state.copyWith(
        maxGraphX: null,
        minGraphY: null,
      );
    }
    //yの最大と最小に100以上の差がある時グラフが突き出す分の幅を持たせる
    if (state.maxGraphY != null && state.minGraphY != null) {
      if (state.maxGraphY! - state.minGraphY! >= 100) {
        double yMargin = 20.0;
        state = state.copyWith(
          maxGraphY: state.maxGraphY! + yMargin,
          minGraphY: state.minGraphY! + yMargin,
        );
      }
    }
  }

  Future<Map> fetchFirebaseData(
      DateTime hoursAgo, DateTime now, String userId) async {
    //リクエスト
    var url = Uri.https("o2nr395oib.execute-api.ap-northeast-1.amazonaws.com",
        "/default/get_HP_data", {
      "userId": userId,
      "startTimestamp": hoursAgo.toString(),
      "endTimestamp": now.toString()
    });
    var response = await request(url: url);
    logger.d("response.body: ${response.body}");
    //リクエストの返り値をマップ形式に変換
    var responseBody = jsonDecode(response.body);
    //リクエスト成功時
    if (response.statusCode == 200) {
      // リクエストが成功した場合、レスポンスの内容を取得して表示します
      logger.d("成功しました！");
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: $responseBody");
    }
    return responseBody;
  }
}
