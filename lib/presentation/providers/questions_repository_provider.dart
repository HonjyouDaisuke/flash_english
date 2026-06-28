import 'package:flash_english/domain/repositories/question_repository.dart';
import 'package:flash_english/infrastructure/repositories/question_repository_impl.dart';
import 'package:flash_english/presentation/providers/api_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepositoryImpl(ref.read(apiClientProvider));
});
