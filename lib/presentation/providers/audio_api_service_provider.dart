import 'package:flash_english/infrastructure/repositories/audio_api_service.dart';
import 'package:flash_english/presentation/providers/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

final audioApiServiceProvider = Provider<AudioApiService>((ref) {
  final authNotifier = ref.read(authProvider.notifier);

  return AudioApiService(
    apiClient: ref.read(apiClientProvider),
    authNotifier: authNotifier,
  );
});
