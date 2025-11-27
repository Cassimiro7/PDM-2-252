import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("GitHub Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: auth.signIn,
          child: const Text("Login com GitHub"),
        ),
      ),
    );
  }
}
