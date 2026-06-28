import 'package:flash_english/domain/entities/master_version.dart';
import 'package:flash_english/domain/repositories/master_version_repository.dart';

class GetMasterVersionUsecase {
  GetMasterVersionUsecase(this.repository);

  final MasterVersionRepository repository;

  Future<MasterVersion> execute(String versionName) {
    return repository.getVersionApi(versionName);
  }
}
