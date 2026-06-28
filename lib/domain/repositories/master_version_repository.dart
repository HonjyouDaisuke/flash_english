import 'package:flash_english/domain/entities/master_version.dart';

abstract class MasterVersionRepository {
  Future<bool> isNeedUpdate(String versionName);
  Future<MasterVersion> getVersionApi(String versionName);
  Future<MasterVersion> getLoalVersion(String versionName);
  Future<bool> saveVersion(MasterVersion currentVersion);
}
