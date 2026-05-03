import 'package:flash_english/domain/entities/question.dart';

class QuestionMapper {
  static Map<String, dynamic> toMap(Question q) {
    return {
      'question_id': q.questionId,
      'category_no': q.categoryNo,
      'unit_no': q.unitNo,
      'number': q.number,
      'japanese': q.japanese,
      'english': q.english,
      'japanese_audio': q.japaneseAudio,
      'english_audio': q.englishAudio,
    };
  }

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['question_id'],
      categoryNo: map['category_no'] as int,
      unitNo: map['unit_no'] as int,
      number: map['number'] as int,
      japanese: map['japanese'],
      english: map['english'],
      japaneseAudio: map['japanese_audio'] ?? map['japaneseAudio'],
      englishAudio: map['english_audio'] ?? map['englishAudio'],
    );
  }
}
