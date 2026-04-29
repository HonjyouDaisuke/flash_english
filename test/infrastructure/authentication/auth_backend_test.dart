import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:flash_english/infrastructure/authentication/auth_backend.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });
  late MockApiClient apiClient;
  late AuthBackend authBackend;

  setUp(() {
    apiClient = MockApiClient();
    authBackend = AuthBackend(apiClient);
  });

  group('AuthBackend', () {
    test('statusCode 200 の場合 token map を返す', () async {
      final body = jsonEncode({
        'access_token': 'abc123',
        'refresh_token': 'ref456',
      });

      when(
        () => apiClient.post(
          '/flash_english_backend/api/auth/google',
          body: {
            'id_token': 'firebase_token',
          },
        ),
      ).thenAnswer(
        (_) async => http.Response(body, 200),
      );

      final result = await authBackend.callBackend('firebase_token');

      expect(result, isNotNull);
      expect(result!['access_token'], 'abc123');
      expect(result['refresh_token'], 'ref456');
    });

    test('statusCode 401 の場合 null を返す', () async {
      when(
        () => apiClient.post(
          '/flash_english_backend/api/auth/google',
          body: {
            'id_token': 'bad_token',
          },
        ),
      ).thenAnswer(
        (_) async => http.Response('Unauthorized', 401),
      );

      final result = await authBackend.callBackend('bad_token');

      expect(result, isNull);
    });

    test('statusCode 500 の場合 null を返す', () async {
      when(
        () => apiClient.post(
          '/flash_english_backend/api/auth/google',
          body: {
            'id_token': 'firebase_token',
          },
        ),
      ).thenAnswer(
        (_) async => http.Response('Server Error', 500),
      );

      final result = await authBackend.callBackend('firebase_token');

      expect(result, isNull);
    });

    test('正しいURLでpostされる', () async {
      when(
        () => apiClient.post(
          any(),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => http.Response('{}', 200),
      );

      await authBackend.callBackend('token123');

      verify(
        () => apiClient.post(
          '/flash_english_backend/api/auth/google',
          body: {
            'id_token': 'token123',
          },
        ),
      ).called(1);
    });
  });
}
