import 'package:audioplayers/audioplayers.dart';
import 'package:flash_english/domain/repositories/audio_player_repository.dart';

class AudioPlayerRepositoryImpl implements AudioPlayerRepository {
  final AudioPlayer _player = AudioPlayer();

  @override
  Future<void> play(String path) async {
    await _player.stop();
    await _player.play(AssetSource(path));
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }
}
