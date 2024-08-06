class QuoteModel {
  final String quote;
  final String author;

  QuoteModel({required this.quote, required this.author});

  Map<String, dynamic> toJson() {
    return {
      'quote': quote,
      'author': author,
    };
  }

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      quote: json['quote'],
      author: json['author'],
    );
  }
}
