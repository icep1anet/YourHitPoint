import 'dart:convert';

import 'package:http/http.dart';
import 'package:your_hit_point/client/api.dart';
import 'package:your_hit_point/client/oauth_fitbit.dart';

const urlBase = "o2nr395oib.execute-api.ap-northeast-1.amazonaws.com";

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

Future<List> getFriendData() async {
  List data = [];
  List friendIdList = await getFriends();
  if (friendIdList.isNotEmpty) {
    // friendIdListをlistからstrに変換
    // [id1, id2] => "id1,id2"
    friendIdList.join(",");
    Response response = await backendRequest(
        path: "/friend", query: {"friend_fitbit_id_list": friendIdList});
    final responseBody = response.body;
    data = json.decode(responseBody)["friends_data"];
  }
  return data;
}

