import 'dart:async';
import 'dart:convert';

import "package:logger/logger.dart";
import 'package:pkce/pkce.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:your_hit_point/client/api.dart';

var logger = Logger();

final accessTokenProvider = StateProvider<String?>((ref) => null);

const identifier = '23R5R4';
const scopes = "activity heartrate profile sleep social temperature";
final pkcePair = PkcePair.generate(length: 96);
//   const uuid = Uuid();
//   final state = uuid.v4().toString();

final authorizationEndpoint = Uri.https('www.fitbit.com', '/oauth2/authorize', {
  'response_type': 'code',
  'scope': scopes,
  'code_challenge_method': 'S256',
  'code_challenge': pkcePair.codeChallenge,
  'client_id': identifier,
});
final tokenEndpoint = Uri.https('api.fitbit.com', '/oauth2/token');
const callbackUrlScheme = "your-hit-point-scheme";
const urlencodedHeaders = {'Content-Type': 'application/x-www-form-urlencoded'};

Future<void> callOAuth() async {
  // OAuthを呼び出してaccess_tokenを取得する
  // secure領域にtokenを保存
  final result = await FlutterWebAuth2.authenticate(
      url: authorizationEndpoint.toString(),
      callbackUrlScheme: callbackUrlScheme);
  logger.d(result);
  String code = Uri.parse(result).queryParameters["code"]!;
  logger.d(code);
  final body = {
    'client_id': identifier,
    'code': code,
    'code_verifier': pkcePair.codeVerifier,
    'grant_type': 'authorization_code',
  };
  final response = await request(
      url: tokenEndpoint, type: "post", headers: urlencodedHeaders, body: body);
  logger.d(response.body);
  const storage = FlutterSecureStorage();
  await storage.write(key: "fitbitToken", value: response.body);
  return;
}

Future<String?> getToken({String key = "access_token"}) async {
  // secure領域に保存したtokenを取得する
  const storage = FlutterSecureStorage();
  String? tokenJson = await storage.read(key: "fitbitToken");
  if (tokenJson == null) {
    return null;
  } else {
    Map token = json.decode(tokenJson);
    return token[key];
  }
}

Future<Map> fitbitRequest(
    {required Uri url,
    String type = "get",
    Map<String, String> headers = const {},
    Map? body,
    int depth = 0}) async {
  // fitbitAPIへデータを要求するときに使用する関数
  // tokenのリフレッシュもラップしているのでこれを使用してほしい
  Map data = {};
  if (depth >= 2) {
    throw Exception("OAuthの更新に失敗しました");
  }
  final token = await getToken();
  final authorizationHeaders = {'Authorization': "Bearer $token"};
  headers.addAll(authorizationHeaders);
  http.Response response =
      await request(url: url, type: type, headers: headers, body: body);
  if (response.statusCode == 401) {
    refreshToken();
    data = await fitbitRequest(
        url: url, type: type, headers: headers, body: body, depth: depth + 1);
  } else if (response.statusCode == 200) {
    data = json.decode(response.body);
  } else {
    logger.d(response.statusCode);
    logger.d(response.body);
    throw Exception(response.body);
  }
  return data;
}

Future<void> refreshToken() async {
  const headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  final refreshToken = await getToken(key: "refresh_token");
  final body = {
    "grant_type": "refresh_token",
    "client_id": "23R5R4",
    "refresh_token": refreshToken
  };
  final token = await request(
      url: tokenEndpoint, type: "post", headers: headers, body: body);
  const storage = FlutterSecureStorage();
  await storage.write(key: "fitbitToken", value: token.body);
}

Future<Map> getProfile() async {
  final endpoint = Uri.https("api.fitbit.com", "/1/user/-/profile.json");
  final data = await fitbitRequest(url: endpoint, type: "get");
  return data;
}

Future<Map> getSteps(
    String startDate, String endDate, String startTime, String endTime) async {
  final endpoint = Uri.https("api.fitbit.com",
      "/1/user/-/activities/steps/date/$startDate/$endDate/15min/time/$startTime/$endTime.json");
  final data =
      await fitbitRequest(url: endpoint, type: "get");
  return data;
}

Future<Map> getCalories(
    String startDate, String endDate, String startTime, String endTime) async {
  final endpoint = Uri.https("api.fitbit.com",
      "/1/user/-/activities/calories/date/$startDate/$endDate/15min/time/$startTime/$endTime.json");
  final data =
      await fitbitRequest(url: endpoint, type: "get");
  return data;
}

Future<Map> getSleeps(String startDate, String endDate) async {
  final endpoint = Uri.https(
      "api.fitbit.com", "/1.2/user/-/sleep/date/$startDate/$endDate.json");
  final data =
      await fitbitRequest(url: endpoint, type: "get");
  return data;
}

Future<Map> getHeartRate(
    String startDate, String endDate, String startTime, String endTime) async {
  final endpoint = Uri.https("api.fitbit.com",
      "/1/user/-/activities/heart/date/$startDate/$endDate/15min/time/$startTime/$endTime.json");
  final data =
      await fitbitRequest(url: endpoint, type: "get");
  return data;
}

// debug
// secure storageの中身全消し
void deleteSecureStorage() {
  const storage = FlutterSecureStorage();
  storage.deleteAll();
}
