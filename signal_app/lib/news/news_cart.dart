import 'package:flutter/material.dart';
import 'package:signal_app/news/news-service.dart';
import 'package:signal_app/utils/date_utils.dart';
import 'dart:typed_data';
import 'news.dart';

class NewsCard extends StatefulWidget {
  final News news;
  final VoidCallback? onTap;

  const NewsCard({super.key, required this.news, this.onTap});

  @override
  State createState() => NewsCardState();
}

class NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSourceIcon(),

                    const SizedBox(height: 8),

                    Text(
                      widget.news.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 7),

                    if (widget.news.description != null)
                      Text(
                        widget.news.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.35,
                          color: Colors.grey.shade600,
                        ),
                      ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        if (widget.news.categories.isNotEmpty)
                          _buildTag(widget.news.categories.first),

                        const Spacer(),

                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final newsService = NewsService();

    if (widget.news.imageUrl == null || widget.news.imageUrl!.isEmpty) {
      return Container(
        width: 115,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          Icons.article_outlined,
          color: Colors.grey.shade400,
          size: 32,
        ),
      );
    }

    return _buildPublicationImage();
  }

  Widget _buildPublicationImage() {
    final newsService = NewsService();

    return FutureBuilder<Uint8List>(
      future: newsService.getPublicationImage(widget.news.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.memory(
              snapshot.data!,
              width: 115,
              height: 130,
              fit: BoxFit.cover,
            ),
          );
        }
        if (snapshot.hasError) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              widget.news.imageUrl!,
              width: 115,
              height: 130,
              fit: BoxFit.cover,
            ),
          );
        }

        return Container(
          width: 115,
          height: 130,
          color: Colors.grey.shade200,
          child: snapshot.hasError
              ? Icon(Icons.broken_image_outlined, color: Colors.grey.shade400)
              : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildSourceIcon() {
    final newsService = NewsService();

    return Row(
      children: [
        if (widget.news.sourceIcon.isNotEmpty)
          FutureBuilder<Uint8List>(
            future: newsService.getSourceIcon(widget.news.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ClipOval(
                  child: Image.memory(
                    snapshot.data!,
                    width: 22,
                    height: 22,
                    fit: BoxFit.cover,
                  ),
                );
              }

              return const SizedBox(width: 22, height: 22);
            },
          ),

        const SizedBox(width: 7),

        Expanded(
          child: Text(
            widget.news.sourceName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),

        Text(
          CustomDateUtils.formatDate(widget.news.publicationDate),
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    );
  }
}
