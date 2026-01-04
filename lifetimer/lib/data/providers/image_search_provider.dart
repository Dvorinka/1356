import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../bootstrap/env.dart';
import '../services/image_search_service.dart';

final imageSearchServiceProvider = Provider<ImageSearchService>((ref) {
  return ImageSearchService(
    accessKey: Env.unsplashAccessKey,
    client: http.Client(),
  );
});
