abstract class SeedRepository {
  Future<bool> isSeeded();
  Future<void> setSeeded();
  Future<void> seed();
  Future<void> reset();
}
