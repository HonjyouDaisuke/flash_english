import 'package:flash_english/domain/entities/unit.dart';

abstract class UnitRepository {
  Future<List<Unit>> getByCategory(int categoryNo);
  Future<String> getUnitDescription(int categoryNo, int unitNo);
  Future<List<Unit>> getAllApi();
  Future<void> insertAll(List<Unit> units);
}
