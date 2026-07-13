import 'package:flash_english/application/usecases/save_master_version_usecase.dart';
import 'package:flash_english/presentation/providers/master_version/master_version_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saveMasterVersionUsecaseProvider =
    Provider<SaveMasterVersionUsecase>((ref) {
  return SaveMasterVersionUsecase(
    ref.watch(masterVersionRepositoryProvider),
  );
});
