import 'dart:convert';
import 'package:http/http.dart' as http;
import 'repo.dart';

class GithubService {
  final String token;

  GithubService(this.token);

  Future<List<Repo>> fetchRepositories() async {
    final response = await http.get(
      Uri.parse("https://api.github.com/user/repos"),
      headers: {
        "Authorization": "token $token",
        "Accept": "application/vnd.github+json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Falha ao carregar repositórios");
    }

    final List data = jsonDecode(response.body);

    return data.map((repoJson) => Repo.fromJson(repoJson)).toList();
  }
}
