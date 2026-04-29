class AppConfig {
  static const env = String.fromEnvironment('ENV', defaultValue: 'local');

  static const baseUrl = String.fromEnvironment('BASE_URL');

  static bool get isProd => env == 'prod';

  /// アプリ起動時に呼び出して設定不備を早期検知する。
  static void assertConfigured() {
    assert(
      baseUrl.isNotEmpty,
      'BASE_URL is not defined. Pass --dart-define-from-file=config/local.json',
    );
  }
}
