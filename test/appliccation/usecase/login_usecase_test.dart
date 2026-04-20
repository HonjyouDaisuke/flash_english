import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flash_english/application/usecases/login_usecase.dart';
import 'package:flash_english/infrastructure/authentication/auth_backend.dart';
import 'package:flash_english/infrastructure/storage/token_storage.dart';

class MockAuthBackend extends Mock implements AuthBackend {}

class MockTokenStorage extends Mock implements TokenStorage {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class TestLoginUseCase extends LoginUseCase {
  final UserCredential? credential;

  TestLoginUseCase({
    required super.authBackend,
    required super.tokenStorage,
    required this.credential,
  });

  @override
  Future<UserCredential?> signInWithGoogle() async {
    return credential;
  }
}

void main() {
  late MockAuthBackend authBackend;
  late MockTokenStorage tokenStorage;

  setUp(() {
    authBackend = MockAuthBackend();
    tokenStorage = MockTokenStorage();
  });

  group('LoginUseCase', () {
    test('Googleログインキャンセル時 false を返す', () async {
      final useCase = TestLoginUseCase(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
        credential: null,
      );

      final result = await useCase.login();

      expect(result, false);
    });

    test('IDトークン取得失敗時 false を返す', () async {
      final user = MockUser();
      final credential = MockUserCredential();

      when(() => credential.user).thenReturn(user);
      when(() => user.getIdToken()).thenAnswer((_) async => null);

      final useCase = TestLoginUseCase(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
        credential: credential,
      );

      final result = await useCase.login();

      expect(result, false);
    });

    test('バックエンド成功時 true を返し token保存する', () async {
      final user = MockUser();
      final credential = MockUserCredential();

      when(() => credential.user).thenReturn(user);
      when(() => user.email).thenReturn('test@test.com');
      when(() => user.getIdToken()).thenAnswer((_) async => 'firebase_token');

      when(() => authBackend.callBackend('firebase_token')).thenAnswer(
        (_) async => {
          'access_token': 'access123',
          'refresh_token': 'refresh123',
        },
      );

      when(() => tokenStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      when(() => tokenStorage.getAccessToken())
          .thenAnswer((_) async => 'access123');

      final useCase = TestLoginUseCase(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
        credential: credential,
      );

      final result = await useCase.login();

      expect(result, true);

      verify(() => tokenStorage.saveTokens(
            accessToken: 'access123',
            refreshToken: 'refresh123',
          )).called(1);
    });

    test('backend token不足時 false を返す', () async {
      final user = MockUser();
      final credential = MockUserCredential();

      when(() => credential.user).thenReturn(user);
      when(() => user.getIdToken()).thenAnswer((_) async => 'firebase_token');

      when(() => authBackend.callBackend('firebase_token'))
          .thenAnswer((_) async => {});

      final useCase = TestLoginUseCase(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
        credential: credential,
      );

      final result = await useCase.login();

      expect(result, false);
    });
  });
}
