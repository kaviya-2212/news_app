import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:news_app/pages/news_detail.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<dynamic> articles = [];
  List<String> bookmarkedTitles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedTitles = prefs.getStringList('bookmarks') ?? [];
    });
  }

  Future<void> toggleBookmark(Map<String, dynamic> article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList('bookmarks') ?? [];

    final jsonString = json.encode(article);
    final isAlreadyBookmarked = saved.contains(jsonString);

    setState(() {
      if (isAlreadyBookmarked) {
        saved.remove(jsonString);
      } else {
        saved.add(jsonString);
      }
      bookmarkedTitles = List.from(saved); // update the UI list
      prefs.setStringList('bookmarks', saved);
    });
  }

  Future<void> fetchNews() async {
    setState(() => isLoading = true);
    final response = await http.get(
      Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=aea474c6ad9c4a799cdc15be3ede7cd1',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load news')));
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('d MMMM, yyyy').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Top Headlines')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchNews,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    final title = article['title'] ?? '';
                    final isBookmarked = bookmarkedTitles.contains(
                      json.encode(article),
                    );

                    return InkWell(
                      onTap: () {
                        Get.to(() => NewsDetailPage(article: article));
                      },
                      child: Card(
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
                                title,
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
                                formatDate(article['publishedAt']),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                    width: w / 1.2,
                                    child: Text(
                                      article['description'] ??
                                          'No description available.',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => toggleBookmark(article),
                                    child: Icon(
                                      isBookmarked
                                          ? Icons.check_circle
                                          : Icons.bookmark_add,
                                      size: 22,
                                      color:
                                          isBookmarked
                                              ? Colors.green
                                              : Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
