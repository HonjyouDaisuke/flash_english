enum AuthStatus {
  unknown, // 起動直後
  nonToken, // トークンなし
  onlineAuthenticated, // online認証済み
  onlineAuthExpired, // onlineトークン有効期限切れ
  offlineAuthenticated, // offline認証済み
  offlineAuthExpired, // offlineトークン有効期限切れ
}
