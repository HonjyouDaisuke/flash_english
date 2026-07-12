import 'package:flash_english/application/usecases/check_download_audio_usecase.dart';
import 'package:flash_english/presentation/providers/audio_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkDownloadAudioUseCaseProvider =
    Provider<CheckDownloadAudioUseCase>((ref) {
  return CheckDownloadAudioUseCase(
    ref.read(audioDownloadRepositoryProvider),
  );
});
