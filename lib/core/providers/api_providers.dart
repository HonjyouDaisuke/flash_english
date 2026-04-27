import 'package:flash_english/application/usecases/login_usecase.dart';
import 'package:flash_english/core/config/env_provider.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/authentication/auth_backend.dart';
import 'package:flash_english/infrastructure/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  final baseUrl = ref.watch(baseUrlProvider);

  return ApiClient(storage, baseUrl);
});

final authBackendProvider = Provider<AuthBackend>((ref) {
  final api = ref.watch(apiClientProvider);
  return AuthBackend(api);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(
    authBackend: ref.watch(authBackendProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});
