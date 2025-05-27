import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookmarkedNewsPage extends StatefulWidget {
  const BookmarkedNewsPage({super.key});

  @override
  State<BookmarkedNewsPage> createState() => _BookmarkedNewsPageState();
}

class _BookmarkedNewsPageState extends State<BookmarkedNewsPage> {
  List<dynamic> bookmarkedArticles = [];

  @override
  void initState() {
    super.initState();
    loadBookmarkedArticles();
  }

  Future<void> loadBookmarkedArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedArticles = prefs.getStringList('bookmarks') ?? [];

    List<dynamic> validArticles = [];

    for (var item in savedArticles) {
      try {
        final decoded = json.decode(item);
        if (decoded is Map<String, dynamic>) {
          validArticles.add(decoded);
        }
      } catch (e) {
        // Skips invalid JSON
        debugPrint('Invalid bookmark: $item');
      }
    }

    setState(() {
      bookmarkedArticles = validArticles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked News')),
      body:
          bookmarkedArticles.isEmpty
              ? const Center(child: Text('No bookmarked articles yet.'))
              : ListView.builder(
                itemCount: bookmarkedArticles.length,
                itemBuilder: (context, index) {
                  final article = bookmarkedArticles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article['urlToImage'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                article['urlToImage'],
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            article['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Source: ${article['source']['name'] ?? 'Unknown'}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            article['publishedAt']?.substring(0, 10) ?? '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article['description'] ??
                                'No description available.',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
