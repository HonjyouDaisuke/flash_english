import 'package:flash_english/core/providers/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash_english/domain/repositories/master_version_repository.dart';
import 'package:flash_english/infrastructure/repositories/master_version_repository_impl.dart';

final masterVersionRepositoryProvider =
    Provider<MasterVersionRepository>((ref) {
  return MasterVersionRepositoryImpl(
    ref.read(apiClientProvider),
  );
});
