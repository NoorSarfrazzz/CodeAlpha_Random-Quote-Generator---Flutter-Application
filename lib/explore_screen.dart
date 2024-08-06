import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'favourite_screen.dart';
import 'modal.dart';
import 'repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuoteRepository repository = QuoteRepository();
  late Future<List<QuoteModel>> futureQuotes;
  String category = 'age';
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> categories = [
    'age', 'alone', 'amazing', 'anger', 'architecture', 'art', 'attitude',
    'beauty', 'best', 'birthday', 'business', 'car', 'change', 'communication',
    'computers', 'cool', 'courage', 'dad', 'dating', 'death', 'design', 'dreams',
    'education', 'environmental', 'equality', 'experience', 'failure', 'faith',
    'family', 'famous', 'fear', 'fitness', 'food', 'forgiveness', 'freedom',
    'friendship', 'funny', 'future', 'god', 'good', 'government', 'graduation',
    'great', 'happiness', 'health', 'history', 'home', 'hope', 'humor',
    'imagination', 'inspirational', 'intelligence', 'jealousy', 'knowledge',
    'leadership', 'learning', 'legal', 'life', 'love', 'marriage', 'medical',
    'men', 'mom', 'money', 'morning', 'movies', 'success'
  ];

  int pageNumber = 1;
  bool isLoadingMore = false;
  List<QuoteModel> quotes = [];

  @override
  void initState() {
    super.initState();
    loadQuotes();
  }

  Future<void> loadQuotes() async {
    setState(() {
      isLoadingMore = true;
    });

    try {
      List<QuoteModel> newQuotes = await repository.getQuotesByCategory(category: category);
      setState(() {
        if (pageNumber == 1) {
          quotes = newQuotes; // Replace quotes on initial load or category change
        } else {
          quotes.addAll(newQuotes); // Append quotes on subsequent loads
        }
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void searchQuotesByCategory({required String query}) {
    setState(() {
      category = query;
      quotes = [];
      pageNumber = 1;
      loadQuotes();
    });
  }

  Future<void> loadMoreQuotes() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      pageNumber++;
      List<QuoteModel> moreQuotes = await repository.getQuotesByCategory(category: category);
      setState(() {
        quotes.addAll(moreQuotes);
        isLoadingMore = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<FavoriteProvider>(context);

    void _copy(String text) {
      final value = ClipboardData(text: text);
      Clipboard.setData(value);
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

    return Scaffold(
      backgroundColor: const Color(0xFF242E49),
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                cursorColor: Colors.white,
                controller: _controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 25),
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: IconButton(
                      onPressed: () {
                        searchQuotesByCategory(query: _controller.text);
                      },
                      icon: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                ],
                onSubmitted: (value) {
                  searchQuotesByCategory(query: value);
                },
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 40,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      searchQuotesByCategory(query: categories[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: categories[index] == category ? Colors.yellow.shade500 : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Center(
                            child: Text(
                              categories[index].toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: MasonryGridView.count(
                controller: _scrollController,
                itemCount: quotes.length,
                shrinkWrap: true,
                mainAxisSpacing: 1,
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(0xFF141A30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(08),
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
                                icon: const Icon(FontAwesomeIcons.copy, color: Colors.white, size: 20,),
                                onPressed: () {
                                  _copy(quotes[index].quote);
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
            const SizedBox(height: 20),
            if (isLoadingMore)
              const CircularProgressIndicator(color: Colors.white,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadMoreQuotes,
        backgroundColor: Colors.yellow,
        child: const Icon(FontAwesomeIcons.syncAlt, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
