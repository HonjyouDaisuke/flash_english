import 'package:flash_english/domain/entities/unit.dart';
import 'package:flash_english/domain/repositories/audio_download_repository.dart';

class CheckDownloadAudioUseCase {
  final AudioDownloadRepository repository;

  CheckDownloadAudioUseCase(
    this.repository,
  );

  Future<List<Unit>> execute(List<Unit> units) async {
    final result = <Unit>[];

    for (final unit in units) {
      if (await repository.exists(
        unit.categoryNo,
        unit.unitNo,
      )) {
        result.add(unit);
      }
    }

    return result;
  }
}
