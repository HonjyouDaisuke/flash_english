import 'package:flash_english/application/usecases/get_user_settings_usecase.dart';
import 'package:flash_english/presentation/providers/user_setting/user_settings_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserSettingsUsecaseProvider = Provider<GetUserSettingsUsecase>((ref) {
  final repo = ref.watch(userSettingsRepositoryProvider);
  return GetUserSettingsUsecase(repo);
});
