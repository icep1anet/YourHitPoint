import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:logger/logger.dart";
import 'package:uni_links/uni_links.dart';
import 'package:uuid/uuid.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

var logger = Logger();

final authorizationEndpoint =
    Uri.parse('https://www.fitbit.com/oauth2/authorize');
final tokenEndpoint = Uri.parse('http://www.fitbit.com/oauth2/token');

const identifier = '23R5R4';
const redirectUrl = 'https://your-hit-point-backend-2ledkxm6ta-an.a.run.app';
final redirectUri =
    Uri.parse('https://your-hit-point-backend-2ledkxm6ta-an.a.run.app');

class OAuthPage extends StatelessWidget {
  const OAuthPage({Key? key}) : super(key: key);

  Future<oauth2.Client> createClient() async {
    // If we don't have OAuth2 credentials yet, we need to get the resource owner
    // to authorize us. We're assuming here that we're a command-line application.
    var grant = oauth2.AuthorizationCodeGrant(
        identifier, authorizationEndpoint, tokenEndpoint);

    const uuid = Uuid();
    final state = uuid.v4().toString();
    const scopes = ["activity", "profile", "sleep", "social", "temperature"];
    // A URL on the authorization server (authorizationEndpoint with some additional
    // query parameters). Scopes and state can optionally be passed into this method.

    var authorizationUrl =
        grant.getAuthorizationUrl(redirectUri, scopes: scopes, state: state);
    if (await canLaunchUrl(Uri.parse(authorizationUrl.toString()))) {
      await launchUrl(Uri.parse(authorizationUrl.toString()));
    }

    // ------- 8< -------
    var responseUrl = await listen();

    // Once the user is redirected to `redirectUrl`, pass the query parameters to
    // the AuthorizationCodeGrant. It will validate them and extract the
    // authorization code to create a new Client.
    return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
  }

  Future<Uri> listen() async {
    StreamSubscription _sub;
    Uri? responseUrl;
    _sub = linkStream.listen((String? uri) {
      if (uri.toString().startsWith(redirectUrl)) {
        logger.d(uri);
        responseUrl = Uri.parse(uri!);
      }
    });
    logger.d(responseUrl);
    return responseUrl!;
  }


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
                var client = await createClient();
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
