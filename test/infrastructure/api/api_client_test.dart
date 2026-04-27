import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/storage/token_storage.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockTokenStorage storage;
  late ApiClient apiClient;

  setUp(() {
    storage = MockTokenStorage();

    apiClient = ApiClient(
      storage,
      'https://example.com',
    );
  });

  group('ApiClient', () {
    test('post() tokenありでAuthorizationヘッダー付き送信', () async {
      when(() => storage.getAccessToken()).thenAnswer((_) async => 'abc123');

      final response = await apiClient.post(
        'https://example.com/test',
        body: {'name': 'flash'},
      );

      expect(response.request!.headers['Authorization'], 'Bearer abc123');
      expect(response.request!.headers['Content-Type'], 'application/json');
      expect(
        response.request!.url.toString(),
        'https://example.com/test',
      );
    });

    test('post() tokenなしならAuthorizationなし', () async {
      when(() => storage.getAccessToken()).thenAnswer((_) async => null);

      final response = await apiClient.post(
        'https://example.com/test',
        body: {'name': 'flash'},
      );

      expect(
        response.request!.headers.containsKey('Authorization'),
        false,
      );
    });

    test('get() tokenありでAuthorizationヘッダー付き', () async {
      when(() => storage.getAccessToken()).thenAnswer((_) async => 'token999');

      final response = await apiClient.get(
        'https://example.com/users',
      );

      expect(response.request!.headers['Authorization'], 'Bearer token999');
      expect(
        response.request!.url.toString(),
        'https://example.com/users',
      );
    });

    test('jsonEncode確認', () {
      final json = jsonEncode({
        'id': 1,
        'name': 'Flash English',
      });

      expect(
        json,
        '{"id":1,"name":"Flash English"}',
      );
    });
  });
}
