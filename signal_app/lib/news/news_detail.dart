import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signal_app/news/news-service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import '../utils/date_utils.dart';
import 'news.dart';

class NewsDetail extends StatefulWidget {
  final int newsId;

  const NewsDetail({super.key, required this.newsId});

  @override
  State createState() => NewsDetailState();
}

class NewsDetailState extends State<NewsDetail> {
  final newsService = NewsService();
  late News news;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      final result = await newsService.findNews(widget.newsId);

      setState(() {
        news = result;
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
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Article',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPublicationImage(),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSourceIcon(),

                  const SizedBox(height: 18),

                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (news.description != null)
                    Text(
                      news.description!,
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.55,
                        color: Colors.grey.shade700,
                      ),
                    ),

                  const SizedBox(height: 28),

                  _buildTags(),

                  const SizedBox(height: 32),

                  _buildOriginalArticleButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicationImage() {
    if (news.imageUrl == null || news.imageUrl!.isEmpty) {
      return Container(
        width: double.infinity,
        height: 280,
        color: Colors.grey.shade100,
        child: Icon(
          Icons.image_outlined,
          size: 50,
          color: Colors.grey.shade400,
        ),
      );
    }

    return FutureBuilder<Uint8List>(
      future: newsService.getPublicationImage(news.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            width: double.infinity,
            height: 280,
            fit: BoxFit.cover,
          );
        }

        if (snapshot.hasError) {
          return Image.network(
            news.imageUrl!,
            width: double.infinity,
            height: 280,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 280,
                color: Colors.grey.shade100,
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 50,
                  color: Colors.grey.shade400,
                ),
              );
            },
          );
        }

        return Container(
          width: double.infinity,
          height: 280,
          color: Colors.grey.shade100,
        );
      },
    );
  }

  Widget _buildSourceIcon() {
    return Row(
      children: [
        if (news.sourceIcon.isNotEmpty)
          FutureBuilder<Uint8List>(
            future: newsService.getSourceIcon(news.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ClipOval(
                  child: Image.memory(
                    snapshot.data!,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                );
              }
              if (snapshot.hasError) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    news.imageUrl!,
                    width: 115,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                );
              }

              return const SizedBox(width: 32, height: 32);
            },
          ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.sourceName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),

            const SizedBox(height: 2),

            Text(
              CustomDateUtils.formatDate(news.publicationDate),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTags() {
    final tags = [...news.categories, ...news.keywords];

    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.take(8).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOriginalArticleButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () async {
          final uri = Uri.parse(news.link);

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        icon: const Icon(Icons.open_in_new_rounded),
        label: const Text('Lire l’article original'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
