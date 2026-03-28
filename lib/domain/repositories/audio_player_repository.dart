abstract class AudioPlayerRepository {
  Future<void> play(String path);
  Future<void> stop();
}
