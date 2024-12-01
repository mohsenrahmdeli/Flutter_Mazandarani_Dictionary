class WordModel {
  final String word;
  final String read;
  final String mean;

  WordModel({required this.word, required this.read, required this.mean});

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      word: map['word'],
      read: map['read'],
      mean: map['mean'],
    );
  }
}
