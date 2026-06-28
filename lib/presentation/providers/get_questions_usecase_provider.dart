import 'package:flash_english/application/usecases/get_questions_usecase.dart';
import 'package:flash_english/presentation/providers/questions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getQuestionsUseCaseProvider = Provider<GetQuestionsUseCase>((ref) {
  return GetQuestionsUseCase(
    ref.watch(
      questionRepositoryProvider,
    ),
  );
});
