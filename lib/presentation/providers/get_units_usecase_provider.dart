import 'package:flash_english/application/usecases/get_units_usecase.dart';
import 'package:flash_english/presentation/providers/check_download_audio_usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash_english/presentation/providers/unit_repository_provider.dart';

final getUnitsUseCaseProvider = Provider<GetUnitsUseCase>((ref) {
  return GetUnitsUseCase(
    ref.watch(
      unitRepositoryProvider,
    ),
    ref.watch(
      checkDownloadAudioUseCaseProvider,
    ),
  );
});
