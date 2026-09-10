import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signal_app/news/news.dart';
import 'package:signal_app/news/news_service.dart';

import 'news/news_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  List<News> newsList = [];
  bool isLoading = true;

  final newsService = NewsService();

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      final result = await newsService.findAllNews();

      setState(() {
        newsList = result;
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Signal',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadNews,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];

                  return NewsCard(
                    news: news,
                    onTap: () {
                      context.push('/news', extra: news.id);
                    },
                  );
                },
              ),
            ),
    );
  }
}
