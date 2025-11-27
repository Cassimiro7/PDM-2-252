import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'github_login_button.dart';
import 'repository_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthModel>();

    if (auth.accessToken == null) {
      return Scaffold(
        appBar: AppBar(title: Text('GitHub Client')),
        body: Center(child: GitHubLoginButton()),
      );
    }

    return RepositoryList(token: auth.accessToken!);
  }
}
