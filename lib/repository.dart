import 'dart:convert';
import 'package:http/http.dart' as http;
import 'modal.dart';

class QuoteRepository {
  final String apiKey = 'uLr363iq6Bmg3sPk23fitA==loC2WqvTaUfMCHio';
  final String baseURL = 'https://api.api-ninjas.com/v1/quotes';

  Future<List<QuoteModel>> getQuotesByCategory({required String category}) async {
    final url = '$baseURL?category=$category';

    List<QuoteModel> quoteList = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        quoteList = jsonData.map((json) => QuoteModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching quotes: $e');
    }

    return quoteList;
  }

  Future<List<QuoteModel>> searchQuotesByCategory({required String category}) async {
    final url = '$baseURL?category=$category';

    List<QuoteModel> quoteList = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        quoteList = jsonData.map((json) => QuoteModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error searching quotes: $e');
    }

    return quoteList;
  }
}
