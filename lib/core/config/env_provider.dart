import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config.dart';

final baseUrlProvider = Provider<String>((ref) {
  return AppConfig.baseUrl;
});
