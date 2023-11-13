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

  Future<Map> fetchFriendData() async {
    //リクエスト
    var url = Uri.https("3fk5goov13.execute-api.ap-northeast-1.amazonaws.com",
        "/default/get_friend_data_yourHP", {
      "userId": state.userId,
    });

    var response = await request(url: url);
    logger.d("friendbody: ${response.body}");
    //リクエストの返り値をマップ形式に変換
    var responseBody = jsonDecode(response.body);
    //リクエスト成功時
    if (response.statusCode == 200) {
      // リクエストが成功した場合、レスポンスの内容を取得して表示します
      logger.d("frined成功しました!");
    } else {
      // リクエストが失敗した場合、エラーメッセージを表示します
      logger.d("Request failed with status: $responseBody");
    }
    return responseBody;
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
    body["latestCalculatedSleepTime"] = DateFormat('yyyy-MM-ddThh:mm:ss.000').format(yesterdayDatetime);

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

  void updateUserRecord(int maxSleepDuration, int maxTotalDaySteps,
      int experienceLevel, int experiencePoint) {
    state = state.copyWith(
      maxSleepDuration: maxSleepDuration,
      maxTotalDaySteps: maxTotalDaySteps,
      experienceLevel: experienceLevel,
      experiencePoint: experiencePoint % 360,
    );
  }
}
