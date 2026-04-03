import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flash_english/domain/repositories/audio_player_repository.dart';

class AudioPlayerRepositoryImpl implements AudioPlayerRepository {
  final AudioPlayer _player = AudioPlayer();

  @override
  Future<void> play(String path) async {
    await _player.stop();
    final completer = Completer<void>();
    _player.onPlayerComplete.first.then((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    await _player.play(AssetSource(path));
    await completer.future;
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> onComplete() async {
    await _player.onPlayerComplete.first;
  }
}
