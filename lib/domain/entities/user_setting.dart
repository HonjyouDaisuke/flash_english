class UserSetting {
  final String settingKey;
  final String value;
  final DateTime updatedAt;

  const UserSetting({
    required this.settingKey,
    required this.value,
    required this.updatedAt,
  });

  factory UserSetting.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserSetting(
      settingKey: json['setting_key'] as String,
      value: json['value'] as String,
      updatedAt: DateTime.parse(
        json['updated_at'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setting_key': settingKey,
      'value': value,
      'updated_at': updatedAt,
    };
  }
}
