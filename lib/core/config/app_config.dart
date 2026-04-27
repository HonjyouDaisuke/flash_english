class AppConfig {
  static const env = String.fromEnvironment('ENV');

  static const baseUrl = String.fromEnvironment('BASE_URL');

  static bool get isProd => env == 'prod';
}
