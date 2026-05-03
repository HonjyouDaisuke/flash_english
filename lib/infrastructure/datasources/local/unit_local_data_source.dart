import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flash_english/domain/entities/unit.dart';

class UnitLocalDataSource {
  Future<List<Unit>> loadUnits() async {
    final jsonString = await rootBundle.loadString('assets/unit_tbl.json');
    final List data = jsonDecode(jsonString);

    return data
        .map((e) => Unit(
              unitId: e['unit_id'],
              categoryNo: e['category_no'],
              unitNo: e['unit_no'],
              unitName: e['unit_name'],
              unitDescription: e['unit_description'],
            ))
        .toList();
  }
}
