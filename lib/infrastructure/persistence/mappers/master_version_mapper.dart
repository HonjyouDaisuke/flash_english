import 'package:flash_english/domain/entities/master_version.dart';

class MasterVersionMapper {
  static Map<String, dynamic> toMap(MasterVersion q) {
    return {
      'version_id': q.versionId,
      'version_no': q.versionNo,
      'version_name': q.versionName,
      'version_description': q.versionDescription,
    };
  }

  static MasterVersion fromMap(Map<String, dynamic> map) {
    return MasterVersion(
      versionId: (map['version_id'] as num).toInt(),
      versionNo: map['version_no'] as String,
      versionName: map['version_name'] as String,
      versionDescription: map['version_description'] as String,
    );
  }
}
