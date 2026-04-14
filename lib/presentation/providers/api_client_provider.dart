import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/infrastructure/storage/token_storage.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenStorage = TokenStorage();
  return ApiClient(tokenStorage);
});
