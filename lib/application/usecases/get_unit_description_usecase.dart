import 'package:flash_english/domain/repositories/unit_repository.dart';

class GetUnitDescriptionUseCase {
  final UnitRepository repository;

  GetUnitDescriptionUseCase(this.repository);

  Future<String> execute(int categoryNo, int unitNo) {
    return repository.getUnitDescription(categoryNo, unitNo);
  }
}
