import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flash_english/domain/entities/question.dart';

class QuestionLocalDataSource {
  Future<List<Question>> loadQuestions() async {
    final jsonString = await rootBundle.loadString('assets/question_tbl.json');
    final List data = jsonDecode(jsonString);

    return data
        .map((e) => Question(
              questionId: e['question_id'],
              categoryNo: e['category_no'],
              unitNo: e['unit_no'],
              number: e['number'],
              japanese: e['japanese'],
              english: e['english'],
              japaneseAudio: e['japanese_audio'],
              englishAudio: e['english_audio'],
            ))
        .toList();
  }
}
