import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flash_english/domain/entities/question.dart';

class QuestionLocalDataSource {
  Future<List<Question>> loadQuestions() async {
    final jsonString =
        await rootBundle.loadString('assets/flash_english_questions.json');
    final List data = jsonDecode(jsonString);

    return data
        .map((e) => Question(
              id: e['id'],
              category: e['category'],
              japanese: e['japanese'],
              english: e['english'],
              japaneseAudio: e['japanese_audio'],
              englishAudio: e['english_audio'],
            ))
        .toList();
  }
}
