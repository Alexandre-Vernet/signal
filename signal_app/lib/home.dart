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
  bool isLoadingNews = true;

  bool isLoadingCategories = true;
  List<String> categories = [];
  Set<String> selectedCategories = {};

  final newsService = NewsService();

  @override
  void initState() {
    super.initState();
    loadNews();
    loadCategories();
  }

  Future<void> loadNews() async {
    try {
      final result = selectedCategories.isEmpty
          ? await newsService.findAllNews()
          : await newsService.getNewsByCategories(selectedCategories.toList());

      setState(() {
        newsList = result;
        isLoadingNews = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoadingNews = false;
      });
    }
  }

  Future<void> loadCategories() async {
    try {
      final result = await newsService.getCategories();

      setState(() {
        categories = result;
        isLoadingCategories = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoadingCategories = false;
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

      body: isLoadingNews
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadNews,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: newsList.length + 2,
                itemBuilder: (context, index) {
                  // Category filter
                  if (index == 0) {
                    return _buildCategoryFilter();
                  }

                  // Spacer
                  if (index == 1) {
                    return const SizedBox(height: 16);
                  }

                  final news = newsList[index - 2];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: NewsList(
                      key: ValueKey(news.id),
                      news: news,
                      onTap: () {
                        context.push('/news', extra: news.id);
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _selectCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    setState(() {
      selectedCategories = selectedCategories;
    });

    loadNews();
  }

  Widget _buildCategoryFilter() {
    if (isLoadingCategories) {
      return const SizedBox(
        height: 42,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = index == 0 ? null : categories[index - 1];

          final isSelected = selectedCategories.contains(category);

          return GestureDetector(
            onTap: () => category != null
                ? _selectCategory(category)
                : _clearCategories(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                category ?? 'Toutes',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _clearCategories() {
    selectedCategories = {};
    loadNews();
  }
}
