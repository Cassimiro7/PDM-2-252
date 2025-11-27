import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient createGitHubClient(String accessToken) {
  final httpLink = HttpLink(
    'https://api.github.com/graphql',
    defaultHeaders: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  return GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  );
}
