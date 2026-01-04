import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../bootstrap/env.dart';
import '../services/pexels_image_search_service.dart';

final pexelsImageSearchServiceProvider = Provider<PexelsImageSearchService>((ref) {
  return PexelsImageSearchService(
    apiKey: Env.pexelsApiKey,
    client: http.Client(),
  );
});
