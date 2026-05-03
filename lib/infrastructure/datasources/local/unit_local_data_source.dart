import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flash_english/domain/entities/unit.dart';

class UnitLocalDataSource {
  Future<List<Unit>> loadUnits() async {
    final jsonString = await rootBundle.loadString('assets/unit_tbl.json');
    final List data = jsonDecode(jsonString);

    return data
        .map((e) => Unit(
              unitId: e['unit_id'] as int,
              categoryNo: e['category_no'] as int,
              unitNo: e['unit_no'] as int,
              unitName: e['unit_name'] as String,
              unitDescription: e['unit_description'] as String,
            ))
        .toList();
  }
}
