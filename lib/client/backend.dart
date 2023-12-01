import 'dart:convert';

import 'package:http/http.dart';
import 'package:your_hit_point/client/api.dart';

const urlBase = "your-hit-point-backend-2ledkxm6ta-an.a.run.app";

Future<Response> backendRequest(
    {required String path,
    String type = "get",
    Map<String, String> headers = const {"Content-Type": "application/json"},
    Map<String, dynamic>? query,
    Map? body}) async {
  final url = Uri.https(urlBase, path, query);
  Response response =
      await request(url: url, type: type, headers: headers, body: body);
  return response;
}

Future<Map> getFriendData(friendIdDict) async {
  Map friendDataDict = {};
  if (friendIdDict.isNotEmpty) {
    // friendIdDictのkeyのlistをstrに変換
    // {"id1":name1, "id2":name2} => "id1,id2"
    final friendIdList = friendIdDict.keys.join(",");
    Response response = await backendRequest(
        path: "/friend", query: {"friend_fitbit_id_list": friendIdList});
    String utf8DecodedResponseBody = utf8.decode(response.bodyBytes);
    friendDataDict = json.decode(utf8DecodedResponseBody);
  }
  return friendDataDict;
}

