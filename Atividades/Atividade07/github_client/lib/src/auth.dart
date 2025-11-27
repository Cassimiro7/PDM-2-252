import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

class AuthModel extends ChangeNotifier {
  String? accessToken;

  final String clientId = "Ov23liCotJFcwCiphRwD";
  final String clientSecret = "a49a0f4302449ace717b196abc979aea215272d9";

  Future<void> login() async {
    final redirectUrl = "http://localhost:8585/callback";

    final authUrl =
        "https://github.com/login/oauth/authorize"
        "?client_id=$clientId"
        "&redirect_uri=$redirectUrl"
        "&scope=repo,user";

    // 1. Autenticação pelo navegador
    final callbackUrl = await FlutterWebAuth2.authenticate(
  url: authUrl,
  callbackUrlScheme: "http://localhost:8585",
);


    // 2. Extrai o code
    final code = Uri.parse(callbackUrl).queryParameters["code"];

    // 3. Troca o code pelo token
    final response = await http.post(
      Uri.parse("https://github.com/login/oauth/access_token"),
      headers: {"Accept": "application/json"},
      body: {
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": code!,
        "redirect_uri": redirectUrl,
      },
    );

    final data = jsonDecode(response.body);
    accessToken = data["access_token"];

    notifyListeners();
  }
}
