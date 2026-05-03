import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_english/application/usecases/login_usecase.dart';
import 'package:flash_english/infrastructure/authentication/auth_backend.dart';
import 'package:flash_english/infrastructure/storage/token_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBackend extends Mock implements AuthBackend {}

class MockTokenStorage extends Mock implements TokenStorage {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthBackend authBackend;
  late MockTokenStorage tokenStorage;

  setUp(() {
    authBackend = MockAuthBackend();
    tokenStorage = MockTokenStorage();
  });

  group('LoginUseCase.login', () {
    test('Googleログインキャンセル時 false を返す', () async {
      final spy = _LoginUseCaseSpy(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
      );

      spy.signInResult = null;

      final result = await spy.login();

      expect(result, false);
      verifyNever(() => authBackend.callBackend(any()));
    });

    test('user が null の場合 false を返す', () async {
      final credential = MockUserCredential();

      when(() => credential.user).thenReturn(null);

      final spy = _LoginUseCaseSpy(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
      );

      spy.signInResult = credential;

      final result = await spy.login();

      expect(result, false);
    });

    test('idToken が null の場合 false を返す', () async {
      final credential = MockUserCredential();
      final user = MockUser();

      when(() => credential.user).thenReturn(user);
      when(() => user.getIdToken()).thenAnswer((_) async => null);

      final spy = _LoginUseCaseSpy(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
      );

      spy.signInResult = credential;

      final result = await spy.login();

      expect(result, false);
    });

    test('バックエンド結果が null の場合 false を返す', () async {
      final credential = MockUserCredential();
      final user = MockUser();

      when(() => credential.user).thenReturn(user);
      when(() => user.getIdToken()).thenAnswer((_) async => 'token');
      when(() => authBackend.callBackend('token'))
          .thenAnswer((_) async => null);

      final spy = _LoginUseCaseSpy(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
      );

      spy.signInResult = credential;

      final result = await spy.login();

      expect(result, false);
    });

    test('access_token が無い場合 false を返す', () async {
      final credential = MockUserCredential();
      final user = MockUser();

      when(() => credential.user).thenReturn(user);
      when(() => user.getIdToken()).thenAnswer((_) async => 'token');

      when(() => authBackend.callBackend('token')).thenAnswer(
        (_) async => {
          'refresh_token': 'refresh',
        },
      );

      final spy = _LoginUseCaseSpy(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
      );

      spy.signInResult = credential;

      final result = await spy.login();

      expect(result, false);
    });

    test('refresh_token が null の場合 false を返す', () async {
      final credential = MockUserCredential();
      final user = MockUser();

      when(() => credential.user).thenReturn(user);
      when(() => user.getIdToken()).thenAnswer((_) async => 'token');

      when(() => authBackend.callBackend('token')).thenAnswer(
        (_) async => {
          'access_token': 'access',
          'refresh_token': null,
        },
      );

      final spy = _LoginUseCaseSpy(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
      );

      spy.signInResult = credential;

      final result = await spy.login();

      expect(result, false);
    });

    test('正常系: token保存して true を返す', () async {
      final credential = MockUserCredential();
      final user = MockUser();

      when(() => credential.user).thenReturn(user);
      when(() => user.getIdToken()).thenAnswer((_) async => 'token');

      when(() => authBackend.callBackend('token')).thenAnswer(
        (_) async => {
          'access_token': 'access123',
          'refresh_token': 'refresh123',
        },
      );

      when(
        () => tokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final spy = _LoginUseCaseSpy(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
      );

      spy.signInResult = credential;

      final result = await spy.login();

      expect(result, true);

      verify(
        () => tokenStorage.saveTokens(
          accessToken: 'access123',
          refreshToken: 'refresh123',
        ),
      ).called(1);
    });

    test('例外発生時 false を返す', () async {
      final spy = _LoginUseCaseSpy(
        authBackend: authBackend,
        tokenStorage: tokenStorage,
      );

      spy.throwException = true;

      final result = await spy.login();

      expect(result, false);
    });
  });
}

/// signInWithGoogle を差し替えるための Spy
class _LoginUseCaseSpy extends LoginUseCase {
  _LoginUseCaseSpy({
    required super.authBackend,
    required super.tokenStorage,
  });

  UserCredential? signInResult;
  bool throwException = false;

  @override
  Future<UserCredential?> signInWithGoogle() async {
    if (throwException) {
      throw Exception('login error');
    }
    return signInResult;
  }
}
