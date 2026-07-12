import 'package:flash_english/application/usecases/check_download_audio_usecase.dart';
import 'package:flash_english/domain/entities/unit.dart';
import 'package:flash_english/domain/repositories/unit_repository.dart';
import 'package:flutter/material.dart';

class GetUnitsUseCase {
  final UnitRepository repository;
  final CheckDownloadAudioUseCase checkDownloadAudioUseCase;

  GetUnitsUseCase(this.repository, this.checkDownloadAudioUseCase);

  Future<List<Unit>> call(int categoryNo, bool isOffline) async {
    final units = await repository.getByCategory(categoryNo);
    if (!isOffline) {
      debugPrint('Onlineなので、全てのユニットを返す');
      return units;
    }

    debugPrint('Offlineなので、オーディオファイルがダウンロードされているユニットのみを返す');
    return await checkDownloadAudioUseCase.execute(units);
  }

  Future<List<Unit>> callApi() {
    return repository.getAllApi();
  }
}
