import 'package:flash_english/domain/repositories/audio_player_repository.dart';

class PlayAudioUseCase {
  final AudioPlayerRepository repository;

  PlayAudioUseCase(this.repository);

  Future<void> execute(String path) async {
    if (path.isEmpty) return;
    await repository.play(path);
  }
}
