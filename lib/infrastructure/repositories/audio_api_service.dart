import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/presentation/providers/auth/auth_provider.dart';

class AudioApiService {
  final ApiClient apiClient;
  final AuthNotifier authNotifier;

  AudioApiService({
    required this.apiClient,
    required this.authNotifier,
  });

  Future<List<int>> downloadAudio(
    int categoryNo,
    int unitNo,
  ) async {
    final response = await apiClient.post(
      '/flash_english_backend/api/download-audio',
      body: {
        'categoryId': categoryNo,
        'unitId': unitNo,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Audio download failed',
      );
    }

    return response.bodyBytes;
  }
}
