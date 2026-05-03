import 'package:flash_english/domain/entities/unit.dart';

class UnitMapper {
  static Map<String, dynamic> toMap(Unit q) {
    return {
      'unit_id': q.unitId,
      'category_no': q.categoryNo,
      'unit_no': q.unitNo,
      'unit_name': q.unitName,
      'unit_description': q.unitDescription,
    };
  }

  static Unit fromMap(Map<String, dynamic> map) {
    return Unit(
      unitId: map['unit_id'],
      categoryNo: map['category_no'],
      unitNo: map['unit_no'],
      unitName: map['unit_name'],
      unitDescription: map['unit_description'],
    );
  }
}
