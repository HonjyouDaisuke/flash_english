import 'package:flash_english/domain/repositories/ping_repository.dart';
import 'package:flash_english/infrastructure/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PingRepositoryImpl implements PingRepository {
  final ApiClient _apiClient;

  PingRepositoryImpl(this._apiClient);

  @override
  Future<bool> ping() async {
    try {
      debugPrint(
          "ping start = ${DateFormat('yyyy/MM/dd').format(DateTime.now())}");
      final response = await _apiClient.post(
        '/flash_english_backend/api/ping',
        body: {
          'timestamp': DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()),
        },
      );
      debugPrint("ping response = ${response.body}");
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint("Error pinging API: status ${response.statusCode}");
        return false;
      }
      return true;
    } catch (e) {
      debugPrint("Error pinging API: $e");
      return false;
    }
  }
}
