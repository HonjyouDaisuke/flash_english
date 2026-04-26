import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flash_english/infrastructure/storage/token_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterSecureStorage storage;
  late TokenStorage tokenStorage;

  setUp(() {
    storage = MockFlutterSecureStorage();

    tokenStorage = TokenStorage(
      storage: storage,
    );
  });

  group('TokenStorage', () {
    test('saveTokens() accessTokenのみ保存', () async {
      when(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      when(() => storage.delete(
            key: any(named: 'key'),
          )).thenAnswer((_) async {});

      await tokenStorage.saveTokens(
        accessToken: 'abc123',
      );

      verify(() => storage.write(
            key: 'access_token',
            value: 'abc123',
          )).called(1);

      verify(() => storage.delete(
            key: 'refresh_token',
          )).called(1);
    });

    test('saveTokens() refreshTokenあり保存', () async {
      when(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      await tokenStorage.saveTokens(
        accessToken: 'abc123',
        refreshToken: 'ref999',
      );

      verify(() => storage.write(
            key: 'access_token',
            value: 'abc123',
          )).called(1);

      verify(() => storage.write(
            key: 'refresh_token',
            value: 'ref999',
          )).called(1);
    });

    test('getAccessToken()', () async {
      when(() => storage.read(
            key: 'access_token',
          )).thenAnswer((_) async => 'token123');

      final result = await tokenStorage.getAccessToken();

      expect(result, 'token123');
    });

    test('getRefreshToken()', () async {
      when(() => storage.read(
            key: 'refresh_token',
          )).thenAnswer((_) async => 'refresh456');

      final result = await tokenStorage.getRefreshToken();

      expect(result, 'refresh456');
    });

    test('clear()', () async {
      when(() => storage.deleteAll()).thenAnswer((_) async {});

      await tokenStorage.clear();

      verify(() => storage.deleteAll()).called(1);
    });
  });
}
