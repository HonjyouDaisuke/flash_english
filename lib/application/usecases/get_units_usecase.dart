import 'package:flash_english/domain/entities/unit.dart';
import 'package:flash_english/domain/repositories/unit_repository.dart';

class GetUnitsUseCase {
  final UnitRepository repository;

  GetUnitsUseCase(this.repository);

  Future<List<Unit>> call(
    int categoryId,
  ) {
    return repository.getByCategory(
      categoryId,
    );
  }
}
