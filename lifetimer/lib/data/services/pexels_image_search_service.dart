import 'dart:convert';
import 'package:http/http.dart' as http;

class PexelsImage {
  final int id;
  final String url;
  final String fullUrl;
  final String? photographer;
  final String? photographerUrl;
  final int? width;
  final int? height;
  final String? alt;

  PexelsImage({
    required this.id,
    required this.url,
    required this.fullUrl,
    this.photographer,
    this.photographerUrl,
    this.width,
    this.height,
    this.alt,
  });

  factory PexelsImage.fromJson(Map<String, dynamic> json) {
    final src = json['src'] as Map<String, dynamic>;
    return PexelsImage(
      id: json['id'] as int,
      url: src['large'] as String? ?? src['medium'] as String,
      fullUrl: src['original'] as String? ?? src['large'] as String,
      photographer: json['photographer'] as String?,
      photographerUrl: json['photographer_url'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      alt: json['alt'] as String?,
    );
  }
}

class PexelsImageSearchService {
  final String _apiKey;
  final http.Client _client;

  PexelsImageSearchService({
    required String apiKey,
    http.Client? client,
  })  : _apiKey = apiKey,
        _client = client ?? http.Client();

  Future<List<PexelsImage>> searchImages({
    required String query,
    int perPage = 10,
    String orientation = 'landscape',
  }) async {
    try {
      final uri = Uri.https('api.pexels.com', '/v1/search', {
        'query': query,
        'per_page': perPage.toString(),
        'orientation': orientation,
      });

      final response = await _client.get(
        uri,
        headers: {
          'Authorization': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final photos = data['photos'] as List;
        return photos
            .map((json) => PexelsImage.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to search images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching images: $e');
    }
  }

  Future<PexelsImage?> getRandomImage({
    String? query,
    String orientation = 'landscape',
  }) async {
    try {
      final params = <String, String>{
        'per_page': '1',
        'orientation': orientation,
      };
      if (query != null) {
        params['query'] = query;
      }

      final uri = Uri.https('api.pexels.com', '/v1/curated', params);

      final response = await _client.get(
        uri,
        headers: {
          'Authorization': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final photos = data['photos'] as List;
        if (photos.isNotEmpty) {
          return PexelsImage.fromJson(photos[0] as Map<String, dynamic>);
        }
        return null;
      } else {
        throw Exception('Failed to get random image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting random image: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
