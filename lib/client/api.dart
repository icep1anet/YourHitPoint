import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> request(
    {required Uri url,
    String type = "get",
    Map<String, String>? headers,
    var body}) async {
  final bodyEncoded = jsonEncode(body);
  http.Response response;
  if (type == "get") {
    response = await http.get(url, headers: headers);
  } else if (type == "post") {
    response = await http.post(url, headers: headers, body: body);
  } else {
    throw "Invalid request type";
  }
  return response;
}
