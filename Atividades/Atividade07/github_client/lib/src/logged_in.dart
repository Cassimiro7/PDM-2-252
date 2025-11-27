import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

class LoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Logado"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: auth.signOut,
          )
        ],
      ),
      body: Center(
        child: Text(
          "Login realizado com sucesso!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
