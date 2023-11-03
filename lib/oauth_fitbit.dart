import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import "package:logger/logger.dart";
import 'package:uuid/uuid.dart';
import 'package:pkce/pkce.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var logger = Logger();

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

class FitbitAPI {
  static Future<void> callOAuth() async {
    // OAuthを呼び出してaccess_tokenを取得する
    // secure領域にtokenを保存
    final result = await FlutterWebAuth2.authenticate(
        url: authorizationEndpoint.toString(),
        callbackUrlScheme: callbackUrlScheme);

    String code = Uri.parse(result).queryParameters["code"]!;
    logger.d(code);

    final response = await http.post(tokenEndpoint, headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      'client_id': identifier,
      'code': code,
      'code_verifier': pkcePair.codeVerifier,
      'grant_type': 'authorization_code',
    });

    logger.d(response.body);
    final storage = new FlutterSecureStorage();
    await storage.write(key: "fitbitToken", value: response.body);
    
    return;
  }

  static Future<String?> getToken({String key = "access_token"}) async {
    // secure領域に保存したtokenを取得する
    final storage = new FlutterSecureStorage();
    String? tokenJson = await storage.read(key: "fitbitToken");
    if (tokenJson == null) {
      return null;
    } else {
      Map token = json.decode(tokenJson);
      return token[key];
    }
  }

  static Future<Map> request(
      {required Uri url,
      String type = "get",
      Map<String, String>? headers,
      Map? body,
      int depth = 0}) async {
    // fitbitAPIへデータを要求するときに使用する関数
    // tokenのリフレッシュもラップしているのでこれを使用してほしい
    if (depth >= 3) {
      throw Error();
    }
    http.Response response;
    if (type == "get") {
      response = await http.get(url, headers: headers);
    } else if (type == "post") {
      response = await http.post(url, headers: headers, body: body);
    } else {
      throw "Invalid request type";
    }
    Map data = json.decode(response.body);
    return data;
  }

  static Future<void> refreshToken() async {
    const headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final refresh_token = getToken(key: "refresh_token");
    final body = {
      "grant_type": "refresh_token",
      "client_id": "23R5R4",
      "refresh_token": refresh_token
    };
    final token =
        request(url: tokenEndpoint, type: "post", headers: headers, body: body);
    final storage = new FlutterSecureStorage();
    await storage.write(key: "fitbitToken", value: json.encode(token));
    
  }

  static Future<Map> getProfile() async {
    final endpoint = Uri.https("api.fitbit.com", "/1/user/-/profile.json");
    final token = await getToken();
    final headers = {'Authorization': "Bearer $token"};
    final data = await request(url: endpoint, type: "get", headers: headers);
    return data;
  }

  // debug
  // secure storageの中身全消し
  static void deleteStorage()  {
    const storage = FlutterSecureStorage();
    storage.deleteAll();
  }
}
