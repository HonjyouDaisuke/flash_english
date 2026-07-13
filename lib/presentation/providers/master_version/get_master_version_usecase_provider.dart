import 'package:flash_english/application/usecases/get_master_version_usecase.dart';
import 'package:flash_english/presentation/providers/master_version/master_version_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMasterVersionUsecaseProvider =
    Provider<GetMasterVersionUsecase>((ref) {
  return GetMasterVersionUsecase(
    ref.watch(masterVersionRepositoryProvider),
  );
});
