abstract class AudioDownloadRepository {
  Future<bool> exists(
    int categoryNo,
    int unitNo,
  );

  Future<void> download(
    int categoryNo,
    int unitNo,
  );
}
