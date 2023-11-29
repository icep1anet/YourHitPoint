import 'dart:convert';

import "package:fl_chart/fl_chart.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import "package:logger/logger.dart";
import 'package:your_hit_point/client/api.dart';
import 'package:your_hit_point/client/oauth_fitbit.dart';
import 'package:your_hit_point/model/HP_state.dart';
import 'package:your_hit_point/utils/hp_graph.dart';
import 'package:your_hit_point/view/base.dart';
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
      ref.watch(accessTokenProvider.notifier).state = accessToken;
      await ref.read(userDataProvider.notifier).fetchProfile();
    } else {
      logger.d("accessToken == null");
    }
    ref.watch(isFinishedMainProvider.notifier).state = true;
  }

  Future<void> updateUserData(WidgetRef ref, Map responseBody) async {
    if (!responseBody["graph_spots"].containsKey("past_spots")) {
      logger.d("no past_spots data");
      return;
    }
    Map recordBody = await requestRecord(ref);
    List<FlSpot> pastTmpSpots =
        convertHPSpotsList(responseBody["graph_spots"]["past_spots"]);
    List<FlSpot> futureSpots =
        convertHPSpotsList(responseBody["graph_spots"]["future_spots"]);
    state = state.copyWith(
      futureSpots: futureSpots,
      pastSpots: pastTmpSpots,
      imgUrl: responseBody["firebase_user_dict"]["avatarUrl"],
      recordHighHP: recordBody["record_data"]["recordHigh"].toDouble(),
      recordLowHP: recordBody["record_data"]["recordLow"].toDouble(),
      activeLimitTime: responseBody["firebase_user_dict"]["activeLimitTime"],
      maxDayHP: recordBody["record_data"]["maxDayHP"].toInt(),
      hpNumber: 0,
      currentHP: responseBody["firebase_user_dict"]["pastHP"].toInt(),
    );
    ref.read(userDataProvider.notifier).updateUserRecord(
          responseBody["firebase_user_dict"]["avatarName"],
          responseBody["firebase_user_dict"]["avatarType"],
          recordBody["record_data"]["maxSleepDuration"],
          recordBody["record_data"]["maxTotalDaySteps"],
          recordBody["record_data"]["experienceLevel"].toInt(),
          recordBody["record_data"]["experiencePoint"].toInt(),
          recordBody["record_data"]["deskworkTime"],
        );
    changeHP(ref, true);
    updateMinMaxSpots();
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

  void changeHP(WidgetRef ref, bool currentHPFlag) {
    double hpPercent = 0.0;
    // changeHPを2回目以降に呼ぶときはcurrentHPをfutureの値に置き換える
    if (!currentHPFlag) {
      state = state.copyWith(
          currentHP: state.futureSpots[state.hpNumber].y.toInt());
    }
    hpPercent = (state.currentHP / state.maxDayHP) * 100;
    if (state.currentHP < 0) {
      hpPercent = 0;
    }
    if (state.hpNumber < state.futureSpots.length || currentHPFlag) {
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
      DateTime hoursAgo, DateTime now, String? userId) async {
    //リクエスト
    var url = Uri.https("o2nr395oib.execute-api.ap-northeast-1.amazonaws.com",
        "/default/get_HP_data", {
      "userId": userId,
      "startTimestamp": hoursAgo.toString(),
      "endTimestamp": now.toString()
    });
    var response = await request(url: url);
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

  Future<void> requestHP(WidgetRef ref) async {
    //リクエスト
    DateTime now = DateTime.now();
    String nowDate = DateFormat('yyyy-MM-dd').format(now);
    String nowTime = DateFormat('HH:mm').format(now);
    Map<String, dynamic>? body = {
      "fitbit_id": ref.read(userDataProvider).userId,
      "current_time": nowTime,
      "current_date": nowDate
    };
    var url = Uri.parse(
        "https://your-hit-point-backend-2ledkxm6ta-an.a.run.app/hitpoint/check");
    url = url.replace(queryParameters: body);
    final bodyEncoded = jsonEncode(body);
    var response = await request(url: url, type: "get", body: bodyEncoded);
    //リクエストの返り値をマップ形式に変換
    var responseBody = jsonDecode(response.body);
    // logger.d(responseBody);
    int statusCode = response.statusCode;
    //リクエスト成功時
    if (statusCode == 200) {
      // リクエストが成功した場合、レスポンスの内容を取得して表示します
      logger.d("requestHP成功しました!");
      bool needResend = responseBody["check_calculate"]["need_new_data"];
      // "need_new_data" : 1, 1で必要 0で不要
      if (!needResend) {
        logger.d("HPの計算は不必要です");
        await updateUserData(ref, responseBody);
      } else {
        logger.d("新しいHPの計算が必要です");
        await requestCalculateHP(ref, responseBody);
        await ref
            .read(userDataProvider.notifier)
            .requestCalculateHL(ref, responseBody);
        await requestHP(ref);
      }
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: $responseBody");
    }
    return;
  }

  Future? requestCalculateHP(WidgetRef ref, Map responseBody) async {
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 9));
    // 日本標準時UTC+9に変換
    String beforeUpdateDate =
        responseBody["check_calculate"]["before_update_date"];
    String beforeUpdateTime =
        responseBody["check_calculate"]["before_update_time"];
    DateTime beforeDateTime =
        DateTime.parse("$beforeUpdateDate $beforeUpdateTime");
    // 現在時刻の1時間前のdatetime
    DateTime dayAgo = now.add(const Duration(hours: 23, minutes: 59) * -1);
    // beforeDateTimeがdayAgoより前の時間の場合はdayAgoをstartDateに
    bool exceedFlag = dayAgo.isAfter(beforeDateTime);
    if (exceedFlag) {
      beforeDateTime = dayAgo;
    }
    final startDate = DateFormat('yyyy-MM-dd').format(beforeDateTime);
    final endDate = DateFormat('yyyy-MM-dd').format(now);
    final startTime = DateFormat('HH:mm').format(beforeDateTime);
    final endTime = DateFormat('HH:mm').format(now);
    Map stepData = await getSteps(startDate, endDate, startTime, endTime);
    Map calorieData = await getCalories(startDate, endDate, startTime, endTime);
    Map sleepData = await getSleeps(startDate, endDate);
    Map heartData = await getHeartRate(startDate, endDate, startTime, endTime);
    Map fitbitData = {
      "days_sleep": sleepData,
      "intradays_steps": stepData,
      "intradays_heartrate": heartData,
      "intradays_calories": calorieData
    };
    String? userId = ref.read(userDataProvider).userId;
    Map flutterData = {
      "gender": ref.read(userDataProvider).gender,
      "age": ref.read(userDataProvider).age
    };
    logger.d("flutterData: $flutterData");
    Map requestBody = {
      "fitbit_id": userId,
      "fitbit_data": fitbitData,
      "flutter_data": flutterData
    };
    var url = Uri.parse(
        "https://your-hit-point-backend-2ledkxm6ta-an.a.run.app/hitpoint/calculate");
    final bodyEncoded = jsonEncode(requestBody);
    var response = await request(url: url, type: "post", body: bodyEncoded);
    logger.d(response.body);
    //リクエストの返り値をマップ形式に変換
    var resBody = jsonDecode(response.body);
    //リクエスト成功時
    if (response.statusCode == 200) {
      logger.d("calculateHP成功しました!");
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: $resBody");
    }
    return resBody;
  }

  Future<Map> requestRecord(WidgetRef ref) async {
    //リクエスト
    Map<String, dynamic>? body = {
      "fitbit_id": ref.read(userDataProvider).userId,
    };
    var url = Uri.parse(
        "https://your-hit-point-backend-2ledkxm6ta-an.a.run.app/record");
    url = url.replace(queryParameters: body);
    final bodyEncoded = jsonEncode(body);
    var response = await request(url: url, type: "get", body: bodyEncoded);
    //リクエストの返り値をマップ形式に変換
    var responseBody = jsonDecode(response.body);
    int statusCode = response.statusCode;
    //リクエスト成功時
    if (statusCode == 200) {
      // リクエストが成功した場合、レスポンスの内容を取得して表示します
      logger.d("requestRecord成功しました!");
      logger.d(responseBody);
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: $responseBody");
    }
    return responseBody;
  }
}
