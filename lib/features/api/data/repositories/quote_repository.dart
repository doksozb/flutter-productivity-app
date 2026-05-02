import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuoteRepository {
  static const _apiUrl = 'https://type.fit/api/quotes';

  Future<List<QuoteModel>> fetchQuotes() async {
    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        return data
            .map((q) => QuoteModel.fromJson(q as Map<String, dynamic>))
            .where((q) => q.text.isNotEmpty)
            .take(60)
            .toList();
      }
      throw Exception('Server returned ${response.statusCode}');
    } catch (_) {
      return _fallbackQuotes;
    }
  }

  static final _fallbackQuotes = [
    const QuoteModel(
      text: 'The way to get started is to quit talking and begin doing.',
      author: 'Walt Disney',
    ),
    const QuoteModel(
      text: 'Life is what happens when you\'re busy making other plans.',
      author: 'John Lennon',
    ),
    const QuoteModel(
      text: 'The future belongs to those who believe in the beauty of their dreams.',
      author: 'Eleanor Roosevelt',
    ),
    const QuoteModel(
      text: 'It is during our darkest moments that we must focus to see the light.',
      author: 'Aristotle',
    ),
    const QuoteModel(
      text: 'Whoever is happy will make others happy too.',
      author: 'Anne Frank',
    ),
    const QuoteModel(
      text: 'Do not go where the path may lead, go instead where there is no path and leave a trail.',
      author: 'Ralph Waldo Emerson',
    ),
    const QuoteModel(
      text: 'You will face many defeats in life, but never let yourself be defeated.',
      author: 'Maya Angelou',
    ),
    const QuoteModel(
      text: 'The greatest glory in living lies not in never falling, but in rising every time we fall.',
      author: 'Nelson Mandela',
    ),
    const QuoteModel(
      text: 'In the end, it\'s not the years in your life that count. It\'s the life in your years.',
      author: 'Abraham Lincoln',
    ),
    const QuoteModel(
      text: 'Never let the fear of striking out keep you from playing the game.',
      author: 'Babe Ruth',
    ),
  ];
}
