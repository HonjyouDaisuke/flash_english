import 'package:flash_english/domain/entities/master_version.dart';
import 'package:flash_english/domain/repositories/master_version_repository.dart';

class SaveMasterVersionUsecase {
  SaveMasterVersionUsecase(this.repository);

  final MasterVersionRepository repository;

  Future<bool> execute(MasterVersion newVersion) {
    return repository.saveVersion(newVersion);
  }
}
