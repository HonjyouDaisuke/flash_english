import 'package:flash_english/domain/entities/unit.dart';

abstract class UnitRepository {
  Future<List<Unit>> getByCategory(int categoryId);
  Future<String> getUnitDescription(int categoryId, int unitId);
}
