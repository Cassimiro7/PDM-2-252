class GitHubUser {
  final String login;
  final String avatarUrl;

  GitHubUser({required this.login, required this.avatarUrl});

  factory GitHubUser.fromJson(Map<String, dynamic> map) {
    return GitHubUser(
      login: map['login'],
      avatarUrl: map['avatar_url'],
    );
  }
}
