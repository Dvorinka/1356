import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/goal_model.dart';
import '../models/goal_step_model.dart';
import '../../core/errors/failure.dart';

class GoalsRepository {
  final supabase.SupabaseClient _client;
  static const int maxGoals = 20;

  GoalsRepository(this._client);

  Future<List<Goal>> getGoals(String userId) async {
    try {
      final response = await _client
          .from('goals')
          .select()
          .eq('owner_id', userId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Goal.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Goal> getGoal(String goalId) async {
    try {
      final response = await _client
          .from('goals')
          .select()
          .eq('id', goalId)
          .single();

      return Goal.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Goal> createGoal(Goal goal) async {
    try {
      final response = await _client
          .from('goals')
          .insert(goal.toJson())
          .select()
          .single();

      return Goal.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Goal> updateGoal(Goal goal) async {
    try {
      final updates = goal.toJson();
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('goals')
          .update(updates)
          .eq('id', goal.id)
          .select()
          .single();

      return Goal.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> canModifyGoals(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select('countdown_start_date')
          .eq('id', userId)
          .single();

      final countdownStartDate = response['countdown_start_date'];
      return countdownStartDate == null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await _client.from('goals').delete().eq('id', goalId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<GoalStep>> getGoalSteps(String goalId) async {
    try {
      final response = await _client
          .from('goal_steps')
          .select()
          .eq('goal_id', goalId)
          .order('order_index', ascending: true);

      return (response as List).map((json) => GoalStep.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<GoalStep> createGoalStep(GoalStep step) async {
    try {
      final response = await _client
          .from('goal_steps')
          .insert(step.toJson())
          .select()
          .single();

      return GoalStep.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<GoalStep> updateGoalStep(GoalStep step) async {
    try {
      final response = await _client
          .from('goal_steps')
          .update(step.toJson())
          .eq('id', step.id)
          .select()
          .single();

      return GoalStep.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteGoalStep(String stepId) async {
    try {
      await _client.from('goal_steps').delete().eq('id', stepId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<int> getGoalsCount(String userId) async {
    try {
      final response = await _client
          .from('goals')
          .select('id')
          .eq('owner_id', userId);

      return (response as List).length;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Failure _handleError(dynamic error) {
    if (error is supabase.PostgrestException) {
      if (error.code == '23505') {
        return const ValidationFailure('A goal with this title already exists');
      }
      return ServerFailure(error.message);
    }
    return UnknownFailure(error.toString());
  }
}
