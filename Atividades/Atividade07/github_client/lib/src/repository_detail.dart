import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryDetail extends StatelessWidget {
  final Map<String, dynamic> repo;

  RepositoryDetail({required this.repo});

  @override
  Widget build(BuildContext context) {
    final url = "https://github.com/${repo['name']}";

    return Scaffold(
      appBar: AppBar(title: Text(repo['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(repo['description'] ?? "Sem descrição"),
            SizedBox(height: 20),
            Text("⭐ ${repo['stargazerCount']} estrelas"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              },
              child: Text("Abrir no GitHub"),
            ),
          ],
        ),
      ),
    );
  }
}
