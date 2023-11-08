import 'package:http/http.dart' as http;

Future<http.Response> request(
    {required Uri url,
    String type = "get",
    Map<String, String>? headers = const {"Content-Type": "application/json"},
    var body}) async {
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
