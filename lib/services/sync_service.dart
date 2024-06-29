import "dart:typed_data";

import 'package:amplify_core/amplify_core.dart';
import "package:aws_lambda_api/lambda-2015-03-31.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:xerian/services/amplify_extentions.dart";
import 'package:amplify_api/amplify_api.dart';
import 'package:http/http.dart' as http;

class SyncSevice {
  final ModelType modelType;

  SyncSevice(this.modelType);

  static Future<void> getAllCountries() async {
    try {
      var client = http.Client();
      var uri = Uri.parse(
        'https://8nlibs59ul.execute-api.eu-central-1.amazonaws.com/dev/sync-account',
      );
      final credentials = await Amplify.Auth.awsClientCredentials();
      var response = await client.put(
        uri,
        headers: {
          //🚨 don't embed api keys in real life!!
          "x-api-key": credentials.sessionToken!,
        },
      );
    } on Exception catch (e) {
      safePrint(e);
    }
  }

  static Future<void> syncAccount() async {
    try {
      var put = Amplify.API.put("/",
          apiName: "sync-account", queryParameters: {'greeter': 'john'});
      AWSHttpResponse response = await put.response;
      safePrint(response.body);
    } on Exception catch (e) {
      safePrint(e);
      rethrow;
    }
  }

  static Future<void> synchronize({DateTime? from, DateTime? to}) async {
    try {
      final service = Lambda(
          region: dotenv.env['AWS_REGION']!,
          credentials: await Amplify.Auth.awsClientCredentials());

      try {
// Edit the payload you need to provide if necessary
        List<int> list =
            '{"key1": "value1","key2": "value2","key3": "value3"}'.codeUnits;
// Edit the functionName parameter to the function name you want to invoke
        InvocationResponse lambdaResponse = await service.invoke(
            functionName:
                "amplify-xerian-andrew-sandb-sayhellolambdaEFA46D92-RMfnIjyUyXN6",
            invocationType: InvocationType.requestResponse,
            payload: Uint8List.fromList(list));
//The payload is returned in a Uint8List but we want to convert it to something readable
        print(String.fromCharCodes(lambdaResponse.payload as Iterable<int>));
      } catch (e) {
        print("error");
        print(e);
        rethrow;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
