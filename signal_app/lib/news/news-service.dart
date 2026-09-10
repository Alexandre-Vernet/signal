import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:signal_app/news/news.dart';
import 'dart:typed_data';

class NewsService {
  final String baseUrl = "http://localhost:8080/api";

  Future<List<News>> findAllNews() async {
    final response = await http.get(Uri.parse('$baseUrl/news'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);

      return json.map((item) => News.fromJson(item)).toList();
    }

    throw Exception('Erreur lors du chargement des signals');
  }

  Future<News> findNews(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/news/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      return News.fromJson(json);
    }

    throw Exception('Erreur lors du chargement des signals');
  }

  Future<Uint8List> getPublicationImage(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/news/$id/image/publication-image'));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception('Erreur lors du chargement des signals');
  }

  Future<Uint8List> getSourceIcon(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/news/$id/image/source-icon'));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    throw Exception('Erreur lors du chargement des signals');
  }
}
