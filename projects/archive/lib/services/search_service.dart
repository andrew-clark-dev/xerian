import 'dart:convert';
import 'package:amplify_core/amplify_core.dart';

class SearchService {
  static const accountGraphQLDocument = '''
    query SimpleSearchReponse(\$matchString: String!) {
      searchAccounts(matchString: \$matchString) {
        id
        number
        firstName
        lastName
        email
      }
    }
  ''';

  Future<List<SimpleSearchReponse>> _search(matchString, queryName,
      graphQLDocument, titleFields, subtitleFields) async {
    final request = GraphQLRequest<String>(
      document: graphQLDocument,
      variables: <String, String>{"matchString": matchString},
    );
    final response = await Amplify.API.query(request: request).response;
    Map<String, dynamic> jsonMap = json.decode(response.data!);
    final queryReturns = jsonMap[queryName];
    if (queryReturns.isEmpty) return [];
    safePrint(jsonMap);

    List<SimpleSearchReponse> hits = [];

    for (var hit in queryReturns) {
      hits.add(SimpleSearchReponse.fromJson(hit, titleFields, subtitleFields));
    }

    return hits;
  }

  Future<List<SimpleSearchReponse>> accountSearch(matchString) async {
    return _search(matchString, 'searchAccounts', accountGraphQLDocument,
        ['number'], ['firstName', 'lastName', 'email']);
  }
}

class SimpleSearchReponse {
  final String? id;
  final String? title;
  final String? subtitle;

  SimpleSearchReponse({this.id, this.title, this.subtitle});

  factory SimpleSearchReponse.fromJson(
      Map<String, dynamic> json, titleFields, subtitleFields) {
    safePrint(json);

    return SimpleSearchReponse(
      id: json['id'],
      title: titleFields.map((field) => json[field]).join(' '),
      subtitle: subtitleFields.map((field) => json[field]).join(' '),
    );
  }
}
