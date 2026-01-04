import 'dart:developer' as developer;

import 'package:hive/hive.dart';
import '../models/offline_mutation_model.dart';

class OfflineMutationQueue {
  static const String _mutationsBoxName = 'offline_mutations';
  late Box<OfflineMutation> _mutationsBox;

  Future<void> init() async {
    _mutationsBox = await Hive.openBox<OfflineMutation>(_mutationsBoxName);
  }

  Future<void> enqueueMutation(OfflineMutation mutation) async {
    await _mutationsBox.put(mutation.id, mutation);
  }

  Future<List<OfflineMutation>> getPendingMutations() async {
    return _mutationsBox.values
        .where((mutation) => !mutation.isSynced)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<void> markMutationAsSynced(String mutationId) async {
    final mutation = _mutationsBox.get(mutationId);
    if (mutation != null) {
      await _mutationsBox.put(
        mutationId,
        mutation.copyWith(
          isSynced: true,
          syncedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> removeSyncedMutations() async {
    final syncedMutations = _mutationsBox.values
        .where((mutation) => mutation.isSynced)
        .toList();
    
    for (var mutation in syncedMutations) {
      await _mutationsBox.delete(mutation.id);
    }
  }

  Future<void> clearMutation(String mutationId) async {
    await _mutationsBox.delete(mutationId);
  }

  Future<void> clearAllMutations() async {
    await _mutationsBox.clear();
  }

  Future<int> getPendingMutationCount() async {
    return _mutationsBox.values.where((m) => !m.isSynced).length;
  }

  Future<void> syncPendingMutations({
    required Future<void> Function(OfflineMutation) onSync,
  }) async {
    final pendingMutations = await getPendingMutations();
    
    for (var mutation in pendingMutations) {
      try {
        await onSync(mutation);
        await markMutationAsSynced(mutation.id);
      } catch (e, stackTrace) {
        // Log error but continue with next mutation
        developer.log(
          'Error syncing mutation ${mutation.id}: $e',
          name: 'OfflineMutationQueue',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }
    
    await removeSyncedMutations();
  }

  Future<void> close() async {
    await _mutationsBox.close();
  }
}
