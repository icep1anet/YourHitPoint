
// Future<Map> loginFirebase(isRegistered, inputEmail, inputPassword) async {
//   isRegistered = true;
//   logger.d("login start");
//   var url = Uri.https("vignp7m26e.execute-api.ap-northeast-1.amazonaws.com",
//       "/default/firebase_login_yourHP", {
//     "email": inputEmail,
//     "password": inputPassword,
//   });
//   try {
//     var response = await http.get(url);
//     logger.d("register.body: ${response.body}");
//     if (response.statusCode == 200) {
//       // リクエストが成功した場合、レスポンスの内容を取得して表示します
//       var responseMap = jsonDecode(response.body);
//       userId = responseMap["userId"];
//       logger.d(userId);
//       // if (!mounted) return;
//       setItemToSharedPref(["userId", "userName", "avatarName", "avatarType"],
//           [userId!, userName, avatarName, avatarType]);
//     } else {
//       // リクエストが失敗した場合、エラーメッセージを表示します
//       logger.d("Request failed with status: $response");
//       isRegistered = false;
//       return {"isCompleted": false, "error": response};
//     }
//     return {"isCompleted": true};
//   } catch (e) {
//     isRegistered = false;
//     return {"isCompleted": false, "error": e};
//   }
// }

