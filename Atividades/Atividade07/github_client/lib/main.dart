import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/auth.dart';
import 'src/repo_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);

    return MaterialApp(
      home: auth.accessToken == null
          ? const LoginScreen()
          : RepoListScreen(auth: auth),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("GitHub Client")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await auth.login();
          },
          child: const Text("Login com GitHub"),
        ),
      ),
    );
  }
}
