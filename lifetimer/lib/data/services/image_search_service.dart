import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashImage {
  final String id;
  final String url;
  final String fullUrl;
  final String? description;
  final String? photographer;
  final String? photographerUrl;

  UnsplashImage({
    required this.id,
    required this.url,
    required this.fullUrl,
    this.description,
    this.photographer,
    this.photographerUrl,
  });

  factory UnsplashImage.fromJson(Map<String, dynamic> json) {
    final urls = json['urls'] as Map<String, dynamic>;
    final user = json['user'] as Map<String, dynamic>?;
    return UnsplashImage(
      id: json['id'] as String,
      url: urls['regular'] as String? ?? urls['small'] as String,
      fullUrl: urls['full'] as String? ?? urls['regular'] as String,
      description: json['description'] as String?,
      photographer: user?['name'] as String?,
      photographerUrl: user?['links']?['html'] as String?,
    );
  }
}

class ImageSearchService {
  final String _accessKey;
  final http.Client _client;

  ImageSearchService({
    required String accessKey,
    http.Client? client,
  })  : _accessKey = accessKey,
        _client = client ?? http.Client();

  Future<List<UnsplashImage>> searchImages({
    required String query,
    int perPage = 10,
    String orientation = 'landscape',
  }) async {
    try {
      final uri = Uri.https('api.unsplash.com', '/search/photos', {
        'query': query,
        'per_page': perPage.toString(),
        'orientation': orientation,
      });

      final response = await _client.get(
        uri,
        headers: {
          'Authorization': 'Client-ID $_accessKey',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List;
        return results
            .map((json) => UnsplashImage.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to search images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching images: $e');
    }
  }

  Future<UnsplashImage?> getRandomImage({
    String? query,
    String orientation = 'landscape',
  }) async {
    try {
      final params = <String, String>{
        'orientation': orientation,
      };
      if (query != null) {
        params['query'] = query;
      }

      final uri = Uri.https('api.unsplash.com', '/photos/random', params);

      final response = await _client.get(
        uri,
        headers: {
          'Authorization': 'Client-ID $_accessKey',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return UnsplashImage.fromJson(json);
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
