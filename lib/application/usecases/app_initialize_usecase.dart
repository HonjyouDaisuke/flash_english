import 'package:flash_english/application/usecases/initialize_app_usecase.dart';
import 'package:flash_english/application/usecases/ping_usecase.dart';
import 'package:flash_english/domain/entities/auth_status.dart';
import 'package:flash_english/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AppInitializeUseCase {
  final InitializeAppUseCase _initializeAppUseCase;
  final PingUseCase _pingUseCase;
  final AuthNotifier _authNotifier;

  AppInitializeUseCase({
    required InitializeAppUseCase initializeAppUseCase,
    required PingUseCase pingUseCase,
    required AuthNotifier authNotifier,
  })  : _initializeAppUseCase = initializeAppUseCase,
        _pingUseCase = pingUseCase,
        _authNotifier = authNotifier;

  Future<void> execute() async {
    await _initializeAppUseCase.execute();

    // オンラインかオフラインかを判定して状態を更新
    final isOnline = await _pingUseCase.ping();
    await _authNotifier.setIsOffline(!isOnline);

    await _authNotifier.loadToken();

    // トークンの有無と有効期限をチェックして認証状態を更新
    final token = _authNotifier.token;

    if (token == null) {
      _authNotifier.updateStatus(AuthStatus.nonToken);
      return;
    }

    // トークンの有効期限をチェックして状態を更新
    late final bool isExpired;
    try {
      isExpired = JwtDecoder.isExpired(token);
      _authNotifier.setIsExpired(isExpired);
    } catch (e) {
      debugPrint('トークン形式エラー: $e');
      _authNotifier.setIsExpired(true);
      _authNotifier.updateStatus(AuthStatus.nonToken);
      return;
    }

    if (isOnline) {
      if (isExpired) {
        debugPrint('オンライン状態でトークンが期限切れ...');
        _authNotifier.updateStatus(AuthStatus.onlineAuthExpired);
        return;
      } else {
        debugPrint('オンライン状態でトークンは有効...');
        _authNotifier.updateStatus(AuthStatus.onlineAuthenticated);
        return;
      }
    } else {
      if (isExpired) {
        debugPrint('オフライン状態でトークンが期限切れ...');
        _authNotifier.updateStatus(AuthStatus.offlineAuthExpired);
        return;
      } else {
        debugPrint('オフライン状態でトークンは有効...');
        _authNotifier.updateStatus(AuthStatus.offlineAuthenticated);
        return;
      }
    }
  }
}
