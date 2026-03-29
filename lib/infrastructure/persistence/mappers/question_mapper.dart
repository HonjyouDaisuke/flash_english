import 'package:flash_english/domain/entities/question.dart';

class QuestionMapper {
  static Map<String, dynamic> toMap(Question q) {
    return {
      'id': q.id,
      'category': q.category,
      'japanese': q.japanese,
      'english': q.english,
      'japaneseAudio': q.japaneseAudio,
      'englishAudio': q.englishAudio,
    };
  }

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      category: map['category'],
      japanese: map['japanese'],
      english: map['english'],
      japaneseAudio: map['japaneseAudio'],
      englishAudio: map['englishAudio'],
    );
  }
}
