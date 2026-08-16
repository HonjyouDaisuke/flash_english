import 'package:flash_english/application/usecases/get_question_from_id_usecase.dart';
import 'package:flash_english/presentation/providers/question/questions_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getQuestionFromIdUseCaseProvider =
    Provider<GetQuestionFromIdUseCase>((ref) {
  return GetQuestionFromIdUseCase(
    ref.watch(
      questionRepositoryProvider,
    ),
  );
});
