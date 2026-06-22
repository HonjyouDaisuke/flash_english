import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:flash_english/domain/repositories/audio_download_repository.dart';
import 'package:flash_english/infrastructure/repositories/audio_api_service.dart';
import 'package:path_provider/path_provider.dart';

class AudioDownloadRepositoryImpl implements AudioDownloadRepository {
  final AudioApiService apiService;

  AudioDownloadRepositoryImpl(this.apiService);

  @override
  Future<bool> exists(
    int categoryNo,
    int unitNo,
  ) async {
    final dir = await getApplicationDocumentsDirectory();

    final completedFile = File(
      '${dir.path}/audio/'
      'unit_${categoryNo.toString().padLeft(2, '0')}_'
      '${unitNo.toString().padLeft(2, '0')}/'
      '.completed',
    );

    return await completedFile.exists();
  }

  @override
  Future<void> download(
    int categoryNo,
    int unitNo,
  ) async {
    final zipBytes = await apiService.downloadAudio(
      categoryNo,
      unitNo,
    );

    final archive = ZipDecoder().decodeBytes(zipBytes);

    final dir = await getApplicationDocumentsDirectory();

    final targetDir = Directory(
      '${dir.path}/audio/'
      'unit_${categoryNo.toString().padLeft(2, '0')}_'
      '${unitNo.toString().padLeft(2, '0')}',
    );

    if (!await targetDir.exists()) {
      await targetDir.create(
        recursive: true,
      );
    }

    for (final file in archive) {
      if (!file.isFile) continue;

      final outputPath = p.normalize(p.join(targetDir.path, file.name));
      if (!p.isWithin(targetDir.path, outputPath)) {
        throw const FormatException('Invalid zip entry path');
      }
      final outputFile = File(outputPath);

      await outputFile.parent.create(
        recursive: true,
      );

      await outputFile.writeAsBytes(
        file.content as List<int>,
      );
    }

    // すべて成功したら完了ファイル作成
    final completedFile = File(
      '${targetDir.path}/.completed',
    );

    await completedFile.writeAsString(
      DateTime.now().toIso8601String(),
    );
  }
}
