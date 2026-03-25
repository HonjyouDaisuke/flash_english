import 'package:flash_english/domain/entities/question.dart';
import 'package:flutter/material.dart';

class CheckAnswerUseCase {
  String _normalize(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[.,!?]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  bool execute(Question question, String input) {
    final normalized = _normalize(input);
    debugPrint(
        "正解: ${_normalize(question.english)} 入力：${normalized.toString()}");
    // 仮ロジック
    return normalized.contains(_normalize(question.english));
  }
}
