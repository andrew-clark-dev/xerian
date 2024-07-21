// ignore: unused_import
import 'package:amplify_core/amplify_core.dart';
import 'package:encore_core/extentions.dart';
import 'package:test/test.dart';

class MockAuthSession extends AuthSession {
  MockAuthSession({required super.isSignedIn});
  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }
}

class MockAuthTrue extends AuthCategory {
  @override
  Future<AuthSession> fetchAuthSession({
    FetchAuthSessionOptions? options,
  }) =>
      Future<AuthSession>.value(MockAuthSession(isSignedIn: true));
}

class MockAuthFalse extends AuthCategory {
  @override
  Future<AuthSession> fetchAuthSession({
    FetchAuthSessionOptions? options,
  }) =>
      Future<AuthSession>.value(MockAuthSession(isSignedIn: false));
}

void main() {
  group('Amplify Extention tests', () {
    test('not isAuthorized: completion ✅', () async {
      final result = MockAuthFalse().isAuthorized;
      await expectLater(result, completion(isFalse));
    });

    test('isAuthorized: completion ✅', () async {
      final result = MockAuthTrue().isAuthorized;
      await expectLater(result, completion(isTrue));
    });
  });
}
