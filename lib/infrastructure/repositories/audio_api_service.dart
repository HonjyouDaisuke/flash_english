import 'dart:convert';

import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flash_english/presentation/providers/auth_provider.dart';

class AudioApiService {
  final ApiClient apiClient;
  final AuthNotifier authNotifier;

  AudioApiService({
    required this.apiClient,
    required this.authNotifier,
  });
// try {
//       final response = await apiClient.post(
//         '/flash_english_backend/api/getall-user-settings',
//         body: {
//           'user_id': userId,
//         },
//       );
//       debugPrint(
//           "---------get user setting ---------------- status=${response.statusCode}");
//       if (response.statusCode < 200 || response.statusCode >= 300) {
//         debugPrint("Error get All unit score: status ${response.statusCode}");
//         return [];
//       }
//       final decoded = jsonDecode(response.body);

//       if (decoded == null) return [];

//       final List data = decoded;

//       return data.map((e) => UserSetting.fromJson(e)).toList();
//     } catch (e) {
//       debugPrint("Error get All user settings: $e");
//       return [];
//     }
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
