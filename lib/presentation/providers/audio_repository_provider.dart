import 'package:flash_english/application/usecases/play_audio_usecase.dart';
import 'package:flash_english/domain/repositories/audio_player_repository.dart';
import 'package:flash_english/infrastructure/repositories/audio_player_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioRepositoryProvider = Provider<AudioPlayerRepository>((ref) {
  return AudioPlayerRepositoryImpl();
});

final playAudioUseCaseProvider = Provider((ref) {
  final repo = ref.read(audioRepositoryProvider);
  return PlayAudioUseCase(repo);
});
