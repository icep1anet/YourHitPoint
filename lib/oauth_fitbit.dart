import 'dart:async';

import "package:logger/logger.dart";
import 'package:uuid/uuid.dart';
import 'package:pkce/pkce.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

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
  Future<void> callOAuth() async {
    // OAuthを呼び出してaccess_tokenを取得する
    // 保存はまだ
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

    return;
  }


}
