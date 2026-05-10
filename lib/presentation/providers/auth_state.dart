import 'package:flash_english/domain/entities/auth_status.dart';

class AuthState {
  final String? token;
  final String? userId;
  final AuthStatus status;
  final bool isOffline;
  final bool isExpired;

  const AuthState({
    this.token,
    this.userId,
    this.status = AuthStatus.unknown,
    this.isOffline = false,
    this.isExpired = true,
  });

  bool get isLoggedIn =>
      status == AuthStatus.onlineAuthenticated ||
      status == AuthStatus.offlineAuthenticated;

  AuthState copyWith({
    String? token,
    String? userId,
    AuthStatus? status,
    bool? isOffline,
    bool? isExpired,
  }) {
    return AuthState(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      isOffline: isOffline ?? this.isOffline,
      isExpired: isExpired ?? this.isExpired,
    );
  }
}
