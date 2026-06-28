import 'package:flash_english/domain/repositories/master_version_repository.dart';
import 'package:flash_english/infrastructure/repositories/master_version_repository_impl.dart';
import 'package:flash_english/presentation/providers/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saveMasterVersionUsecaseProvider =
    Provider<MasterVersionRepository>((ref) {
  return MasterVersionRepositoryImpl(
    ref.read(
      apiClientProvider,
    ),
  );
});
