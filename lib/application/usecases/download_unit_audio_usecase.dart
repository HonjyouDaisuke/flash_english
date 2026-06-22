import 'package:flash_english/domain/repositories/audio_download_repository.dart';

class DownloadUnitAudioUseCase {
  final AudioDownloadRepository repository;

  DownloadUnitAudioUseCase(
    this.repository,
  );

  Future<void> execute(
    int categoryNo,
    int unitNo,
  ) async {
    final exists = await repository.exists(
      categoryNo,
      unitNo,
    );

    if (exists) {
      return;
    }

    await repository.download(
      categoryNo,
      unitNo,
    );
  }
}
