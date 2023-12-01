import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_hit_point/client/api.dart';
import 'package:your_hit_point/model/user_state.dart';
import 'package:your_hit_point/client/oauth_fitbit.dart';

var logger = Logger();

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserDataState>(
    (ref) => UserDataNotifier());

class UserDataNotifier extends StateNotifier<UserDataState> {
  UserDataNotifier() : super(const UserDataState());

  Future<void> getLocalData() async {
    //Sharedpreferenceにあるユーザデータを取得
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
        userId: prefs.getString("userId"),
        userName: prefs.getString("userName"),
        avatarName: prefs.getString("avatarName")!,
        avatarType: prefs.getString("avatarType")!);
  }

  Future<Map> fetchProfile() async {
    var profile = await getProfile();
    String userId = profile["user"]["encodedId"];
    String userName = profile["user"]["displayName"];
    String gender = profile["user"]["gender"];
    int age = profile["user"]["age"];
    state = state.copyWith(
        userId: userId, userName: userName, gender: gender, age: age);
    return profile;
  }

  Future<bool> registerFirebase(userId) async {
    //リクエスト
    bool registerFlag = true;
    var profile = await fetchProfile();
    Map body = {};
    body["user"] = {};
    body["firebaseAuthId"] = userId;
    body["deskworkTime"] = ["10:00:00", "18:00:00"];
    body["user"]["age"] = profile["user"]["age"];
    body["user"]["displayName"] = profile["user"]["displayName"];
    body["user"]["fitbitId"] = profile["user"]["encodedId"];
    body["user"]["gender"] = profile["user"]["gender"];
    body["avatarName"] = state.avatarName;
    body["avatarType"] = state.avatarType;
    final yesterdayDatetime =
        DateTime.now().toUtc().add(const Duration(hours: 15) * -1);
    body["latestCalculatedSleepTime"] =
        DateFormat('yyyy-MM-ddThh:mm:ss.000').format(yesterdayDatetime);

    logger.d(body);
    var url = Uri.parse(
        "https://your-hit-point-backend-2ledkxm6ta-an.a.run.app/register/");
    final bodyEncoded = jsonEncode(body);
    var response = await request(url: url, type: "post", body: bodyEncoded);
    //リクエストの返り値をマップ形式に変換
    logger.d(response.body);
    var responseBody = jsonDecode(response.body);
    //リクエスト成功時
    if (response.statusCode == 201) {
      logger.d("register成功しました!");
    } else if (response.statusCode == 409) {
      logger.d("すでにFirebaseにデータがあります");
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: $responseBody");
      registerFlag = false;
    }
    return registerFlag;
  }

  Future<void> setItemToSharedPref(
      List<String> itemNames, List<dynamic> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < itemNames.length; i++) {
      prefs.setString(itemNames[i], items[i]);
      if (itemNames[i] == "userId") {
        state = state.copyWith(userId: items[i]);
      }
    }
  }

  Future<void> refreshUserID(String id) async {
    await setItemToSharedPref(["userId"], [id]);
  }

  void updateUserRecord(
    String userName,
    String avatarName,
    String avatarType,
    int maxSleepDuration,
    int maxTotalDaySteps,
    int experienceLevel,
    int experiencePoint,
    List deskworkTime
  ) {
    state = state.copyWith(
      userName: userName,
      avatarName: avatarName,
      avatarType: avatarType,
      maxSleepDuration: maxSleepDuration,
      maxTotalDaySteps: maxTotalDaySteps,
      experienceLevel: experienceLevel,
      experiencePoint: experiencePoint,
      deskworkTime: deskworkTime
    );
  }

  Future? requestCalculateHL(WidgetRef ref, Map responseBody) async {
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 9));
    logger.d(now);
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
        "https://your-hit-point-backend-2ledkxm6ta-an.a.run.app/healthlevel/calculate");
    final bodyEncoded = jsonEncode(requestBody);
    var response = await request(url: url, type: "post", body: bodyEncoded);
    //リクエストの返り値をマップ形式に変換
    var resBody = jsonDecode(response.body);
    //リクエスト成功時
    if (response.statusCode == 200) {
      logger.d("calculateHL成功しました!");
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: $resBody");
    }
    return resBody;
  }


  Future changeProfile(String userId, String userName, String avatarName, String avatarType, List deskworkTime) async {

    Map requestBody = {
      "fitbit_id": userId,
      "userName": userName,
      "avatarName": avatarName,
      "avatarType": avatarType,
      "deskworkTime": deskworkTime,
    };
    var url = Uri.parse(
        "https://your-hit-point-backend-2ledkxm6ta-an.a.run.app/change_data/");
    final bodyEncoded = jsonEncode(requestBody);
    var response = await request(url: url, type: "post", body: bodyEncoded);
    //リクエストの返り値をマップ形式に変換
    var resBody = jsonDecode(response.body);
    //リクエスト成功時
    if (response.statusCode == 200) {
      logger.d("changeProfile成功しました!");
      state = state.copyWith(
        userName: userName,
        avatarName: avatarName,
        avatarType: avatarName,
        deskworkTime: deskworkTime
      );
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: $resBody");
    }
    return resBody;
  }
}
