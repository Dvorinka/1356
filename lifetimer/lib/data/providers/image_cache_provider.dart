import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/image_cache_service.dart';

final imageCacheServiceProvider = Provider<ImageCacheService>((ref) {
  final service = ImageCacheService();
  ref.onDispose(() => service.dispose());
  return service;
});
