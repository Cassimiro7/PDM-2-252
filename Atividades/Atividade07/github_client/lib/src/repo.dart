class Repo {
  final String name;
  final String htmlUrl;

  Repo({
    required this.name,
    required this.htmlUrl,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      htmlUrl: json['html_url'],
    );
  }
}
