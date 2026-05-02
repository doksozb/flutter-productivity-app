class QuoteModel {
  final String text;
  final String author;

  const QuoteModel({required this.text, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      text: (json['text'] as String? ?? '').trim(),
      author: (json['author'] as String? ?? 'Unknown').trim(),
    );
  }
}
