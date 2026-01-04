// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ImageCacheService {
  static const int _maxCacheSize = 50 * 1024 * 1024; // 50MB
  static const Duration _cacheExpiry = Duration(days: 30);
  static const int _maxConcurrentOperations = 3;
  
  late Directory _cacheDir;
  bool _initialized = false;
  int _activeOperations = 0;

  Future<void> init() async {
    if (_initialized) return;
    
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory(path.join(appDir.path, 'image_cache'));
    
    if (!await _cacheDir.exists()) {
      await _cacheDir.create(recursive: true);
    }
    
    _initialized = true;
    await _cleanupExpiredCache();
  }

  String _generateCacheKey(String url) {
    final bytes = utf8.encode(url);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<File?> getCachedImage(String url) async {
    if (!_initialized) await init();
    
    final cacheKey = _generateCacheKey(url);
    final cachedFile = File(path.join(_cacheDir.path, '$cacheKey.jpg'));
    
    if (!await cachedFile.exists()) {
      return null;
    }
    
    final stat = await cachedFile.stat();
    final age = DateTime.now().difference(stat.modified);
    
    if (age > _cacheExpiry) {
      await cachedFile.delete();
      return null;
    }
    
    return cachedFile;
  }

  Future<File> cacheImage(String url, Uint8List imageData) async {
    if (!_initialized) await init();
    
    // Limit concurrent operations to avoid overwhelming the system
    while (_activeOperations >= _maxConcurrentOperations) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
    
    _activeOperations++;
    
    try {
      final cacheKey = _generateCacheKey(url);
      final cachedFile = File(path.join(_cacheDir.path, '$cacheKey.jpg'));
      
      await cachedFile.writeAsBytes(imageData);
      
      await _enforceCacheSizeLimit();
      
      return cachedFile;
    } finally {
      _activeOperations--;
    }
  }

  Future<void> clearCache() async {
    if (!_initialized) await init();
    
    if (await _cacheDir.exists()) {
      await _cacheDir.delete(recursive: true);
      await _cacheDir.create(recursive: true);
    }
  }

  Future<int> getCacheSize() async {
    if (!_initialized) await init();
    
    int totalSize = 0;
    
    if (await _cacheDir.exists()) {
      await for (final entity in _cacheDir.list()) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    }
    
    return totalSize;
  }

  Future<void> _cleanupExpiredCache() async {
    if (!await _cacheDir.exists()) return;
    
    final now = DateTime.now();
    
    await for (final entity in _cacheDir.list()) {
      if (entity is File) {
        final stat = await entity.stat();
        final age = now.difference(stat.modified);
        
        if (age > _cacheExpiry) {
          await entity.delete();
        }
      }
    }
  }

  Future<void> _enforceCacheSizeLimit() async {
    final currentSize = await getCacheSize();
    
    if (currentSize <= _maxCacheSize) return;
    
    final files = <File>[];
    final fileStats = <File, FileStat>{};
    
    await for (final entity in _cacheDir.list()) {
      if (entity is File) {
        files.add(entity);
        fileStats[entity] = await entity.stat();
      }
    }
    
    files.sort((a, b) {
      final statA = fileStats[a]!;
      final statB = fileStats[b]!;
      return statA.modified.compareTo(statB.modified);
    });
    
    int sizeToRemove = currentSize - _maxCacheSize;
    
    for (final file in files) {
      if (sizeToRemove <= 0) break;
      
      final fileSize = await file.length();
      await file.delete();
      sizeToRemove -= fileSize;
    }
  }

  Future<void> dispose() async {
    _initialized = false;
  }
}
