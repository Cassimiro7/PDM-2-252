import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubApi {
  final String token;

  GitHubApi(this.token);

  Future<dynamic> getRepos() async {
    final response = await http.get(
      Uri.parse("https://api.github.com/user/repos"),
      headers: {"Authorization": "Bearer $token"},
    );

    return json.decode(response.body);
  }
}
