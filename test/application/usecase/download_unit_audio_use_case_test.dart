import 'package:flash_english/application/usecases/download_unit_audio_usecase.dart';
import 'package:flash_english/domain/repositories/audio_download_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioDownloadRepository extends Mock
    implements AudioDownloadRepository {}

void main() {
  late MockAudioDownloadRepository repository;
  late DownloadUnitAudioUseCase useCase;

  setUp(() {
    repository = MockAudioDownloadRepository();
    useCase = DownloadUnitAudioUseCase(repository);
  });

  group('execute', () {
    test(
      '音声ファイルが存在する場合は download を呼ばない',
      () async {
        // Arrange
        when(
          () => repository.exists(1, 2),
        ).thenAnswer((_) async => true);

        // Act
        await useCase.execute(1, 2);

        // Assert
        verify(
          () => repository.exists(1, 2),
        ).called(1);

        verifyNever(
          () => repository.download(any(), any()),
        );
      },
    );

    test(
      '音声ファイルが存在しない場合は download を呼ぶ',
      () async {
        // Arrange
        when(
          () => repository.exists(1, 2),
        ).thenAnswer((_) async => false);

        when(
          () => repository.download(1, 2),
        ).thenAnswer((_) async {});

        // Act
        await useCase.execute(1, 2);

        // Assert
        verify(
          () => repository.exists(1, 2),
        ).called(1);

        verify(
          () => repository.download(1, 2),
        ).called(1);
      },
    );
  });
}
