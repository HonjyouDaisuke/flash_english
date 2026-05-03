import 'package:flash_english/domain/repositories/unit_repository.dart';

class GetUnitDescriptionUseCase {
  final UnitRepository repository;

  GetUnitDescriptionUseCase(this.repository);

  Future<String> execute(int categoryId, int unitId) {
    return repository.getUnitDescription(categoryId, unitId);
  }
}
