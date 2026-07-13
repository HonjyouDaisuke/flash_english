import 'package:flash_english/application/usecases/play_audio_usecase.dart';
import 'package:flash_english/domain/repositories/audio_player_repository.dart';
import 'package:flash_english/domain/repositories/audio_download_repository.dart';
import 'package:flash_english/infrastructure/repositories/audio_download_repository_impl.dart';
import 'package:flash_english/infrastructure/repositories/audio_player_repository_impl.dart';
import 'package:flash_english/presentation/providers/audio/audio_api_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioPlayerRepositoryProvider = Provider<AudioPlayerRepository>((ref) {
  return AudioPlayerRepositoryImpl();
});

final playAudioUseCaseProvider = Provider((ref) {
  final repo = ref.read(audioPlayerRepositoryProvider);
  return PlayAudioUseCase(repo);
});

final audioDownloadRepositoryProvider =
    Provider<AudioDownloadRepository>((ref) {
  return AudioDownloadRepositoryImpl(
    ref.read(audioApiServiceProvider),
  );
});
