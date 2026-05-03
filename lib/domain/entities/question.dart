class Question {
  final int questionId;
  final int categoryNo;
  final int unitNo;
  final int number;
  final String japanese;
  final String english;
  final String japaneseAudio;
  final String englishAudio;

  Question({
    required this.questionId,
    required this.categoryNo,
    required this.unitNo,
    required this.number,
    required this.japanese,
    required this.english,
    required this.japaneseAudio,
    required this.englishAudio,
  });
}
