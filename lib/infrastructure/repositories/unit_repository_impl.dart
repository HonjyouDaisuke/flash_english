import 'package:flash_english/domain/entities/unit.dart';
import 'package:flash_english/domain/repositories/unit_repository.dart';
import 'package:flash_english/infrastructure/persistence/app_database.dart';
import 'package:flash_english/infrastructure/persistence/mappers/unit_mapper.dart';

class UnitRepositoryImpl implements UnitRepository {
  @override
  Future<List<Unit>> getByCategory(
    int categoryNo,
  ) async {
    final db =  AppDatabase.instance.database;

    final result = await db.query(
      'units',
      where: 'category_no = ?',
      whereArgs: [categoryNo],
      orderBy: 'unit_no',
    );

    return result
        .map(
          (map) => UnitMapper.fromMap(map),
        )
        .toList();
  }

  @override
  Future<String> getUnitDescription(int categoryNo, int unitNo) async {
    final db =  AppDatabase.instance.database;

    final result = await db.query(
      'units',
      where: 'category_no = ? AND unit_no = ?',
      whereArgs: [categoryNo, unitNo],
    );
    final units = result.map((map) => UnitMapper.fromMap(map)).toList();
    if (units.isEmpty) {
      throw StateError(
        'Unit not found: categoryNo=$categoryNo, unitNo=$unitNo',
      );
    }
    return "${units[0].unitName} : ${units[0].unitDescription}";
  }
}
