import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modal.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final quotes = provider.favoriteQuotes;

    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Color(0xFF242E49),
      body: quotes.isEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white54,
              ),
              child: const Icon(Icons.favorite, color: Color(0xFF242E49), size: 100),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'You don\'t have any favorites yet.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              color: Colors.yellow.shade600,
            ),
          ),
          const Text(
            'Click some hearts.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        child: MasonryGridView.count(
          controller: _scrollController,
          itemCount: quotes.length,
          shrinkWrap: true,
          mainAxisSpacing: 8,
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          itemBuilder: (context, index) {
            return Card(
              color: Color(0xFF141A30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quotes[index].quote,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '- ${quotes[index].author}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.copy, color: Colors.white, size: 20),
                          onPressed: () {
                            _copy(context, quotes[index].quote);
                          },
                        ),
                        IconButton(
                          icon: provider.isExist(quotes[index])
                              ? const Icon(Icons.favorite, color: Colors.yellow)
                              : const Icon(Icons.favorite_outline, color: Colors.yellow),
                          onPressed: () {
                            provider.toggleFavorites(quotes[index]);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    final snackBar = SnackBar(
      content: Text(
        'Copied to clipboard!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class FavoriteProvider extends ChangeNotifier {
  final List<QuoteModel> _favoriteQuotes = [];

  FavoriteProvider() {
    _loadFavorites();
  }

  List<QuoteModel> get favoriteQuotes => _favoriteQuotes;

  void toggleFavorites(QuoteModel quote) {
    if (_favoriteQuotes.contains(quote)) {
      _favoriteQuotes.remove(quote);
    } else {
      _favoriteQuotes.add(quote);
    }
    _saveFavorites();
    notifyListeners();
  }

  bool isExist(QuoteModel quote) {
    return _favoriteQuotes.contains(quote);
  }

  void clearFavorites() {
    _favoriteQuotes.clear();
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> quoteList = _favoriteQuotes.map((quote) => jsonEncode(quote.toJson())).toList();
    print('Saving favorites: $quoteList');
    await prefs.setStringList('favorites', quoteList);
  }

  Future<void> _loadFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? quoteList = prefs.getStringList('favorites');
    if (quoteList != null) {
      _favoriteQuotes.clear();
      _favoriteQuotes.addAll(quoteList.map((quote) => QuoteModel.fromJson(jsonDecode(quote))).toList());
      print('Loaded favorites: $quoteList');
      notifyListeners();
    } else {
      print('No favorites found');
    }
  }
}
