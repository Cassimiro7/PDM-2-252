import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

class GithubLoginButton extends StatelessWidget {
  const GithubLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.read<AuthModel>().login(),
      child: const Text("Login com GitHub"),
    );
  }
}
