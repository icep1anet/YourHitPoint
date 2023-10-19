import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pkce/pkce.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> oAuthRequest() async {
  // applinkの実装
  // https://qiita.com/noboru_i/items/fd4634ecb326b3749ac0
  // ひとまずコピーできる臨時サイト作って、アプリに戻って貼り付け？
  await dotenv.load(fileName: ".env");
  final clientId = dotenv.env["CLIENT_ID"];
  var baseUrl = "https://www.fitbit.com/oauth2/authorize";
  final pkcePair = PkcePair.generate();
  final pkce = pkcePair.codeChallenge;
  const uuid = Uuid();
  final state = uuid.v4().toString();
  baseUrl =
      "$baseUrl?response_type=code&client_id=$clientId&scope=activity+profile+sleep+social+temperature&code_challenge=$pkce&code_challenge_method=S256&state=$state";

  return baseUrl;
}

class OAuthApp extends StatelessWidget {
  const OAuthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Launcher'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final oauthUrl = await oAuthRequest();
                final url = Uri.parse(oauthUrl);
                launchUrl(url);
                // if (await canLaunchUrl(url)) {
                //   launchUrl(url);
                // } else {
                //   // ignore: avoid_print
                //   print("Can't launch $url");
                // }
              },
              child: const Text('Web Link'),
            ),
          ],
        ),
      ),
    );
  }
}
