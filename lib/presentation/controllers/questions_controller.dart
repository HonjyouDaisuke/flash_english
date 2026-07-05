import 'dart:math';

import 'package:flutter/material.dart';

class QuestionsController {
  List<int> questionsOrder = [];
  bool isRandom;
  int currentPos = 0;
  bool isStarted = false;
  QuestionsController(this.isRandom);

  List<int> generateNumbers() {
    final numbers = List.generate(10, (index) => index + 1);

    if (isRandom) numbers.shuffle(Random());

    return numbers;
  }

  void _printQuestionInfo() {
    // debugPrint("quesionsNos--------------------");
    for (int i = 0; i < 10; i++) {
      // debugPrint("$i : ${questionsOrder[i]}");
    }
    debugPrint("currentPos = $currentPos : id = ${questionsOrder[currentPos]}");
    // debugPrint("currentId = ${questionsOrder[currentPos]}");
  }

  int _nextPos(int index) {
    for (int i = 0; i < questionsOrder.length; i++) {
      if (index >= questionsOrder.length) {
        index = 0;
      }

      if (questionsOrder[index] > 0) {
        return index;
      }

      index++;
    }

    return -1; // 未回答が存在しない
  }

  int _prevPos(int index) {
    index--;
    if (index < 0) return 0;
    return index;
  }

  void _setQuestionsOrder(int index) {
    if (questionsOrder[index] > 0) questionsOrder[index] *= -1;
  }

  int start() {
    debugPrint("start---");
    questionsOrder = generateNumbers();
    isStarted = true;
    currentPos = 0;
    _printQuestionInfo();
    return questionsOrder[0];
  }

  int? next() {
    if (!isStarted) return null;

    debugPrint("next---");
    final nextPos = _nextPos(currentPos + 1);
    if (nextPos == -1) {
      debugPrint("全問回答済み");
      return null; // 全問回答済み
    }

    currentPos = nextPos;
    _printQuestionInfo();
    return questionsOrder[currentPos];
  }

  int? markAnswered() {
    debugPrint("answer---");
    debugPrint("     ---set! $currentPos");
    _setQuestionsOrder(currentPos);
    return next();
  }

  int? prev() {
    if (isStarted == false) return null;
    debugPrint("back---");
    currentPos = _prevPos(currentPos);
    _printQuestionInfo();
    return questionsOrder[currentPos];
  }
}
