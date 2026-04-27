import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/storage/token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);

  const baseUrl = String.fromEnvironment(
    'BASE_URL',
  );

  return ApiClient(
    tokenStorage,
    baseUrl,
  );
});
