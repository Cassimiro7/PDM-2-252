import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'github_service.dart';
import 'repo.dart';
import 'auth.dart';

class RepoListScreen extends StatelessWidget {
  final AuthModel auth;

  const RepoListScreen({super.key, required this.auth});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Não foi possível abrir: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = GithubService(auth.accessToken!);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Repositórios"),
      ),
      body: FutureBuilder<List<Repo>>(
        future: service.fetchRepositories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar repositórios"));
          }

          final repos = snapshot.data!;

          return ListView.builder(
            itemCount: repos.length,
            itemBuilder: (context, index) {
              final repo = repos[index];
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repo.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () => _openUrl(repo.htmlUrl),
                      child: Text(
                        repo.htmlUrl,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
