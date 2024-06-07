import 'dart:convert';
import 'package:amplify_core/amplify_core.dart';
import 'package:xerian/models/Account.dart';

class SearchService {
  static const graphQLDocument = '''
    query Echo(\$matchString: String!) {
      searchAccounts(matchString: \$matchString) {
        number
        firstName
        lastName
      }
    }
  ''';

  Future<List<Echo>> accountSearch(matchString) async {
    final request = GraphQLRequest<String>(
      document: graphQLDocument,
      variables: <String, String>{"matchString": matchString},
    );
    final response = await Amplify.API.query(request: request).response;
    safePrint(response);
    Map<String, dynamic> jsonMap = json.decode(response.data!);
    safePrint(jsonMap);
    List<Echo> result = [];

    // ignore: prefer_typing_uninitialized_variables
    var echo;
    for (echo in jsonMap['searchAccounts']) {
      result.add(Echo.fromJson(echo));
    }

    return result;

//    EchoResponse echoResponse = EchoResponse.fromJson(jsonMap);
//    return echoResponse.echos;
  }

  Future<List<Account>> accountCallback(String pattern) async =>
      Future<List<Account>>.delayed(
        const Duration(milliseconds: 300),
        () => [Account(number: '1', firstName: 'andrew')],
      );
}

class EchoResponse {
  final List<Echo> echos;

  EchoResponse({required this.echos});

  factory EchoResponse.fromJson(Map<String, dynamic> json) {
    return EchoResponse(echos: [] // Echo.fromJson(json['echo']),
        );
  }
}

class Echo {
  final String number;
  final String firstName;
  final String? lastName;

  Echo({required this.number, required this.firstName, this.lastName});

  factory Echo.fromJson(Map<String, dynamic> json) {
    return Echo(
      number: json['number'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
